using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace JivanBandhan4
{
    public partial class Shortlisted : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    int userID = Convert.ToInt32(Session["UserID"]);
                    hdnCurrentUserID.Value = userID.ToString();
                    LoadShortlistedProfiles(userID);
                    LoadShortlistStats(userID);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadShortlistedProfiles(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
                            u.Education, u.Caste, u.Religion, u.Gender,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
                                 THEN 1 ELSE 0 END as IsPremium,
                            s.ShortlistedDate
                        FROM Shortlists s
                        INNER JOIN Users u ON s.ShortlistedUserID = u.UserID
                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
                        WHERE s.UserID = @UserID
                        ORDER BY s.ShortlistedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptShortlistedProfiles.DataSource = dt;
                            rptShortlistedProfiles.DataBind();
                            pnlNoShortlisted.Visible = false;

                            // Update count
                            lblShortlistCount.Text = dt.Rows.Count.ToString();
                        }
                        else
                        {
                            rptShortlistedProfiles.DataSource = null;
                            rptShortlistedProfiles.DataBind();
                            pnlNoShortlisted.Visible = true;
                            lblShortlistCount.Text = "0";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadShortlistedProfiles error: " + ex.Message);
                pnlNoShortlisted.Visible = true;
            }
        }

        private void LoadShortlistStats(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Total shortlisted
                    string totalQuery = "SELECT COUNT(*) FROM Shortlists WHERE UserID = @UserID";
                    SqlCommand totalCmd = new SqlCommand(totalQuery, conn);
                    totalCmd.Parameters.AddWithValue("@UserID", userID);
                    lblTotalShortlisted.Text = totalCmd.ExecuteScalar().ToString();

                    // Active profiles (profiles that were active in last 30 days)
                    string activeQuery = @"
                        SELECT COUNT(DISTINCT s.ShortlistedUserID) 
                        FROM Shortlists s
                        INNER JOIN Users u ON s.ShortlistedUserID = u.UserID
                        WHERE s.UserID = @UserID 
                        AND u.LastActiveDate > DATEADD(DAY, -30, GETDATE())";
                    SqlCommand activeCmd = new SqlCommand(activeQuery, conn);
                    activeCmd.Parameters.AddWithValue("@UserID", userID);
                    lblActiveProfiles.Text = activeCmd.ExecuteScalar().ToString();

                    // Premium profiles
                    string premiumQuery = @"
                        SELECT COUNT(DISTINCT s.ShortlistedUserID) 
                        FROM Shortlists s
                        INNER JOIN UserMemberships um ON s.ShortlistedUserID = um.UserID 
                        WHERE s.UserID = @UserID 
                        AND um.ExpiryDate > GETDATE()";
                    SqlCommand premiumCmd = new SqlCommand(premiumQuery, conn);
                    premiumCmd.Parameters.AddWithValue("@UserID", userID);
                    lblPremiumProfiles.Text = premiumCmd.ExecuteScalar().ToString();

                    // Recent additions (last 7 days)
                    string recentQuery = @"
                        SELECT COUNT(*) 
                        FROM Shortlists 
                        WHERE UserID = @UserID 
                        AND ShortlistedDate > DATEADD(DAY, -7, GETDATE())";
                    SqlCommand recentCmd = new SqlCommand(recentQuery, conn);
                    recentCmd.Parameters.AddWithValue("@UserID", userID);
                    lblRecentAdditions.Text = recentCmd.ExecuteScalar().ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadShortlistStats error: " + ex.Message);
                // Set default values
                lblTotalShortlisted.Text = "0";
                lblActiveProfiles.Text = "0";
                lblPremiumProfiles.Text = "0";
                lblRecentAdditions.Text = "0";
            }
        }

        protected void rptShortlistedProfiles_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Add error handling for images
                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
                if (imgProfile != null)
                {
                    imgProfile.Attributes["onerror"] = "this.src='Images/default-profile.jpg'";
                }

                // Set age
                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
                if (ltAge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltAge.Text = CalculateAgeInline(row["DateOfBirth"]);
                }

                // Set premium badge visibility
                HtmlGenericControl premiumBadge = (HtmlGenericControl)e.Item.FindControl("premiumBadge");
                if (premiumBadge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    bool isPremium = Convert.ToBoolean(row["IsPremium"]);
                    premiumBadge.Visible = isPremium;

                    if (isPremium)
                    {
                        premiumBadge.Attributes["class"] = "premium-badge";
                        premiumBadge.InnerText = "⭐ Premium";
                    }
                }
            }
        }

        // Inline method for age calculation
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
            catch (Exception)
            {
                return "NA";
            }
        }

        [WebMethod]
        public static string RemoveFromShortlist(int userID, int shortlistedUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "DELETE FROM Shortlists WHERE UserID = @UserID AND ShortlistedUserID = @ShortlistedUserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        cmd.Parameters.AddWithValue("@ShortlistedUserID", shortlistedUserID);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

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
                System.Diagnostics.Debug.WriteLine("RemoveFromShortlist error: " + ex.Message);
                return "error";
            }
        }

        protected void btnBrowseProfiles_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }
}