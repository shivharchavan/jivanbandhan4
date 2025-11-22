using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
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

                    // Set hidden fields
                    hdnCurrentUserID.Value = userID.ToString();
                    hdnCurrentUserGender.Value = Session["Gender"]?.ToString() ?? "";
                    hdnCurrentUserMembership.Value = GetUserMembership(userID);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private string GetUserMembership(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 MembershipType 
                                   FROM UserMemberships 
                                   WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
                                   ORDER BY ExpiryDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        return result != null ? result.ToString() : "Free";
                    }
                }
            }
            catch
            {
                return "Free";
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
                            pv.ViewDate,
                            u.UserID as ViewerUserID,
                            u.FullName as ViewerName,
                            u.DateOfBirth as ViewerDOB,
                            u.Occupation as ViewerOccupation,
                            u.City as ViewerCity,
                            u.State as ViewerState,
                            u.Education as ViewerEducation,
                            u.Religion as ViewerReligion,
                            u.Caste as ViewerCaste,
                            u.Phone as ViewerPhone,
                            u.Gender as ViewerGender,
                            ISNULL(um.MembershipType, 'Free') as ViewerMembershipType,
                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() THEN 1 ELSE 0 END as IsViewerPremium,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as ViewerAge
                        FROM ProfileViews pv
                        INNER JOIN Users u ON pv.ViewedByUserID = u.UserID
                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
                        WHERE pv.UserID = @UserID
                        AND u.UserID NOT IN (
                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @UserID
                            UNION
                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @UserID
                        )
                        AND u.IsActive = 1
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
                            rptProfileViewsTable.DataSource = dt;
                            rptProfileViewsTable.DataBind();

                            pnlNoViews.Visible = false;
                            pnlNoViewsTable.Visible = false;
                        }
                        else
                        {
                            rptProfileViews.DataSource = null;
                            rptProfileViews.DataBind();
                            rptProfileViewsTable.DataSource = null;
                            rptProfileViewsTable.DataBind();

                            pnlNoViews.Visible = true;
                            pnlNoViewsTable.Visible = true;
                        }
                    }
                }
            }
            catch
            {
                pnlNoViews.Visible = true;
                pnlNoViewsTable.Visible = true;
            }
        }

        private void LoadViewStats(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string totalQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID";
                    using (SqlCommand totalCmd = new SqlCommand(totalQuery, conn))
                    {
                        totalCmd.Parameters.AddWithValue("@UserID", userID);
                        totalViewsCount.InnerText = totalCmd.ExecuteScalar().ToString();
                    }

                    string todayQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID AND CAST(ViewDate AS DATE) = CAST(GETDATE() AS DATE)";
                    using (SqlCommand todayCmd = new SqlCommand(todayQuery, conn))
                    {
                        todayCmd.Parameters.AddWithValue("@UserID", userID);
                        todayViewsCount.InnerText = todayCmd.ExecuteScalar().ToString();
                    }

                    string weekQuery = @"SELECT COUNT(*) FROM ProfileViews 
                                       WHERE UserID = @UserID 
                                       AND ViewDate >= DATEADD(DAY, -7, GETDATE())";
                    using (SqlCommand weekCmd = new SqlCommand(weekQuery, conn))
                    {
                        weekCmd.Parameters.AddWithValue("@UserID", userID);
                        weekViewsCount.InnerText = weekCmd.ExecuteScalar().ToString();
                    }

                    string monthQuery = @"SELECT COUNT(*) FROM ProfileViews 
                                        WHERE UserID = @UserID 
                                        AND ViewDate >= DATEADD(DAY, -30, GETDATE())";
                    using (SqlCommand monthCmd = new SqlCommand(monthQuery, conn))
                    {
                        monthCmd.Parameters.AddWithValue("@UserID", userID);
                        monthViewsCount.InnerText = monthCmd.ExecuteScalar().ToString();
                    }
                }
            }
            catch
            {
                totalViewsCount.InnerText = "0";
                todayViewsCount.InnerText = "0";
                weekViewsCount.InnerText = "0";
                monthViewsCount.InnerText = "0";
            }
        }

        protected void rptProfileViews_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
                HtmlGenericControl profileHeaderBackground = (HtmlGenericControl)e.Item.FindControl("profileHeaderBackground");
                HtmlGenericControl contactNumberDisplay = (HtmlGenericControl)e.Item.FindControl("contactNumberDisplay");
                HtmlGenericControl contactLocked = (HtmlGenericControl)e.Item.FindControl("contactLocked");
                HtmlButton btnViewContact = (HtmlButton)e.Item.FindControl("btnViewContact");
                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
                Literal ltContactNumber = (Literal)e.Item.FindControl("ltContactNumber");

                DataRowView row = (DataRowView)e.Item.DataItem;
                int profileUserID = Convert.ToInt32(row["ViewerUserID"]);

                string photoUrl = LoadProfilePhoto(profileUserID, imgProfile);
                if (!string.IsNullOrEmpty(photoUrl) && photoUrl != ResolveUrl("~/Images/default-profile.jpg"))
                {
                    profileHeaderBackground.Style.Add("background-image", $"url('{photoUrl}')");
                    profileHeaderBackground.Style.Add("position", "relative");
                    profileHeaderBackground.Style.Add("background-size", "cover");
                    profileHeaderBackground.Style.Add("background-position", "center");
                    profileHeaderBackground.Style.Add("background-blend-mode", "overlay");
                    profileHeaderBackground.Style.Add("background-color", "rgba(0,0,0,0.3)");
                }

                if (ltAge != null)
                {
                    ltAge.Text = CalculateAgeInline(row["ViewerDOB"]);
                }

                if (ltContactNumber != null)
                {
                    string phoneNumber = row["ViewerPhone"] != DBNull.Value ? row["ViewerPhone"].ToString() : "";
                    ltContactNumber.Text = phoneNumber;
                }

                string currentUserMembership = hdnCurrentUserMembership.Value;
                bool canViewContact = currentUserMembership == "Silver" || currentUserMembership == "Gold" || currentUserMembership == "Platinum";

                if (canViewContact)
                {
                    contactNumberDisplay.Style["display"] = "none";
                    contactLocked.Style["display"] = "none";
                    btnViewContact.Style["display"] = "block";
                }
                else
                {
                    contactNumberDisplay.Style["display"] = "none";
                    contactLocked.Style["display"] = "block";
                    btnViewContact.Style["display"] = "block";
                }
            }
        }

        protected void rptProfileViewsTable_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                System.Web.UI.WebControls.Image imgViewerTable = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgViewerTable");
                Literal ltViewerAgeTable = (Literal)e.Item.FindControl("ltViewerAgeTable");

                DataRowView row = (DataRowView)e.Item.DataItem;
                int viewerUserID = Convert.ToInt32(row["ViewerUserID"]);

                LoadProfilePhoto(viewerUserID, imgViewerTable);

                if (ltViewerAgeTable != null)
                {
                    ltViewerAgeTable.Text = CalculateAgeInline(row["ViewerDOB"]);
                }
            }
        }

        private string LoadProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsActive = 1
                                   ORDER BY IsProfilePhoto DESC, UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            string photoPath = result.ToString();
                            string resolvedPath = ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
                            imgControl.ImageUrl = resolvedPath;
                            return resolvedPath;
                        }
                        else
                        {
                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
                            return ResolveUrl("~/Images/default-profile.jpg");
                        }
                    }
                }
            }
            catch
            {
                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
                return ResolveUrl("~/Images/default-profile.jpg");
            }
        }

        public string GetProfilePhotoUrl(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsActive = 1
                                   ORDER BY IsProfilePhoto DESC, UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            return ResolveUrl("~/Uploads/" + userID + "/" + result.ToString());
                        }
                    }
                }
            }
            catch
            {
            }
            return ResolveUrl("~/Images/default-profile.jpg");
        }

        public string CalculateAgeInline(object dob)
        {
            try
            {
                if (dob == null || dob == DBNull.Value || string.IsNullOrEmpty(dob.ToString()))
                    return "NA";

                DateTime birthDate = Convert.ToDateTime(dob);
                int age = DateTime.Now.Year - birthDate.Year;
                if (DateTime.Now.DayOfYear < birthDate.DayOfYear)
                    age--;

                return age.ToString();
            }
            catch
            {
                return "NA";
            }
        }

        public string GetMembershipTagClass(object membershipType)
        {
            if (membershipType == null || membershipType == DBNull.Value)
                return "tag-free";

            string type = membershipType.ToString().ToLower();
            return $"tag-{type}";
        }

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
                            CreateNotification(targetUserID, sentByUserID, "Interest", "ने तुमच्यावर रस दाखवला आहे");
                            return "success";
                        }
                        else
                        {
                            return "error";
                        }
                    }
                }
            }
            catch
            {
                return "error";
            }
        }

        [WebMethod]
        public static string SendMessage(int fromUserID, int toUserID, string messageText)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                if (IsBlocked(fromUserID, toUserID))
                {
                    return "blocked";
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO Messages (FromUserID, ToUserID, MessageText, SentDate, IsRead, IsActive)
                                   VALUES (@FromUserID, @ToUserID, @MessageText, GETDATE(), 0, 1)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FromUserID", fromUserID);
                        cmd.Parameters.AddWithValue("@ToUserID", toUserID);
                        cmd.Parameters.AddWithValue("@MessageText", messageText);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            CreateNotification(toUserID, fromUserID, "Message", "ने तुम्हाला एक संदेश पाठवला आहे");
                            return "success";
                        }
                        else
                        {
                            return "error";
                        }
                    }
                }
            }
            catch
            {
                return "error";
            }
        }

        [WebMethod]
        public static bool CheckIfBlocked(int currentUserID, int targetUserID)
        {
            return IsBlocked(currentUserID, targetUserID);
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
            catch
            {
                return false;
            }
        }

        [WebMethod]
        public static string ShortlistProfile(int userID, int shortlistedUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string checkQuery = "SELECT COUNT(*) FROM Shortlists WHERE UserID = @UserID AND ShortlistedUserID = @ShortlistedUserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@UserID", userID);
                        checkCmd.Parameters.AddWithValue("@ShortlistedUserID", shortlistedUserID);
                        conn.Open();
                        int existingCount = (int)checkCmd.ExecuteScalar();

                        if (existingCount > 0)
                        {
                            return "exists";
                        }
                    }

                    string insertQuery = @"INSERT INTO Shortlists (UserID, ShortlistedUserID, ShortlistedDate) 
                                         VALUES (@UserID, @ShortlistedUserID, GETDATE())";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@UserID", userID);
                        insertCmd.Parameters.AddWithValue("@ShortlistedUserID", shortlistedUserID);
                        int rowsAffected = insertCmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            CreateNotification(shortlistedUserID, userID, "Shortlist", "ने तुम्हाला शॉर्टलिस्ट केले आहे");
                            return "success";
                        }
                        else
                        {
                            return "error";
                        }
                    }
                }
            }
            catch
            {
                return "error";
            }
        }

        [WebMethod]
        public static string BlockUser(int blockedByUserID, int blockedUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string checkQuery = @"SELECT COUNT(*) FROM BlockedUsers 
                                WHERE BlockedByUserID = @BlockedByUserID 
                                AND BlockedUserID = @BlockedUserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@BlockedByUserID", blockedByUserID);
                        checkCmd.Parameters.AddWithValue("@BlockedUserID", blockedUserID);
                        conn.Open();
                        int existingCount = (int)checkCmd.ExecuteScalar();

                        if (existingCount > 0)
                        {
                            return "exists";
                        }
                    }

                    string insertQuery = @"INSERT INTO BlockedUsers (BlockedByUserID, BlockedUserID, BlockedDate) 
                                 VALUES (@BlockedByUserID, @BlockedUserID, GETDATE())";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@BlockedByUserID", blockedByUserID);
                        insertCmd.Parameters.AddWithValue("@BlockedUserID", blockedUserID);
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
            catch
            {
                return "error";
            }
        }

        [WebMethod]
        public static string ReportUser(int reportedByUserID, int reportedUserID, string reportReason)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string insertQuery = @"INSERT INTO ReportedUsers (ReportedByUserID, ReportedUserID, ReportReason, ReportedDate, Status) 
                                 VALUES (@ReportedByUserID, @ReportedUserID, @ReportReason, GETDATE(), 'Pending')";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@ReportedByUserID", reportedByUserID);
                        insertCmd.Parameters.AddWithValue("@ReportedUserID", reportedUserID);
                        insertCmd.Parameters.AddWithValue("@ReportReason", reportReason);
                        conn.Open();
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
            catch
            {
                return "error";
            }
        }

        [WebMethod]
        public static string LogContactView(int viewerUserID, int profileUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO ContactViews (ViewerUserID, ProfileUserID, ViewedDate) 
                                   VALUES (@ViewerUserID, @ProfileUserID, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ViewerUserID", viewerUserID);
                        cmd.Parameters.AddWithValue("@ProfileUserID", profileUserID);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            CreateNotification(profileUserID, viewerUserID, "ProfileView", "ने तुमचे प्रोफाइल पाहिले");
                            return "success";
                        }
                        else
                        {
                            return "error";
                        }
                    }
                }
            }
            catch
            {
                return "error";
            }
        }

        private static void CreateNotification(int userID, int fromUserID, string notificationType, string messageSuffix)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string userNameQuery = "SELECT FullName FROM Users WHERE UserID = @FromUserID";
                    string fromUserName = "";

                    using (SqlCommand userNameCmd = new SqlCommand(userNameQuery, conn))
                    {
                        userNameCmd.Parameters.AddWithValue("@FromUserID", fromUserID);
                        conn.Open();
                        object result = userNameCmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            fromUserName = result.ToString();
                        }
                        else
                        {
                            fromUserName = "एक वापरकर्ता";
                        }
                    }

                    string message = fromUserName + " " + messageSuffix;

                    string insertQuery = @"INSERT INTO Notifications (UserID, FromUserID, NotificationType, Message, IsRead, CreatedDate)
                                         VALUES (@UserID, @FromUserID, @NotificationType, @Message, 0, GETDATE())";

                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@UserID", userID);
                        insertCmd.Parameters.AddWithValue("@FromUserID", fromUserID);
                        insertCmd.Parameters.AddWithValue("@NotificationType", notificationType);
                        insertCmd.Parameters.AddWithValue("@Message", message);
                        insertCmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
            }
        }
    }
}





















//using System;
//using System.Collections.Generic;
//using System.Data;
//using System.Data.SqlClient;
//using System.Linq;
//using System.Web.Services;
//using System.Web.UI;
//using System.Web.UI.HtmlControls;
//using System.Web.UI.WebControls;

//namespace JivanBandhan4
//{
//    public partial class TotalViews : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                if (Session["UserID"] != null)
//                {
//                    int userID = Convert.ToInt32(Session["UserID"]);
//                    LoadProfileViews(userID);
//                    LoadViewStats(userID);

//                    // Set hidden fields
//                    hdnCurrentUserID.Value = userID.ToString();
//                    hdnCurrentUserGender.Value = Session["Gender"]?.ToString() ?? "";
//                    hdnCurrentUserMembership.Value = GetUserMembership(userID);
//                }
//                else
//                {
//                    Response.Redirect("Login.aspx");
//                }
//            }
//        }

//        private string GetUserMembership(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 MembershipType 
//                                   FROM UserMemberships 
//                                   WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
//                                   ORDER BY ExpiryDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();
//                        return result != null ? result.ToString() : "Free";
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return "Free";
//            }
//        }

//        private void LoadProfileViews(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Modified query to get complete user profile information for viewers
//                    string query = @"
//                        SELECT 
//                            pv.ViewID,
//                            pv.ViewDate,
//                            u.UserID,
//                            u.FullName,
//                            u.DateOfBirth,
//                            u.Occupation,
//                            u.City,
//                            u.State,
//                            u.Education,
//                            u.Religion,
//                            u.Caste,
//                            u.Phone,
//                            u.Gender,
//                            u.MaritalStatus,
//                            u.Height,
//                            u.Income,
//                            u.AboutMe,
//                            ISNULL(um.MembershipType, 'Free') as MembershipType,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() THEN 1 ELSE 0 END as IsPremium,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age
//                        FROM ProfileViews pv
//                        INNER JOIN Users u ON pv.ViewerUserID = u.UserID
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE pv.UserID = @UserID
//                        AND u.UserID NOT IN (
//                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @UserID
//                            UNION
//                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @UserID
//                        )
//                        AND u.IsActive = 1
//                        ORDER BY pv.ViewDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.HasRows)
//                        {
//                            DataTable dt = new DataTable();
//                            dt.Load(reader);
//                            rptProfileViews.DataSource = dt;
//                            rptProfileViews.DataBind();
//                            pnlNoViews.Visible = false;
//                        }
//                        else
//                        {
//                            rptProfileViews.DataSource = null;
//                            rptProfileViews.DataBind();
//                            pnlNoViews.Visible = true;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                pnlNoViews.Visible = true;
//                System.Diagnostics.Debug.WriteLine("LoadProfileViews error: " + ex.Message);
//            }
//        }

//        private void LoadViewStats(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Total Views
//                    string totalQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID";
//                    using (SqlCommand totalCmd = new SqlCommand(totalQuery, conn))
//                    {
//                        totalCmd.Parameters.AddWithValue("@UserID", userID);
//                        totalViewsCount.InnerText = totalCmd.ExecuteScalar().ToString();
//                    }

//                    // Today's Views
//                    string todayQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID AND CAST(ViewDate AS DATE) = CAST(GETDATE() AS DATE)";
//                    using (SqlCommand todayCmd = new SqlCommand(todayQuery, conn))
//                    {
//                        todayCmd.Parameters.AddWithValue("@UserID", userID);
//                        todayViewsCount.InnerText = todayCmd.ExecuteScalar().ToString();
//                    }

//                    // This Week's Views
//                    string weekQuery = @"SELECT COUNT(*) FROM ProfileViews 
//                                       WHERE UserID = @UserID 
//                                       AND ViewDate >= DATEADD(DAY, -7, GETDATE())";
//                    using (SqlCommand weekCmd = new SqlCommand(weekQuery, conn))
//                    {
//                        weekCmd.Parameters.AddWithValue("@UserID", userID);
//                        weekViewsCount.InnerText = weekCmd.ExecuteScalar().ToString();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                totalViewsCount.InnerText = "0";
//                todayViewsCount.InnerText = "0";
//                weekViewsCount.InnerText = "0";
//            }
//        }

//        protected void rptProfileViews_ItemDataBound(object sender, RepeaterItemEventArgs e)
//        {
//            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
//            {
//                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
//                HtmlGenericControl profileHeaderBackground = (HtmlGenericControl)e.Item.FindControl("profileHeaderBackground");
//                HtmlGenericControl contactNumberDisplay = (HtmlGenericControl)e.Item.FindControl("contactNumberDisplay");
//                HtmlGenericControl contactLocked = (HtmlGenericControl)e.Item.FindControl("contactLocked");
//                HtmlButton btnViewContact = (HtmlButton)e.Item.FindControl("btnViewContact");
//                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
//                Literal ltContactNumber = (Literal)e.Item.FindControl("ltContactNumber");

//                DataRowView row = (DataRowView)e.Item.DataItem;
//                int profileUserID = Convert.ToInt32(row["UserID"]);

//                // Load profile photo
//                string photoUrl = LoadProfilePhoto(profileUserID, imgProfile);
//                if (!string.IsNullOrEmpty(photoUrl) && photoUrl != ResolveUrl("~/Images/default-profile.jpg"))
//                {
//                    profileHeaderBackground.Style.Add("background-image", $"url('{photoUrl}')");
//                    profileHeaderBackground.Style.Add("position", "relative");
//                    profileHeaderBackground.Style.Add("background-size", "cover");
//                    profileHeaderBackground.Style.Add("background-position", "center");
//                    profileHeaderBackground.Style.Add("background-blend-mode", "overlay");
//                    profileHeaderBackground.Style.Add("background-color", "rgba(0,0,0,0.3)");
//                }

//                // Set age
//                if (ltAge != null)
//                {
//                    ltAge.Text = CalculateAgeInline(row["DateOfBirth"]);
//                }

//                // Set contact number
//                if (ltContactNumber != null)
//                {
//                    string phoneNumber = row["Phone"] != DBNull.Value ? row["Phone"].ToString() : "";
//                    ltContactNumber.Text = phoneNumber;
//                }

//                // Contact number visibility based on membership
//                string currentUserMembership = hdnCurrentUserMembership.Value;
//                bool canViewContact = currentUserMembership == "Silver" || currentUserMembership == "Gold" || currentUserMembership == "Platinum";

//                if (canViewContact)
//                {
//                    contactNumberDisplay.Style["display"] = "none";
//                    contactLocked.Style["display"] = "none";
//                    btnViewContact.Style["display"] = "block";
//                }
//                else
//                {
//                    contactNumberDisplay.Style["display"] = "none";
//                    contactLocked.Style["display"] = "block";
//                    btnViewContact.Style["display"] = "block";
//                }
//            }
//        }

//        private string LoadProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                   WHERE UserID = @UserID AND IsActive = 1
//                                   ORDER BY IsProfilePhoto DESC, UploadDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();

//                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
//                        {
//                            string photoPath = result.ToString();
//                            string resolvedPath = ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
//                            imgControl.ImageUrl = resolvedPath;
//                            return resolvedPath;
//                        }
//                        else
//                        {
//                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                            return ResolveUrl("~/Images/default-profile.jpg");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                return ResolveUrl("~/Images/default-profile.jpg");
//            }
//        }

//        // Helper method to get profile photo URL
//        public string GetProfilePhotoUrl(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                   WHERE UserID = @UserID AND IsActive = 1
//                                   ORDER BY IsProfilePhoto DESC, UploadDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();

//                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
//                        {
//                            return ResolveUrl("~/Uploads/" + userID + "/" + result.ToString());
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error
//            }
//            return ResolveUrl("~/Images/default-profile.jpg");
//        }

//        public string CalculateAgeInline(object dob)
//        {
//            try
//            {
//                if (dob == null || dob == DBNull.Value || string.IsNullOrEmpty(dob.ToString()))
//                    return "NA";

//                DateTime birthDate = Convert.ToDateTime(dob);
//                int age = DateTime.Now.Year - birthDate.Year;
//                if (DateTime.Now.DayOfYear < birthDate.DayOfYear)
//                    age--;

//                return age.ToString();
//            }
//            catch (Exception)
//            {
//                return "NA";
//            }
//        }

//        public string GetMembershipTagClass(object membershipType)
//        {
//            if (membershipType == null || membershipType == DBNull.Value)
//                return "tag-free";

//            string type = membershipType.ToString().ToLower();
//            return $"tag-{type}";
//        }

//        public string GetTimeAgo(DateTime viewDate)
//        {
//            TimeSpan timeSpan = DateTime.Now - viewDate;

//            if (timeSpan.TotalMinutes < 1)
//                return "just now";
//            if (timeSpan.TotalMinutes < 60)
//                return $"{(int)timeSpan.TotalMinutes} minutes ago";
//            if (timeSpan.TotalHours < 24)
//                return $"{(int)timeSpan.TotalHours} hours ago";
//            if (timeSpan.TotalDays < 7)
//                return $"{(int)timeSpan.TotalDays} days ago";

//            return viewDate.ToString("dd MMM yyyy");
//        }

//        [WebMethod]
//        public static string SendInterest(int sentByUserID, int targetUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                // Check if users are blocked
//                if (IsBlocked(sentByUserID, targetUserID))
//                {
//                    return "blocked";
//                }

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string checkQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @SentByUserID AND TargetUserID = @TargetUserID";
//                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
//                    {
//                        checkCmd.Parameters.AddWithValue("@SentByUserID", sentByUserID);
//                        checkCmd.Parameters.AddWithValue("@TargetUserID", targetUserID);
//                        conn.Open();
//                        int existingCount = (int)checkCmd.ExecuteScalar();

//                        if (existingCount > 0)
//                        {
//                            return "exists";
//                        }
//                    }

//                    string insertQuery = @"INSERT INTO Interests (SentByUserID, TargetUserID, SentDate, Status) 
//                                         VALUES (@SentByUserID, @TargetUserID, GETDATE(), 'Pending')";
//                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
//                    {
//                        insertCmd.Parameters.AddWithValue("@SentByUserID", sentByUserID);
//                        insertCmd.Parameters.AddWithValue("@TargetUserID", targetUserID);
//                        int rowsAffected = insertCmd.ExecuteNonQuery();

//                        if (rowsAffected > 0)
//                        {
//                            // Create notification for the target user
//                            CreateNotification(targetUserID, sentByUserID, "Interest", "ने तुमच्यावर रस दाखवला आहे");
//                            return "success";
//                        }
//                        else
//                        {
//                            return "error";
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static string SendMessage(int fromUserID, int toUserID, string messageText)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                if (IsBlocked(fromUserID, toUserID))
//                {
//                    return "blocked";
//                }

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"INSERT INTO Messages (FromUserID, ToUserID, MessageText, SentDate, IsRead, IsActive)
//                                   VALUES (@FromUserID, @ToUserID, @MessageText, GETDATE(), 0, 1)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@FromUserID", fromUserID);
//                        cmd.Parameters.AddWithValue("@ToUserID", toUserID);
//                        cmd.Parameters.AddWithValue("@MessageText", messageText);

//                        conn.Open();
//                        int rowsAffected = cmd.ExecuteNonQuery();

//                        if (rowsAffected > 0)
//                        {
//                            // Create notification for the recipient
//                            CreateNotification(toUserID, fromUserID, "Message", "ने तुम्हाला एक संदेश पाठवला आहे");
//                            return "success";
//                        }
//                        else
//                        {
//                            return "error";
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static bool CheckIfBlocked(int currentUserID, int targetUserID)
//        {
//            return IsBlocked(currentUserID, targetUserID);
//        }

//        private static bool IsBlocked(int user1ID, int user2ID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT COUNT(*) FROM BlockedUsers 
//                                   WHERE (BlockedByUserID = @User1ID AND BlockedUserID = @User2ID)
//                                   OR (BlockedByUserID = @User2ID AND BlockedUserID = @User1ID)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
//                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
//                        conn.Open();
//                        int count = (int)cmd.ExecuteScalar();
//                        return count > 0;
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return false;
//            }
//        }

//        [WebMethod]
//        public static string ShortlistProfile(int userID, int shortlistedUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string checkQuery = "SELECT COUNT(*) FROM Shortlists WHERE UserID = @UserID AND ShortlistedUserID = @ShortlistedUserID";
//                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
//                    {
//                        checkCmd.Parameters.AddWithValue("@UserID", userID);
//                        checkCmd.Parameters.AddWithValue("@ShortlistedUserID", shortlistedUserID);
//                        conn.Open();
//                        int existingCount = (int)checkCmd.ExecuteScalar();

//                        if (existingCount > 0)
//                        {
//                            return "exists";
//                        }
//                    }

//                    string insertQuery = @"INSERT INTO Shortlists (UserID, ShortlistedUserID, ShortlistedDate) 
//                                         VALUES (@UserID, @ShortlistedUserID, GETDATE())";
//                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
//                    {
//                        insertCmd.Parameters.AddWithValue("@UserID", userID);
//                        insertCmd.Parameters.AddWithValue("@ShortlistedUserID", shortlistedUserID);
//                        int rowsAffected = insertCmd.ExecuteNonQuery();

//                        if (rowsAffected > 0)
//                        {
//                            // Create notification for the shortlisted user
//                            CreateNotification(shortlistedUserID, userID, "Shortlist", "ने तुम्हाला शॉर्टलिस्ट केले आहे");
//                            return "success";
//                        }
//                        else
//                        {
//                            return "error";
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static string BlockUser(int blockedByUserID, int blockedUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string checkQuery = @"SELECT COUNT(*) FROM BlockedUsers 
//                                WHERE BlockedByUserID = @BlockedByUserID 
//                                AND BlockedUserID = @BlockedUserID";
//                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
//                    {
//                        checkCmd.Parameters.AddWithValue("@BlockedByUserID", blockedByUserID);
//                        checkCmd.Parameters.AddWithValue("@BlockedUserID", blockedUserID);
//                        conn.Open();
//                        int existingCount = (int)checkCmd.ExecuteScalar();

//                        if (existingCount > 0)
//                        {
//                            return "exists";
//                        }
//                    }

//                    string insertQuery = @"INSERT INTO BlockedUsers (BlockedByUserID, BlockedUserID, BlockedDate) 
//                                 VALUES (@BlockedByUserID, @BlockedUserID, GETDATE())";
//                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
//                    {
//                        insertCmd.Parameters.AddWithValue("@BlockedByUserID", blockedByUserID);
//                        insertCmd.Parameters.AddWithValue("@BlockedUserID", blockedUserID);
//                        int rowsAffected = insertCmd.ExecuteNonQuery();

//                        if (rowsAffected > 0)
//                        {
//                            return "success";
//                        }
//                        else
//                        {
//                            return "error";
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static string ReportUser(int reportedByUserID, int reportedUserID, string reportReason)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string insertQuery = @"INSERT INTO ReportedUsers (ReportedByUserID, ReportedUserID, ReportReason, ReportedDate, Status) 
//                                 VALUES (@ReportedByUserID, @ReportedUserID, @ReportReason, GETDATE(), 'Pending')";
//                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
//                    {
//                        insertCmd.Parameters.AddWithValue("@ReportedByUserID", reportedByUserID);
//                        insertCmd.Parameters.AddWithValue("@ReportedUserID", reportedUserID);
//                        insertCmd.Parameters.AddWithValue("@ReportReason", reportReason);
//                        conn.Open();
//                        int rowsAffected = insertCmd.ExecuteNonQuery();

//                        if (rowsAffected > 0)
//                        {
//                            return "success";
//                        }
//                        else
//                        {
//                            return "error";
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static string LogContactView(int viewerUserID, int profileUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"INSERT INTO ContactViews (ViewerUserID, ProfileUserID, ViewedDate) 
//                                   VALUES (@ViewerUserID, @ProfileUserID, GETDATE())";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@ViewerUserID", viewerUserID);
//                        cmd.Parameters.AddWithValue("@ProfileUserID", profileUserID);
//                        conn.Open();
//                        int rowsAffected = cmd.ExecuteNonQuery();

//                        if (rowsAffected > 0)
//                        {
//                            // Create notification for profile view
//                            CreateNotification(profileUserID, viewerUserID, "ProfileView", "ने तुमचे प्रोफाइल पाहिले");
//                            return "success";
//                        }
//                        else
//                        {
//                            return "error";
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        // Helper method to create notifications
//        private static void CreateNotification(int userID, int fromUserID, string notificationType, string messageSuffix)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Get the from user's name
//                    string userNameQuery = "SELECT FullName FROM Users WHERE UserID = @FromUserID";
//                    string fromUserName = "";

//                    using (SqlCommand userNameCmd = new SqlCommand(userNameQuery, conn))
//                    {
//                        userNameCmd.Parameters.AddWithValue("@FromUserID", fromUserID);
//                        conn.Open();
//                        object result = userNameCmd.ExecuteScalar();
//                        if (result != null && result != DBNull.Value)
//                        {
//                            fromUserName = result.ToString();
//                        }
//                        else
//                        {
//                            fromUserName = "एक वापरकर्ता";
//                        }
//                    }

//                    string message = fromUserName + " " + messageSuffix;

//                    string insertQuery = @"INSERT INTO Notifications (UserID, FromUserID, NotificationType, Message, IsRead, CreatedDate)
//                                         VALUES (@UserID, @FromUserID, @NotificationType, @Message, 0, GETDATE())";

//                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
//                    {
//                        insertCmd.Parameters.AddWithValue("@UserID", userID);
//                        insertCmd.Parameters.AddWithValue("@FromUserID", fromUserID);
//                        insertCmd.Parameters.AddWithValue("@NotificationType", notificationType);
//                        insertCmd.Parameters.AddWithValue("@Message", message);
//                        insertCmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error but don't break the main functionality
//                System.Diagnostics.Debug.WriteLine("CreateNotification error: " + ex.Message);
//            }
//        }
//    }
//}
















