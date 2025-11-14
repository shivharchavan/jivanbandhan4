using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JivanBandhan4
{
    public partial class TotalViews : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    int userID = Convert.ToInt32(Session["UserID"]);
                    LoadProfileViews(userID);
                    LoadViewStats(userID);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadProfileViews(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            pv.ViewID,
                            pv.ViewerUserID,
                            pv.ViewDate,
                            u.FullName as ViewerName,
                            u.DateOfBirth as ViewerDOB,
                            u.Occupation as ViewerOccupation,
                            u.City as ViewerCity,
                            u.State as ViewerState,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as ViewerAge
                        FROM ProfileViews pv
                        INNER JOIN Users u ON pv.ViewerUserID = u.UserID
                        WHERE pv.UserID = @UserID
                        AND u.UserID NOT IN (
                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @UserID
                            UNION
                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @UserID
                        )
                        ORDER BY pv.ViewDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptProfileViews.DataSource = dt;
                            rptProfileViews.DataBind();
                            pnlNoViews.Visible = false;
                        }
                        else
                        {
                            rptProfileViews.DataSource = null;
                            rptProfileViews.DataBind();
                            pnlNoViews.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlNoViews.Visible = true;
                System.Diagnostics.Debug.WriteLine("LoadProfileViews error: " + ex.Message);
            }
        }

        private void LoadViewStats(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Total Views
                    string totalQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID";
                    using (SqlCommand totalCmd = new SqlCommand(totalQuery, conn))
                    {
                        totalCmd.Parameters.AddWithValue("@UserID", userID);
                        totalViewsCount.InnerText = totalCmd.ExecuteScalar().ToString();
                    }

                    // Today's Views
                    string todayQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID AND CAST(ViewDate AS DATE) = CAST(GETDATE() AS DATE)";
                    using (SqlCommand todayCmd = new SqlCommand(todayQuery, conn))
                    {
                        todayCmd.Parameters.AddWithValue("@UserID", userID);
                        todayViewsCount.InnerText = todayCmd.ExecuteScalar().ToString();
                    }

                    // This Week's Views
                    string weekQuery = @"SELECT COUNT(*) FROM ProfileViews 
                                       WHERE UserID = @UserID 
                                       AND ViewDate >= DATEADD(DAY, -7, GETDATE())";
                    using (SqlCommand weekCmd = new SqlCommand(weekQuery, conn))
                    {
                        weekCmd.Parameters.AddWithValue("@UserID", userID);
                        weekViewsCount.InnerText = weekCmd.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                totalViewsCount.InnerText = "0";
                todayViewsCount.InnerText = "0";
                weekViewsCount.InnerText = "0";
            }
        }

        protected void rptProfileViews_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Literal ltViewerAge = (Literal)e.Item.FindControl("ltViewerAge");
                System.Web.UI.WebControls.Image imgViewer = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgViewer");

                if (ltViewerAge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    if (row["ViewerDOB"] != DBNull.Value)
                    {
                        DateTime dob = Convert.ToDateTime(row["ViewerDOB"]);
                        int age = DateTime.Now.Year - dob.Year;
                        if (DateTime.Now.DayOfYear < dob.DayOfYear)
                            age--;
                        ltViewerAge.Text = age.ToString();
                    }
                    else
                    {
                        ltViewerAge.Text = "NA";
                    }
                }

                if (imgViewer != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    int viewerUserID = Convert.ToInt32(row["ViewerUserID"]);
                    LoadViewerProfilePhoto(viewerUserID, imgViewer);
                }
            }
        }

        private void LoadViewerProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID 
                                   ORDER BY 
                                       CASE WHEN PhotoType = 'Profile' THEN 1 ELSE 2 END,
                                       UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            string photoPath = result.ToString();
                            imgControl.ImageUrl = ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
                        }
                        else
                        {
                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
            }
        }

        // Add the missing GetTimeAgo method
        public string GetTimeAgo(DateTime viewDate)
        {
            TimeSpan timeSpan = DateTime.Now - viewDate;

            if (timeSpan.TotalMinutes < 1)
                return "just now";
            if (timeSpan.TotalMinutes < 60)
                return $"{(int)timeSpan.TotalMinutes} minutes ago";
            if (timeSpan.TotalHours < 24)
                return $"{(int)timeSpan.TotalHours} hours ago";
            if (timeSpan.TotalDays < 7)
                return $"{(int)timeSpan.TotalDays} days ago";

            return viewDate.ToString("dd MMM yyyy");
        }

        [WebMethod]
        public static string SendInterest(int sentByUserID, int targetUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                // Check if users are blocked
                if (IsBlocked(sentByUserID, targetUserID))
                {
                    return "blocked";
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string checkQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @SentByUserID AND TargetUserID = @TargetUserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@SentByUserID", sentByUserID);
                        checkCmd.Parameters.AddWithValue("@TargetUserID", targetUserID);
                        conn.Open();
                        int existingCount = (int)checkCmd.ExecuteScalar();

                        if (existingCount > 0)
                        {
                            return "exists";
                        }
                    }

                    string insertQuery = @"INSERT INTO Interests (SentByUserID, TargetUserID, SentDate, Status) 
                                         VALUES (@SentByUserID, @TargetUserID, GETDATE(), 'Pending')";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@SentByUserID", sentByUserID);
                        insertCmd.Parameters.AddWithValue("@TargetUserID", targetUserID);
                        int rowsAffected = insertCmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            return "success";
                        }
                        else
                        {
                            return "error";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "error";
            }
        }

        private static bool IsBlocked(int user1ID, int user2ID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT COUNT(*) FROM BlockedUsers 
                                   WHERE (BlockedByUserID = @User1ID AND BlockedUserID = @User2ID)
                                   OR (BlockedByUserID = @User2ID AND BlockedUserID = @User1ID)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
                        conn.Open();
                        int count = (int)cmd.ExecuteScalar();
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}