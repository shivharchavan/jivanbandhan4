


using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace JivanBandhan4
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    int userID = Convert.ToInt32(Session["UserID"]);
                    LoadCurrentUserProfile(userID);
                    LoadOppositeGenderProfiles();
                    LoadUserStats(userID);
                    BindCityDropdown();
                    LoadMembershipInfo(userID);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadCurrentUserProfile(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT UserID, Email, FullName, Gender, DateOfBirth, Occupation, 
                                   City, State, Education, CreatedDate,
                                   DATEDIFF(YEAR, DateOfBirth, GETDATE()) as Age
                                   FROM Users 
                                   WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            lblUserName.Text = reader["FullName"].ToString();
                            lblUserFullName.Text = reader["FullName"].ToString();

                            if (reader["DateOfBirth"] != DBNull.Value)
                            {
                                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
                                int age = DateTime.Now.Year - dob.Year;
                                string occupation = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
                                lblUserAgeOccupation.Text = $"{age} Years | {occupation}";
                            }

                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
                            lblUserLocation.Text = $"{city}, {state}";

                            if (reader["CreatedDate"] != DBNull.Value)
                            {
                                DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
                                lblMemberSince.Text = createdDate.ToString("MMM yyyy");
                            }

                            hdnCurrentUserID.Value = userID.ToString();
                            hdnCurrentUserGender.Value = reader["Gender"].ToString();

                            LoadUserHighQualityProfilePhoto(userID, imgUserPhoto);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadCurrentUserProfile error: " + ex.Message);
            }
        }

        private void LoadMembershipInfo(int userID)
        {
            try
            {
                string membershipType = "Free";
                DateTime? expiryDate = null;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 MembershipType, ExpiryDate 
                                   FROM UserMemberships 
                                   WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
                                   ORDER BY ExpiryDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            membershipType = reader["MembershipType"].ToString();
                            expiryDate = Convert.ToDateTime(reader["ExpiryDate"]);
                        }
                    }
                }

                // Set membership status
                lblMembershipStatus.Text = membershipType;

                // Set membership badge style
                HtmlGenericControl membershipBadge = (HtmlGenericControl)FindControl("membershipBadge");
                if (membershipBadge != null)
                {
                    membershipBadge.InnerText = membershipType;
                    membershipBadge.Attributes["class"] = $"membership-status membership-{membershipType.ToLower()}";
                }

                // Show upgrade prompt for free users
                pnlUpgradePrompt.Visible = (membershipType == "Free");

                // Load remaining limits
                int remainingMessagesCount = GetRemainingMessageCount(userID);
                int remainingInterestsCount = GetRemainingInterestCount(userID);

                // Update the label controls
                Label remainingMessagesControl = (Label)pnlMembershipInfo.FindControl("remainingMessages");
                Label remainingInterestsControl = (Label)pnlMembershipInfo.FindControl("remainingInterests");

                if (remainingMessagesControl != null)
                    remainingMessagesControl.Text = remainingMessagesCount.ToString();

                if (remainingInterestsControl != null)
                    remainingInterestsControl.Text = remainingInterestsCount.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadMembershipInfo error: " + ex.Message);
            }
        }

        // Membership limit methods
        public static int GetRemainingMessageCount(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Check if user has premium membership
                    string membershipQuery = @"SELECT COUNT(*) FROM UserMemberships 
                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
                                             AND MembershipType IN ('Gold', 'Platinum', 'Silver')";

                    using (SqlCommand membershipCmd = new SqlCommand(membershipQuery, conn))
                    {
                        membershipCmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        int hasPremium = (int)membershipCmd.ExecuteScalar();

                        if (hasPremium > 0)
                        {
                            return 999; // Unlimited for premium users
                        }
                    }

                    // For free users, check daily limits
                    string limitQuery = @"SELECT ISNULL(MAX(DailyMessageLimit), 10) FROM UserMemberships 
                                        WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

                    using (SqlCommand limitCmd = new SqlCommand(limitQuery, conn))
                    {
                        limitCmd.Parameters.AddWithValue("@UserID", userID);
                        int dailyLimit = (int)limitCmd.ExecuteScalar();

                        // Get today's sent messages count
                        string todayCountQuery = @"SELECT COUNT(*) FROM Messages 
                                                 WHERE FromUserID = @UserID 
                                                 AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)";

                        using (SqlCommand countCmd = new SqlCommand(todayCountQuery, conn))
                        {
                            countCmd.Parameters.AddWithValue("@UserID", userID);
                            int sentToday = (int)countCmd.ExecuteScalar();

                            return Math.Max(0, dailyLimit - sentToday);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return 5; // Default fallback
            }
        }

        public static int GetRemainingInterestCount(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Check if user has premium membership
                    string membershipQuery = @"SELECT COUNT(*) FROM UserMemberships 
                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
                                             AND MembershipType IN ('Gold', 'Platinum', 'Silver')";

                    using (SqlCommand membershipCmd = new SqlCommand(membershipQuery, conn))
                    {
                        membershipCmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        int hasPremium = (int)membershipCmd.ExecuteScalar();

                        if (hasPremium > 0)
                        {
                            return 999; // Unlimited for premium users
                        }
                    }

                    // For free users, check daily limits
                    string limitQuery = @"SELECT ISNULL(MAX(DailyInterestLimit), 5) FROM UserMemberships 
                                        WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

                    using (SqlCommand limitCmd = new SqlCommand(limitQuery, conn))
                    {
                        limitCmd.Parameters.AddWithValue("@UserID", userID);
                        int dailyLimit = (int)limitCmd.ExecuteScalar();

                        // Get today's sent interests count
                        string todayCountQuery = @"SELECT COUNT(*) FROM Interests 
                                                 WHERE SentByUserID = @UserID 
                                                 AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)";

                        using (SqlCommand countCmd = new SqlCommand(todayCountQuery, conn))
                        {
                            countCmd.Parameters.AddWithValue("@UserID", userID);
                            int sentToday = (int)countCmd.ExecuteScalar();

                            return Math.Max(0, dailyLimit - sentToday);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return 2; // Default fallback
            }
        }

        public static bool CanUserSendInterest(int userID)
        {
            return GetRemainingInterestCount(userID) > 0;
        }

        public static bool CanUserSendMessage(int userID)
        {
            return GetRemainingMessageCount(userID) > 0;
        }

        private static void UpdateDailyInterestCount(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // This method updates the daily interest count in the database
                    // For now, we'll just log it since the counts are calculated on-the-fly
                    string query = @"INSERT INTO UserDailyActivities (UserID, ActivityType, ActivityDate) 
                                   VALUES (@UserID, 'Interest', GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("UpdateDailyInterestCount error: " + ex.Message);
            }
        }

        private static void UpdateDailyMessageCount(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // This method updates the daily message count in the database
                    // For now, we'll just log it since the counts are calculated on-the-fly
                    string query = @"INSERT INTO UserDailyActivities (UserID, ActivityType, ActivityDate) 
                                   VALUES (@UserID, 'Message', GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("UpdateDailyMessageCount error: " + ex.Message);
            }
        }

        private void LoadUserHighQualityProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
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
                            string resolvedPath = ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
                            imgControl.ImageUrl = resolvedPath;
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

        private void LoadOppositeGenderProfiles()
        {
            try
            {
                string currentUserGender = hdnCurrentUserGender.Value;
                if (string.IsNullOrEmpty(currentUserGender))
                {
                    pnlNoProfiles.Visible = true;
                    return;
                }

                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Updated query to exclude blocked users
                    string query = @"
                        SELECT TOP 12 
                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
                            u.Education, u.Caste, u.Religion, u.Gender,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
                                 THEN 1 ELSE 0 END as IsPremium
                        FROM Users u
                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
                        WHERE u.Gender = @Gender 
                        AND u.UserID != @CurrentUserID
                        AND u.CreatedDate IS NOT NULL
                        AND u.UserID NOT IN (
                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @CurrentUserID
                            UNION
                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @CurrentUserID
                        )
                        ORDER BY NEWID()";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Gender", oppositeGender);
                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptProfiles.DataSource = dt;
                            rptProfiles.DataBind();
                            pnlNoProfiles.Visible = false;
                        }
                        else
                        {
                            rptProfiles.DataSource = null;
                            rptProfiles.DataBind();
                            pnlNoProfiles.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlNoProfiles.Visible = true;
            }
        }

        private void LoadUserStats(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string viewsQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID";
                    SqlCommand viewsCmd = new SqlCommand(viewsQuery, conn);
                    viewsCmd.Parameters.AddWithValue("@UserID", userID);
                    lblProfileViews.Text = viewsCmd.ExecuteScalar().ToString();
                    lblTotalViews.Text = lblProfileViews.Text;

                    string interestsReceivedQuery = "SELECT COUNT(*) FROM Interests WHERE TargetUserID = @UserID AND Status = 'Pending'";
                    SqlCommand interestsReceivedCmd = new SqlCommand(interestsReceivedQuery, conn);
                    interestsReceivedCmd.Parameters.AddWithValue("@UserID", userID);
                    lblInterestsReceived.Text = interestsReceivedCmd.ExecuteScalar().ToString();
                    lblTotalInterests.Text = lblInterestsReceived.Text;

                    string interestsSentQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @UserID";
                    SqlCommand interestsSentCmd = new SqlCommand(interestsSentQuery, conn);
                    interestsSentCmd.Parameters.AddWithValue("@UserID", userID);
                    lblInterestsSent.Text = interestsSentCmd.ExecuteScalar().ToString();

                    string messagesQuery = "SELECT COUNT(*) FROM Messages WHERE FromUserID = @UserID";
                    SqlCommand messagesCmd = new SqlCommand(messagesQuery, conn);
                    messagesCmd.Parameters.AddWithValue("@UserID", userID);
                    lblMessages.Text = messagesCmd.ExecuteScalar().ToString();

                    Random rnd = new Random();
                    lblTodayMatches.Text = rnd.Next(5, 20).ToString();
                    lblNewMessages.Text = rnd.Next(0, 10).ToString();
                }
            }
            catch (Exception ex)
            {
                lblProfileViews.Text = "0";
                lblInterestsReceived.Text = "0";
                lblInterestsSent.Text = "0";
                lblMessages.Text = "0";
                lblTotalViews.Text = "0";
                lblTotalInterests.Text = "0";
                lblTodayMatches.Text = "0";
                lblNewMessages.Text = "0";
            }
        }

        protected void rptProfiles_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == System.Web.UI.WebControls.ListItemType.Item ||
                e.Item.ItemType == System.Web.UI.WebControls.ListItemType.AlternatingItem)
            {
                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
                HtmlGenericControl profileHeaderBackground = (HtmlGenericControl)e.Item.FindControl("profileHeaderBackground");

                if (imgProfile != null && profileHeaderBackground != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    int profileUserID = Convert.ToInt32(row["UserID"]);

                    // Load high quality photo for each profile
                    string photoUrl = LoadProfileHighQualityPhoto(profileUserID, imgProfile);

                    // Set background image for profile header
                    if (!string.IsNullOrEmpty(photoUrl) && photoUrl != ResolveUrl("~/Images/default-profile.jpg"))
                    {
                        profileHeaderBackground.Style.Add("background-image", $"url('{photoUrl}')");
                        // Add overlay for better text readability
                        profileHeaderBackground.Style.Add("position", "relative");
                        profileHeaderBackground.Style.Add("background-size", "cover");
                        profileHeaderBackground.Style.Add("background-position", "center");

                        // Add dark overlay for better contrast
                        profileHeaderBackground.Style.Add("background-blend-mode", "overlay");
                        profileHeaderBackground.Style.Add("background-color", "rgba(0,0,0,0.3)");
                    }

                    imgProfile.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
                }

                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
                if (ltAge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltAge.Text = CalculateAgeInline(row["DateOfBirth"]);
                }

                HtmlGenericControl premiumBadge = (HtmlGenericControl)e.Item.FindControl("premiumBadge");
                if (premiumBadge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    bool isPremium = Convert.ToBoolean(row["IsPremium"]);
                    premiumBadge.Visible = isPremium;
                }
            }
        }

        private string LoadProfileHighQualityPhoto(int userID, System.Web.UI.WebControls.Image imgControl)
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
                            string resolvedPath = ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
                            imgControl.ImageUrl = resolvedPath;
                            return resolvedPath; // Return the URL for background use
                        }
                        else
                        {
                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
                            return ResolveUrl("~/Images/default-profile.jpg");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
                return ResolveUrl("~/Images/default-profile.jpg");
            }
        }

        private void BindCityDropdown()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT DISTINCT City FROM Users 
                                   WHERE City IS NOT NULL AND City <> '' 
                                   ORDER BY City";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlCity.Items.Clear();
                        ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem("All Cities", ""));

                        while (reader.Read())
                        {
                            string city = reader["City"].ToString();
                            if (!string.IsNullOrEmpty(city))
                            {
                                ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem(city, city));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("BindCityDropdown error: " + ex.Message);
            }
        }

        [WebMethod]
        public static string SendInterest(int sentByUserID, int targetUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                // Check membership limits
                if (!CanUserSendInterest(sentByUserID))
                {
                    return "limit_reached";
                }

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
                            // Update remaining interests count
                            UpdateDailyInterestCount(sentByUserID);
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

        [WebMethod]
        public static string SendMessage(int fromUserID, int toUserID, string messageText)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                // Check membership limits
                if (!CanUserSendMessage(fromUserID))
                {
                    return "limit_reached";
                }

                // Check if users are blocked
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
                            // Update remaining messages count
                            UpdateDailyMessageCount(fromUserID);
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
            catch (Exception ex)
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
                            // Delete any existing interests and messages between blocked users
                            DeleteInterestsBetweenUsers(blockedByUserID, blockedUserID);
                            DeleteMessagesBetweenUsers(blockedByUserID, blockedUserID);

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

        private static void DeleteInterestsBetweenUsers(int user1ID, int user2ID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"DELETE FROM Interests 
                                   WHERE (SentByUserID = @User1ID AND TargetUserID = @User2ID)
                                   OR (SentByUserID = @User2ID AND TargetUserID = @User1ID)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't throw
                System.Diagnostics.Debug.WriteLine("DeleteInterestsBetweenUsers error: " + ex.Message);
            }
        }

        private static void DeleteMessagesBetweenUsers(int user1ID, int user2ID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"DELETE FROM Messages 
                                   WHERE (FromUserID = @User1ID AND ToUserID = @User2ID)
                                   OR (FromUserID = @User2ID AND ToUserID = @User1ID)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't throw
                System.Diagnostics.Debug.WriteLine("DeleteMessagesBetweenUsers error: " + ex.Message);
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
            catch (Exception ex)
            {
                return "error";
            }
        }

        // Notification related methods
        [WebMethod]
        public static string GetNotifications(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get unread counts
                    int unreadInterests = GetUnreadInterestsCount(conn, userID);
                    int unreadMessages = GetUnreadMessagesCount(conn, userID);
                    int totalUnread = unreadInterests + unreadMessages;

                    // Get recent notifications
                    List<Notification> notifications = GetRecentNotifications(conn, userID);

                    var result = new
                    {
                        TotalUnread = totalUnread,
                        UnreadInterests = unreadInterests,
                        UnreadMessages = unreadMessages,
                        Notifications = notifications
                    };

                    return JsonConvert.SerializeObject(result);
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    TotalUnread = 0,
                    UnreadInterests = 0,
                    UnreadMessages = 0,
                    Notifications = new List<Notification>()
                });
            }
        }

        private static int GetUnreadInterestsCount(SqlConnection conn, int userID)
        {
            string query = "SELECT COUNT(*) FROM Interests WHERE TargetUserID = @UserID AND Status = 'Pending' AND IsRead = 0";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@UserID", userID);
                return (int)cmd.ExecuteScalar();
            }
        }

        private static int GetUnreadMessagesCount(SqlConnection conn, int userID)
        {
            string query = "SELECT COUNT(*) FROM Messages WHERE ToUserID = @UserID AND IsRead = 0";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@UserID", userID);
                return (int)cmd.ExecuteScalar();
            }
        }

        private static List<Notification> GetRecentNotifications(SqlConnection conn, int userID)
        {
            List<Notification> notifications = new List<Notification>();

            // Get interest notifications
            string interestsQuery = @"
                SELECT TOP 5 
                    'Interest' as Type,
                    i.InterestID as NotificationID,
                    u.FullName,
                    i.SentDate,
                    i.IsRead,
                    CONCAT(u.FullName, ' showed interest in your profile') as Message
                FROM Interests i
                INNER JOIN Users u ON i.SentByUserID = u.UserID
                WHERE i.TargetUserID = @UserID AND i.Status = 'Pending'
                ORDER BY i.SentDate DESC";

            using (SqlCommand cmd = new SqlCommand(interestsQuery, conn))
            {
                cmd.Parameters.AddWithValue("@UserID", userID);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        notifications.Add(new Notification
                        {
                            Type = reader["Type"].ToString(),
                            NotificationID = Convert.ToInt32(reader["NotificationID"]),
                            Message = reader["Message"].ToString(),
                            TimeAgo = GetTimeAgo(Convert.ToDateTime(reader["SentDate"])),
                            IsRead = Convert.ToBoolean(reader["IsRead"])
                        });
                    }
                }
            }

            // Get message notifications
            string messagesQuery = @"
                SELECT TOP 5 
                    'Message' as Type,
                    m.MessageID as NotificationID,
                    u.FullName,
                    m.SentDate,
                    m.IsRead,
                    CONCAT('New message from ', u.FullName) as Message
                FROM Messages m
                INNER JOIN Users u ON m.FromUserID = u.UserID
                WHERE m.ToUserID = @UserID AND m.IsRead = 0
                ORDER BY m.SentDate DESC";

            using (SqlCommand cmd = new SqlCommand(messagesQuery, conn))
            {
                cmd.Parameters.AddWithValue("@UserID", userID);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        notifications.Add(new Notification
                        {
                            Type = reader["Type"].ToString(),
                            NotificationID = Convert.ToInt32(reader["NotificationID"]),
                            Message = reader["Message"].ToString(),
                            TimeAgo = GetTimeAgo(Convert.ToDateTime(reader["SentDate"])),
                            IsRead = Convert.ToBoolean(reader["IsRead"])
                        });
                    }
                }
            }

            // Sort by date and take top 10
            return notifications.OrderByDescending(n => n.TimeAgo).Take(10).ToList();
        }

        private static string GetTimeAgo(DateTime date)
        {
            TimeSpan timeSpan = DateTime.Now - date;

            if (timeSpan.TotalMinutes < 1)
                return "just now";
            if (timeSpan.TotalMinutes < 60)
                return $"{(int)timeSpan.TotalMinutes} min ago";
            if (timeSpan.TotalHours < 24)
                return $"{(int)timeSpan.TotalHours} hours ago";

            return $"{(int)timeSpan.TotalDays} days ago";
        }

        [WebMethod]
        public static string MarkNotificationAsRead(int notificationID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // This is a simplified version - you might need separate methods for different notification types
                    // For now, we'll mark both interests and messages as read
                    string query = @"
                        UPDATE Interests SET IsRead = 1 WHERE InterestID = @NotificationID;
                        UPDATE Messages SET IsRead = 1 WHERE MessageID = @NotificationID;";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@NotificationID", notificationID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                return "success";
            }
            catch (Exception ex)
            {
                return "error";
            }
        }

        [WebMethod]
        public static string MarkAllNotificationsAsRead(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Interests SET IsRead = 1 WHERE TargetUserID = @UserID AND IsRead = 0;
                        UPDATE Messages SET IsRead = 1 WHERE ToUserID = @UserID AND IsRead = 0;";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                return "success";
            }
            catch (Exception ex)
            {
                return "error";
            }
        }

        // Notification class
        public class Notification
        {
            public string Type { get; set; }
            public int NotificationID { get; set; }
            public string Message { get; set; }
            public string TimeAgo { get; set; }
            public bool IsRead { get; set; }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadOppositeGenderProfilesWithFilters();
        }

        private void LoadOppositeGenderProfilesWithFilters()
        {
            try
            {
                string currentUserGender = hdnCurrentUserGender.Value;
                if (string.IsNullOrEmpty(currentUserGender))
                {
                    pnlNoProfiles.Visible = true;
                    return;
                }

                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    StringBuilder query = new StringBuilder(@"
                        SELECT 
                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
                            u.Education, u.Caste, u.Religion, u.Gender, u.MotherTongue, u.Income,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
                                 THEN 1 ELSE 0 END as IsPremium
                        FROM Users u
                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
                        WHERE u.Gender = @Gender 
                        AND u.UserID != @CurrentUserID
                        AND u.CreatedDate IS NOT NULL
                        AND u.UserID NOT IN (
                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @CurrentUserID
                            UNION
                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @CurrentUserID
                        )");

                    List<SqlParameter> parameters = new List<SqlParameter>
                    {
                        new SqlParameter("@Gender", oppositeGender),
                        new SqlParameter("@CurrentUserID", currentUserID)
                    };

                    // Age Filter
                    if (!string.IsNullOrEmpty(txtAgeFrom.Text) && int.TryParse(txtAgeFrom.Text, out int ageFrom))
                    {
                        query.Append(" AND DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) >= @AgeFrom");
                        parameters.Add(new SqlParameter("@AgeFrom", ageFrom));
                    }

                    if (!string.IsNullOrEmpty(txtAgeTo.Text) && int.TryParse(txtAgeTo.Text, out int ageTo))
                    {
                        query.Append(" AND DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) <= @AgeTo");
                        parameters.Add(new SqlParameter("@AgeTo", ageTo));
                    }

                    // City Filter
                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
                    {
                        query.Append(" AND u.City = @City");
                        parameters.Add(new SqlParameter("@City", ddlCity.SelectedValue));
                    }

                    // Education Filter
                    if (!string.IsNullOrEmpty(ddlEducation.SelectedValue))
                    {
                        query.Append(" AND u.Education = @Education");
                        parameters.Add(new SqlParameter("@Education", ddlEducation.SelectedValue));
                    }

                    query.Append(" ORDER BY NEWID()");

                    using (SqlCommand cmd = new SqlCommand(query.ToString(), conn))
                    {
                        cmd.Parameters.AddRange(parameters.ToArray());
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptProfiles.DataSource = dt;
                            rptProfiles.DataBind();
                            pnlNoProfiles.Visible = false;
                        }
                        else
                        {
                            rptProfiles.DataSource = null;
                            rptProfiles.DataBind();
                            pnlNoProfiles.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlNoProfiles.Visible = true;
                System.Diagnostics.Debug.WriteLine("LoadOppositeGenderProfilesWithFilters error: " + ex.Message);
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtAgeFrom.Text = "";
            txtAgeTo.Text = "";
            ddlCity.SelectedIndex = 0;
            ddlEducation.SelectedIndex = 0;
            LoadOppositeGenderProfiles();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}
























//using Newtonsoft.Json;
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
//    public partial class Dashboard : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                if (Session["UserID"] != null)
//                {
//                    int userID = Convert.ToInt32(Session["UserID"]);
//                    LoadCurrentUserProfile(userID);
//                    LoadOppositeGenderProfiles();
//                    LoadUserStats(userID);
//                    BindCityDropdown();
//                    LoadMembershipInfo(userID);
//                }
//                else
//                {
//                    Response.Redirect("Login.aspx");
//                }
//            }
//        }

//        private void LoadCurrentUserProfile(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT UserID, Email, FullName, Gender, DateOfBirth, Occupation, 
//                                   City, State, Education, CreatedDate,
//                                   DATEDIFF(YEAR, DateOfBirth, GETDATE()) as Age
//                                   FROM Users 
//                                   WHERE UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            lblUserName.Text = reader["FullName"].ToString();
//                            lblUserFullName.Text = reader["FullName"].ToString();

//                            if (reader["DateOfBirth"] != DBNull.Value)
//                            {
//                                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
//                                int age = DateTime.Now.Year - dob.Year;
//                                string occupation = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
//                                lblUserAgeOccupation.Text = $"{age} Years | {occupation}";
//                            }

//                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
//                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
//                            lblUserLocation.Text = $"{city}, {state}";

//                            if (reader["CreatedDate"] != DBNull.Value)
//                            {
//                                DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
//                                lblMemberSince.Text = createdDate.ToString("MMM yyyy");
//                            }

//                            hdnCurrentUserID.Value = userID.ToString();
//                            hdnCurrentUserGender.Value = reader["Gender"].ToString();

//                            LoadUserHighQualityProfilePhoto(userID, imgUserPhoto);
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadCurrentUserProfile error: " + ex.Message);
//            }
//        }

//        private void LoadMembershipInfo(int userID)
//        {
//            try
//            {
//                string membershipType = "Free";
//                DateTime? expiryDate = null;

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 MembershipType, ExpiryDate 
//                                   FROM UserMemberships 
//                                   WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
//                                   ORDER BY ExpiryDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            membershipType = reader["MembershipType"].ToString();
//                            expiryDate = Convert.ToDateTime(reader["ExpiryDate"]);
//                        }
//                    }
//                }

//                // Set membership status
//                lblMembershipStatus.Text = membershipType;

//                // Set membership badge style
//                HtmlGenericControl membershipBadge = (HtmlGenericControl)FindControl("membershipBadge");
//                if (membershipBadge != null)
//                {
//                    membershipBadge.InnerText = membershipType;
//                    membershipBadge.Attributes["class"] = $"membership-status membership-{membershipType.ToLower()}";
//                }

//                // Show upgrade prompt for free users
//                pnlUpgradePrompt.Visible = (membershipType == "Free");

//                // Load remaining limits
//                int remainingMessagesCount = GetRemainingMessageCount(userID);
//                int remainingInterestsCount = GetRemainingInterestCount(userID);

//                // Update the label controls
//                Label remainingMessagesControl = (Label)pnlMembershipInfo.FindControl("remainingMessages");
//                Label remainingInterestsControl = (Label)pnlMembershipInfo.FindControl("remainingInterests");

//                if (remainingMessagesControl != null)
//                    remainingMessagesControl.Text = remainingMessagesCount.ToString();

//                if (remainingInterestsControl != null)
//                    remainingInterestsControl.Text = remainingInterestsCount.ToString();
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadMembershipInfo error: " + ex.Message);
//            }
//        }

//        // Membership limit methods
//        public static int GetRemainingMessageCount(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Check if user has premium membership
//                    string membershipQuery = @"SELECT COUNT(*) FROM UserMemberships 
//                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
//                                             AND MembershipType IN ('Gold', 'Platinum', 'Silver')";

//                    using (SqlCommand membershipCmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        membershipCmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        int hasPremium = (int)membershipCmd.ExecuteScalar();

//                        if (hasPremium > 0)
//                        {
//                            return 999; // Unlimited for premium users
//                        }
//                    }

//                    // For free users, check daily limits
//                    string limitQuery = @"SELECT ISNULL(MAX(DailyMessageLimit), 10) FROM UserMemberships 
//                                        WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

//                    using (SqlCommand limitCmd = new SqlCommand(limitQuery, conn))
//                    {
//                        limitCmd.Parameters.AddWithValue("@UserID", userID);
//                        int dailyLimit = (int)limitCmd.ExecuteScalar();

//                        // Get today's sent messages count
//                        string todayCountQuery = @"SELECT COUNT(*) FROM Messages 
//                                                 WHERE FromUserID = @UserID 
//                                                 AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)";

//                        using (SqlCommand countCmd = new SqlCommand(todayCountQuery, conn))
//                        {
//                            countCmd.Parameters.AddWithValue("@UserID", userID);
//                            int sentToday = (int)countCmd.ExecuteScalar();

//                            return Math.Max(0, dailyLimit - sentToday);
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return 5; // Default fallback
//            }
//        }

//        public static int GetRemainingInterestCount(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Check if user has premium membership
//                    string membershipQuery = @"SELECT COUNT(*) FROM UserMemberships 
//                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
//                                             AND MembershipType IN ('Gold', 'Platinum', 'Silver')";

//                    using (SqlCommand membershipCmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        membershipCmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        int hasPremium = (int)membershipCmd.ExecuteScalar();

//                        if (hasPremium > 0)
//                        {
//                            return 999; // Unlimited for premium users
//                        }
//                    }

//                    // For free users, check daily limits
//                    string limitQuery = @"SELECT ISNULL(MAX(DailyInterestLimit), 5) FROM UserMemberships 
//                                        WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

//                    using (SqlCommand limitCmd = new SqlCommand(limitQuery, conn))
//                    {
//                        limitCmd.Parameters.AddWithValue("@UserID", userID);
//                        int dailyLimit = (int)limitCmd.ExecuteScalar();

//                        // Get today's sent interests count
//                        string todayCountQuery = @"SELECT COUNT(*) FROM Interests 
//                                                 WHERE SentByUserID = @UserID 
//                                                 AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)";

//                        using (SqlCommand countCmd = new SqlCommand(todayCountQuery, conn))
//                        {
//                            countCmd.Parameters.AddWithValue("@UserID", userID);
//                            int sentToday = (int)countCmd.ExecuteScalar();

//                            return Math.Max(0, dailyLimit - sentToday);
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                return 2; // Default fallback
//            }
//        }

//        public static bool CanUserSendInterest(int userID)
//        {
//            return GetRemainingInterestCount(userID) > 0;
//        }

//        public static bool CanUserSendMessage(int userID)
//        {
//            return GetRemainingMessageCount(userID) > 0;
//        }

//        private static void UpdateDailyInterestCount(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // This method updates the daily interest count in the database
//                    // For now, we'll just log it since the counts are calculated on-the-fly
//                    string query = @"INSERT INTO UserDailyActivities (UserID, ActivityType, ActivityDate) 
//                                   VALUES (@UserID, 'Interest', GETDATE())";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("UpdateDailyInterestCount error: " + ex.Message);
//            }
//        }

//        private static void UpdateDailyMessageCount(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // This method updates the daily message count in the database
//                    // For now, we'll just log it since the counts are calculated on-the-fly
//                    string query = @"INSERT INTO UserDailyActivities (UserID, ActivityType, ActivityDate) 
//                                   VALUES (@UserID, 'Message', GETDATE())";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("UpdateDailyMessageCount error: " + ex.Message);
//            }
//        }

//        private void LoadUserHighQualityProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                   WHERE UserID = @UserID 
//                                   ORDER BY 
//                                       CASE WHEN PhotoType = 'Profile' THEN 1 ELSE 2 END,
//                                       UploadDate DESC";

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
//                        }
//                        else
//                        {
//                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
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

//        private void LoadOppositeGenderProfiles()
//        {
//            try
//            {
//                string currentUserGender = hdnCurrentUserGender.Value;
//                if (string.IsNullOrEmpty(currentUserGender))
//                {
//                    pnlNoProfiles.Visible = true;
//                    return;
//                }

//                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
//                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Updated query to exclude blocked users
//                    string query = @"
//                        SELECT TOP 12 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Gender,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                 THEN 1 ELSE 0 END as IsPremium
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender = @Gender 
//                        AND u.UserID != @CurrentUserID
//                        AND u.CreatedDate IS NOT NULL
//                        AND u.UserID NOT IN (
//                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @CurrentUserID
//                            UNION
//                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @CurrentUserID
//                        )
//                        ORDER BY NEWID()";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@Gender", oppositeGender);
//                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);

//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.HasRows)
//                        {
//                            DataTable dt = new DataTable();
//                            dt.Load(reader);
//                            rptProfiles.DataSource = dt;
//                            rptProfiles.DataBind();
//                            pnlNoProfiles.Visible = false;
//                        }
//                        else
//                        {
//                            rptProfiles.DataSource = null;
//                            rptProfiles.DataBind();
//                            pnlNoProfiles.Visible = true;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                pnlNoProfiles.Visible = true;
//            }
//        }

//        private void LoadUserStats(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    string viewsQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID";
//                    SqlCommand viewsCmd = new SqlCommand(viewsQuery, conn);
//                    viewsCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblProfileViews.Text = viewsCmd.ExecuteScalar().ToString();
//                    lblTotalViews.Text = lblProfileViews.Text;

//                    string interestsReceivedQuery = "SELECT COUNT(*) FROM Interests WHERE TargetUserID = @UserID AND Status = 'Pending'";
//                    SqlCommand interestsReceivedCmd = new SqlCommand(interestsReceivedQuery, conn);
//                    interestsReceivedCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblInterestsReceived.Text = interestsReceivedCmd.ExecuteScalar().ToString();
//                    lblTotalInterests.Text = lblInterestsReceived.Text;

//                    string interestsSentQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @UserID";
//                    SqlCommand interestsSentCmd = new SqlCommand(interestsSentQuery, conn);
//                    interestsSentCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblInterestsSent.Text = interestsSentCmd.ExecuteScalar().ToString();

//                    string messagesQuery = "SELECT COUNT(*) FROM Messages WHERE FromUserID = @UserID";
//                    SqlCommand messagesCmd = new SqlCommand(messagesQuery, conn);
//                    messagesCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblMessages.Text = messagesCmd.ExecuteScalar().ToString();

//                    Random rnd = new Random();
//                    lblTodayMatches.Text = rnd.Next(5, 20).ToString();
//                    lblNewMessages.Text = rnd.Next(0, 10).ToString();
//                }
//            }
//            catch (Exception ex)
//            {
//                lblProfileViews.Text = "0";
//                lblInterestsReceived.Text = "0";
//                lblInterestsSent.Text = "0";
//                lblMessages.Text = "0";
//                lblTotalViews.Text = "0";
//                lblTotalInterests.Text = "0";
//                lblTodayMatches.Text = "0";
//                lblNewMessages.Text = "0";
//            }
//        }

//        protected void rptProfiles_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
//        {
//            if (e.Item.ItemType == System.Web.UI.WebControls.ListItemType.Item ||
//                e.Item.ItemType == System.Web.UI.WebControls.ListItemType.AlternatingItem)
//            {
//                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
//                if (imgProfile != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    int profileUserID = Convert.ToInt32(row["UserID"]);

//                    // Load high quality photo for each profile
//                    LoadProfileHighQualityPhoto(profileUserID, imgProfile);
//                    imgProfile.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
//                }

//                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
//                if (ltAge != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    ltAge.Text = CalculateAgeInline(row["DateOfBirth"]);
//                }

//                HtmlGenericControl premiumBadge = (HtmlGenericControl)e.Item.FindControl("premiumBadge");
//                if (premiumBadge != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    bool isPremium = Convert.ToBoolean(row["IsPremium"]);
//                    premiumBadge.Visible = isPremium;
//                }
//            }
//        }

//        private void LoadProfileHighQualityPhoto(int userID, System.Web.UI.WebControls.Image imgControl)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                   WHERE UserID = @UserID 
//                                   ORDER BY 
//                                       CASE WHEN PhotoType = 'Profile' THEN 1 ELSE 2 END,
//                                       UploadDate DESC";

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
//                        }
//                        else
//                        {
//                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
//        }

//        private void BindCityDropdown()
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT DISTINCT City FROM Users 
//                                   WHERE City IS NOT NULL AND City <> '' 
//                                   ORDER BY City";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        ddlCity.Items.Clear();
//                        ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem("All Cities", ""));

//                        while (reader.Read())
//                        {
//                            string city = reader["City"].ToString();
//                            if (!string.IsNullOrEmpty(city))
//                            {
//                                ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem(city, city));
//                            }
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("BindCityDropdown error: " + ex.Message);
//            }
//        }

//        [WebMethod]
//        public static string SendInterest(int sentByUserID, int targetUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                // Check membership limits
//                if (!CanUserSendInterest(sentByUserID))
//                {
//                    return "limit_reached";
//                }

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
//                            // Update remaining interests count
//                            UpdateDailyInterestCount(sentByUserID);
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

//                // Check membership limits
//                if (!CanUserSendMessage(fromUserID))
//                {
//                    return "limit_reached";
//                }

//                // Check if users are blocked
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
//                            // Update remaining messages count
//                            UpdateDailyMessageCount(fromUserID);
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
//                            // Delete any existing interests and messages between blocked users
//                            DeleteInterestsBetweenUsers(blockedByUserID, blockedUserID);
//                            DeleteMessagesBetweenUsers(blockedByUserID, blockedUserID);

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

//        private static void DeleteInterestsBetweenUsers(int user1ID, int user2ID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"DELETE FROM Interests 
//                                   WHERE (SentByUserID = @User1ID AND TargetUserID = @User2ID)
//                                   OR (SentByUserID = @User2ID AND TargetUserID = @User1ID)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
//                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error but don't throw
//                System.Diagnostics.Debug.WriteLine("DeleteInterestsBetweenUsers error: " + ex.Message);
//            }
//        }

//        private static void DeleteMessagesBetweenUsers(int user1ID, int user2ID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"DELETE FROM Messages 
//                                   WHERE (FromUserID = @User1ID AND ToUserID = @User2ID)
//                                   OR (FromUserID = @User2ID AND ToUserID = @User1ID)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
//                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error but don't throw
//                System.Diagnostics.Debug.WriteLine("DeleteMessagesBetweenUsers error: " + ex.Message);
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

//        // Notification related methods
//        [WebMethod]
//        public static string GetNotifications(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Get unread counts
//                    int unreadInterests = GetUnreadInterestsCount(conn, userID);
//                    int unreadMessages = GetUnreadMessagesCount(conn, userID);
//                    int totalUnread = unreadInterests + unreadMessages;

//                    // Get recent notifications
//                    List<Notification> notifications = GetRecentNotifications(conn, userID);

//                    var result = new
//                    {
//                        TotalUnread = totalUnread,
//                        UnreadInterests = unreadInterests,
//                        UnreadMessages = unreadMessages,
//                        Notifications = notifications
//                    };

//                    return JsonConvert.SerializeObject(result);
//                }
//            }
//            catch (Exception ex)
//            {
//                return JsonConvert.SerializeObject(new
//                {
//                    TotalUnread = 0,
//                    UnreadInterests = 0,
//                    UnreadMessages = 0,
//                    Notifications = new List<Notification>()
//                });
//            }
//        }

//        private static int GetUnreadInterestsCount(SqlConnection conn, int userID)
//        {
//            string query = "SELECT COUNT(*) FROM Interests WHERE TargetUserID = @UserID AND Status = 'Pending' AND IsRead = 0";
//            using (SqlCommand cmd = new SqlCommand(query, conn))
//            {
//                cmd.Parameters.AddWithValue("@UserID", userID);
//                return (int)cmd.ExecuteScalar();
//            }
//        }

//        private static int GetUnreadMessagesCount(SqlConnection conn, int userID)
//        {
//            string query = "SELECT COUNT(*) FROM Messages WHERE ToUserID = @UserID AND IsRead = 0";
//            using (SqlCommand cmd = new SqlCommand(query, conn))
//            {
//                cmd.Parameters.AddWithValue("@UserID", userID);
//                return (int)cmd.ExecuteScalar();
//            }
//        }

//        private static List<Notification> GetRecentNotifications(SqlConnection conn, int userID)
//        {
//            List<Notification> notifications = new List<Notification>();

//            // Get interest notifications
//            string interestsQuery = @"
//                SELECT TOP 5 
//                    'Interest' as Type,
//                    i.InterestID as NotificationID,
//                    u.FullName,
//                    i.SentDate,
//                    i.IsRead,
//                    CONCAT(u.FullName, ' showed interest in your profile') as Message
//                FROM Interests i
//                INNER JOIN Users u ON i.SentByUserID = u.UserID
//                WHERE i.TargetUserID = @UserID AND i.Status = 'Pending'
//                ORDER BY i.SentDate DESC";

//            using (SqlCommand cmd = new SqlCommand(interestsQuery, conn))
//            {
//                cmd.Parameters.AddWithValue("@UserID", userID);
//                using (SqlDataReader reader = cmd.ExecuteReader())
//                {
//                    while (reader.Read())
//                    {
//                        notifications.Add(new Notification
//                        {
//                            Type = reader["Type"].ToString(),
//                            NotificationID = Convert.ToInt32(reader["NotificationID"]),
//                            Message = reader["Message"].ToString(),
//                            TimeAgo = GetTimeAgo(Convert.ToDateTime(reader["SentDate"])),
//                            IsRead = Convert.ToBoolean(reader["IsRead"])
//                        });
//                    }
//                }
//            }

//            // Get message notifications
//            string messagesQuery = @"
//                SELECT TOP 5 
//                    'Message' as Type,
//                    m.MessageID as NotificationID,
//                    u.FullName,
//                    m.SentDate,
//                    m.IsRead,
//                    CONCAT('New message from ', u.FullName) as Message
//                FROM Messages m
//                INNER JOIN Users u ON m.FromUserID = u.UserID
//                WHERE m.ToUserID = @UserID AND m.IsRead = 0
//                ORDER BY m.SentDate DESC";

//            using (SqlCommand cmd = new SqlCommand(messagesQuery, conn))
//            {
//                cmd.Parameters.AddWithValue("@UserID", userID);
//                using (SqlDataReader reader = cmd.ExecuteReader())
//                {
//                    while (reader.Read())
//                    {
//                        notifications.Add(new Notification
//                        {
//                            Type = reader["Type"].ToString(),
//                            NotificationID = Convert.ToInt32(reader["NotificationID"]),
//                            Message = reader["Message"].ToString(),
//                            TimeAgo = GetTimeAgo(Convert.ToDateTime(reader["SentDate"])),
//                            IsRead = Convert.ToBoolean(reader["IsRead"])
//                        });
//                    }
//                }
//            }

//            // Sort by date and take top 10
//            return notifications.OrderByDescending(n => n.TimeAgo).Take(10).ToList();
//        }

//        private static string GetTimeAgo(DateTime date)
//        {
//            TimeSpan timeSpan = DateTime.Now - date;

//            if (timeSpan.TotalMinutes < 1)
//                return "just now";
//            if (timeSpan.TotalMinutes < 60)
//                return $"{(int)timeSpan.TotalMinutes} min ago";
//            if (timeSpan.TotalHours < 24)
//                return $"{(int)timeSpan.TotalHours} hours ago";

//            return $"{(int)timeSpan.TotalDays} days ago";
//        }

//        [WebMethod]
//        public static string MarkNotificationAsRead(int notificationID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // This is a simplified version - you might need separate methods for different notification types
//                    // For now, we'll mark both interests and messages as read
//                    string query = @"
//                        UPDATE Interests SET IsRead = 1 WHERE InterestID = @NotificationID;
//                        UPDATE Messages SET IsRead = 1 WHERE MessageID = @NotificationID;";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@NotificationID", notificationID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }

//                return "success";
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static string MarkAllNotificationsAsRead(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        UPDATE Interests SET IsRead = 1 WHERE TargetUserID = @UserID AND IsRead = 0;
//                        UPDATE Messages SET IsRead = 1 WHERE ToUserID = @UserID AND IsRead = 0;";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }

//                return "success";
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        // Notification class
//        public class Notification
//        {
//            public string Type { get; set; }
//            public int NotificationID { get; set; }
//            public string Message { get; set; }
//            public string TimeAgo { get; set; }
//            public bool IsRead { get; set; }
//        }

//        protected void btnSearch_Click(object sender, EventArgs e)
//        {
//            LoadOppositeGenderProfilesWithFilters();
//        }

//        private void LoadOppositeGenderProfilesWithFilters()
//        {
//            try
//            {
//                string currentUserGender = hdnCurrentUserGender.Value;
//                if (string.IsNullOrEmpty(currentUserGender))
//                {
//                    pnlNoProfiles.Visible = true;
//                    return;
//                }

//                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
//                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        SELECT 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Gender,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                 THEN 1 ELSE 0 END as IsPremium
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender = @Gender 
//                        AND u.UserID != @CurrentUserID
//                        AND u.CreatedDate IS NOT NULL
//                        AND u.UserID NOT IN (
//                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @CurrentUserID
//                            UNION
//                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @CurrentUserID
//                        )";

//                    List<string> filters = new List<string>();
//                    SqlCommand cmd = new SqlCommand();

//                    cmd.Parameters.AddWithValue("@Gender", oppositeGender);
//                    cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);

//                    if (!string.IsNullOrEmpty(txtAgeFrom.Text) && !string.IsNullOrEmpty(txtAgeTo.Text))
//                    {
//                        int ageFrom = Convert.ToInt32(txtAgeFrom.Text);
//                        int ageTo = Convert.ToInt32(txtAgeTo.Text);
//                        filters.Add("(DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) BETWEEN @AgeFrom AND @AgeTo)");
//                        cmd.Parameters.AddWithValue("@AgeFrom", ageFrom);
//                        cmd.Parameters.AddWithValue("@AgeTo", ageTo);
//                    }

//                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
//                    {
//                        filters.Add("u.City = @City");
//                        cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);
//                    }

//                    if (!string.IsNullOrEmpty(ddlEducation.SelectedValue))
//                    {
//                        filters.Add("u.Education = @Education");
//                        cmd.Parameters.AddWithValue("@Education", ddlEducation.SelectedValue);
//                    }

//                    if (filters.Count > 0)
//                    {
//                        query += " AND " + string.Join(" AND ", filters);
//                    }

//                    query += " ORDER BY NEWID()";

//                    cmd.CommandText = query;
//                    cmd.Connection = conn;

//                    conn.Open();
//                    SqlDataReader reader = cmd.ExecuteReader();

//                    if (reader.HasRows)
//                    {
//                        DataTable dt = new DataTable();
//                        dt.Load(reader);
//                        rptProfiles.DataSource = dt;
//                        rptProfiles.DataBind();
//                        pnlNoProfiles.Visible = false;
//                    }
//                    else
//                    {
//                        rptProfiles.DataSource = null;
//                        rptProfiles.DataBind();
//                        pnlNoProfiles.Visible = true;
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                pnlNoProfiles.Visible = true;
//            }
//        }

//        protected void btnReset_Click(object sender, EventArgs e)
//        {
//            txtAgeFrom.Text = "";
//            txtAgeTo.Text = "";
//            ddlCity.SelectedIndex = 0;
//            ddlEducation.SelectedIndex = 0;
//            LoadOppositeGenderProfiles();
//        }

//        protected void btnLogout_Click(object sender, EventArgs e)
//        {
//            Session.Clear();
//            Session.Abandon();
//            Response.Redirect("Login.aspx");
//        }
//    }
//}





















//using Newtonsoft.Json;
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
//    public partial class Dashboard : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                if (Session["UserID"] != null)
//                {
//                    int userID = Convert.ToInt32(Session["UserID"]);
//                    LoadCurrentUserProfile(userID);
//                    LoadOppositeGenderProfiles();
//                    LoadUserStats(userID);
//                    BindCityDropdown();
//                    LoadMembershipInfo(userID);
//                }
//                else
//                {
//                    Response.Redirect("Login.aspx");
//                }
//            }
//        }

//        private void LoadCurrentUserProfile(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT UserID, Email, FullName, Gender, DateOfBirth, Occupation, 
//                                   City, State, Education, CreatedDate,
//                                   DATEDIFF(YEAR, DateOfBirth, GETDATE()) as Age
//                                   FROM Users 
//                                   WHERE UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            lblUserName.Text = reader["FullName"].ToString();
//                            lblUserFullName.Text = reader["FullName"].ToString();

//                            if (reader["DateOfBirth"] != DBNull.Value)
//                            {
//                                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
//                                int age = DateTime.Now.Year - dob.Year;
//                                string occupation = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
//                                lblUserAgeOccupation.Text = $"{age} Years | {occupation}";
//                            }

//                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
//                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
//                            lblUserLocation.Text = $"{city}, {state}";

//                            if (reader["CreatedDate"] != DBNull.Value)
//                            {
//                                DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
//                                lblMemberSince.Text = createdDate.ToString("MMM yyyy");
//                            }

//                            hdnCurrentUserID.Value = userID.ToString();
//                            hdnCurrentUserGender.Value = reader["Gender"].ToString();

//                            LoadUserHighQualityProfilePhoto(userID, imgUserPhoto);
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadCurrentUserProfile error: " + ex.Message);
//            }
//        }

//        private void LoadMembershipInfo(int userID)
//        {
//            try
//            {
//                string membershipType = "Free";
//                DateTime? expiryDate = null;

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 MembershipType, ExpiryDate 
//                                   FROM UserMemberships 
//                                   WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
//                                   ORDER BY ExpiryDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            membershipType = reader["MembershipType"].ToString();
//                            expiryDate = Convert.ToDateTime(reader["ExpiryDate"]);
//                        }
//                    }
//                }

//                // Set membership status
//                lblMembershipStatus.Text = membershipType;

//                // Set membership badge style
//                HtmlGenericControl membershipBadge = (HtmlGenericControl)FindControl("membershipBadge");
//                if (membershipBadge != null)
//                {
//                    membershipBadge.InnerText = membershipType;
//                    membershipBadge.Attributes["class"] = $"membership-status membership-{membershipType.ToLower()}";
//                }

//                // Show upgrade prompt for free users
//                pnlUpgradePrompt.Visible = (membershipType == "Free");

//                // Load remaining limits
//                int remainingMessages = Membership.GetRemainingMessageCount(userID);
//                int remainingInterests = Membership.GetRemainingInterestCount(userID);

//                remainingMessages.InnerText = remainingMessages.ToString();
//                remainingInterests.InnerText = remainingInterests.ToString();
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadMembershipInfo error: " + ex.Message);
//            }
//        }

//        private void LoadUserHighQualityProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                   WHERE UserID = @UserID 
//                                   ORDER BY 
//                                       CASE WHEN PhotoType = 'Profile' THEN 1 ELSE 2 END,
//                                       UploadDate DESC";

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
//                        }
//                        else
//                        {
//                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
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

//        private void LoadOppositeGenderProfiles()
//        {
//            try
//            {
//                string currentUserGender = hdnCurrentUserGender.Value;
//                if (string.IsNullOrEmpty(currentUserGender))
//                {
//                    pnlNoProfiles.Visible = true;
//                    return;
//                }

//                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
//                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Updated query to exclude blocked users
//                    string query = @"
//                        SELECT TOP 12 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Gender,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                 THEN 1 ELSE 0 END as IsPremium
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender = @Gender 
//                        AND u.UserID != @CurrentUserID
//                        AND u.CreatedDate IS NOT NULL
//                        AND u.UserID NOT IN (
//                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @CurrentUserID
//                            UNION
//                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @CurrentUserID
//                        )
//                        ORDER BY NEWID()";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@Gender", oppositeGender);
//                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);

//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.HasRows)
//                        {
//                            DataTable dt = new DataTable();
//                            dt.Load(reader);
//                            rptProfiles.DataSource = dt;
//                            rptProfiles.DataBind();
//                            pnlNoProfiles.Visible = false;
//                        }
//                        else
//                        {
//                            rptProfiles.DataSource = null;
//                            rptProfiles.DataBind();
//                            pnlNoProfiles.Visible = true;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                pnlNoProfiles.Visible = true;
//            }
//        }

//        private void LoadUserStats(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    string viewsQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID";
//                    SqlCommand viewsCmd = new SqlCommand(viewsQuery, conn);
//                    viewsCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblProfileViews.Text = viewsCmd.ExecuteScalar().ToString();
//                    lblTotalViews.Text = lblProfileViews.Text;

//                    string interestsReceivedQuery = "SELECT COUNT(*) FROM Interests WHERE TargetUserID = @UserID AND Status = 'Pending'";
//                    SqlCommand interestsReceivedCmd = new SqlCommand(interestsReceivedQuery, conn);
//                    interestsReceivedCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblInterestsReceived.Text = interestsReceivedCmd.ExecuteScalar().ToString();
//                    lblTotalInterests.Text = lblInterestsReceived.Text;

//                    string interestsSentQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @UserID";
//                    SqlCommand interestsSentCmd = new SqlCommand(interestsSentQuery, conn);
//                    interestsSentCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblInterestsSent.Text = interestsSentCmd.ExecuteScalar().ToString();

//                    string messagesQuery = "SELECT COUNT(*) FROM Messages WHERE FromUserID = @UserID";
//                    SqlCommand messagesCmd = new SqlCommand(messagesQuery, conn);
//                    messagesCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblMessages.Text = messagesCmd.ExecuteScalar().ToString();

//                    Random rnd = new Random();
//                    lblTodayMatches.Text = rnd.Next(5, 20).ToString();
//                    lblNewMessages.Text = rnd.Next(0, 10).ToString();
//                }
//            }
//            catch (Exception ex)
//            {
//                lblProfileViews.Text = "0";
//                lblInterestsReceived.Text = "0";
//                lblInterestsSent.Text = "0";
//                lblMessages.Text = "0";
//                lblTotalViews.Text = "0";
//                lblTotalInterests.Text = "0";
//                lblTodayMatches.Text = "0";
//                lblNewMessages.Text = "0";
//            }
//        }

//        protected void rptProfiles_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
//        {
//            if (e.Item.ItemType == System.Web.UI.WebControls.ListItemType.Item ||
//                e.Item.ItemType == System.Web.UI.WebControls.ListItemType.AlternatingItem)
//            {
//                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
//                if (imgProfile != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    int profileUserID = Convert.ToInt32(row["UserID"]);

//                    // Load high quality photo for each profile
//                    LoadProfileHighQualityPhoto(profileUserID, imgProfile);
//                    imgProfile.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
//                }

//                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
//                if (ltAge != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    ltAge.Text = CalculateAgeInline(row["DateOfBirth"]);
//                }

//                HtmlGenericControl premiumBadge = (HtmlGenericControl)e.Item.FindControl("premiumBadge");
//                if (premiumBadge != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    bool isPremium = Convert.ToBoolean(row["IsPremium"]);
//                    premiumBadge.Visible = isPremium;
//                }
//            }
//        }

//        private void LoadProfileHighQualityPhoto(int userID, System.Web.UI.WebControls.Image imgControl)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                   WHERE UserID = @UserID 
//                                   ORDER BY 
//                                       CASE WHEN PhotoType = 'Profile' THEN 1 ELSE 2 END,
//                                       UploadDate DESC";

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
//                        }
//                        else
//                        {
//                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
//        }

//        private void BindCityDropdown()
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT DISTINCT City FROM Users 
//                                   WHERE City IS NOT NULL AND City <> '' 
//                                   ORDER BY City";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        ddlCity.Items.Clear();
//                        ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem("All Cities", ""));

//                        while (reader.Read())
//                        {
//                            string city = reader["City"].ToString();
//                            if (!string.IsNullOrEmpty(city))
//                            {
//                                ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem(city, city));
//                            }
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("BindCityDropdown error: " + ex.Message);
//            }
//        }

//        [WebMethod]
//        public static string SendInterest(int sentByUserID, int targetUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                // Check membership limits
//                if (!Membership.CanUserSendInterest(sentByUserID))
//                {
//                    return "limit_reached";
//                }

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
//                            // Update remaining interests count
//                            Membership.UpdateDailyInterestCount(sentByUserID);
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

//                // Check membership limits
//                if (!Membership.CanUserSendMessage(fromUserID))
//                {
//                    return "limit_reached";
//                }

//                // Check if users are blocked
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
//                            // Update remaining messages count
//                            Membership.UpdateDailyMessageCount(fromUserID);
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
//                            // Delete any existing interests and messages between blocked users
//                            DeleteInterestsBetweenUsers(blockedByUserID, blockedUserID);
//                            DeleteMessagesBetweenUsers(blockedByUserID, blockedUserID);

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

//        private static void DeleteInterestsBetweenUsers(int user1ID, int user2ID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"DELETE FROM Interests 
//                                   WHERE (SentByUserID = @User1ID AND TargetUserID = @User2ID)
//                                   OR (SentByUserID = @User2ID AND TargetUserID = @User1ID)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
//                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error but don't throw
//                System.Diagnostics.Debug.WriteLine("DeleteInterestsBetweenUsers error: " + ex.Message);
//            }
//        }

//        private static void DeleteMessagesBetweenUsers(int user1ID, int user2ID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"DELETE FROM Messages 
//                                   WHERE (FromUserID = @User1ID AND ToUserID = @User2ID)
//                                   OR (FromUserID = @User2ID AND ToUserID = @User1ID)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
//                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error but don't throw
//                System.Diagnostics.Debug.WriteLine("DeleteMessagesBetweenUsers error: " + ex.Message);
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

//        // Notification related methods
//        [WebMethod]
//        public static string GetNotifications(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Get unread counts
//                    int unreadInterests = GetUnreadInterestsCount(conn, userID);
//                    int unreadMessages = GetUnreadMessagesCount(conn, userID);
//                    int totalUnread = unreadInterests + unreadMessages;

//                    // Get recent notifications
//                    List<Notification> notifications = GetRecentNotifications(conn, userID);

//                    var result = new
//                    {
//                        TotalUnread = totalUnread,
//                        UnreadInterests = unreadInterests,
//                        UnreadMessages = unreadMessages,
//                        Notifications = notifications
//                    };

//                    return JsonConvert.SerializeObject(result);
//                }
//            }
//            catch (Exception ex)
//            {
//                return JsonConvert.SerializeObject(new
//                {
//                    TotalUnread = 0,
//                    UnreadInterests = 0,
//                    UnreadMessages = 0,
//                    Notifications = new List<Notification>()
//                });
//            }
//        }

//        private static int GetUnreadInterestsCount(SqlConnection conn, int userID)
//        {
//            string query = "SELECT COUNT(*) FROM Interests WHERE TargetUserID = @UserID AND Status = 'Pending' AND IsRead = 0";
//            using (SqlCommand cmd = new SqlCommand(query, conn))
//            {
//                cmd.Parameters.AddWithValue("@UserID", userID);
//                return (int)cmd.ExecuteScalar();
//            }
//        }

//        private static int GetUnreadMessagesCount(SqlConnection conn, int userID)
//        {
//            string query = "SELECT COUNT(*) FROM Messages WHERE ToUserID = @UserID AND IsRead = 0";
//            using (SqlCommand cmd = new SqlCommand(query, conn))
//            {
//                cmd.Parameters.AddWithValue("@UserID", userID);
//                return (int)cmd.ExecuteScalar();
//            }
//        }

//        private static List<Notification> GetRecentNotifications(SqlConnection conn, int userID)
//        {
//            List<Notification> notifications = new List<Notification>();

//            // Get interest notifications
//            string interestsQuery = @"
//                SELECT TOP 5 
//                    'Interest' as Type,
//                    i.InterestID as NotificationID,
//                    u.FullName,
//                    i.SentDate,
//                    i.IsRead,
//                    CONCAT(u.FullName, ' showed interest in your profile') as Message
//                FROM Interests i
//                INNER JOIN Users u ON i.SentByUserID = u.UserID
//                WHERE i.TargetUserID = @UserID AND i.Status = 'Pending'
//                ORDER BY i.SentDate DESC";

//            using (SqlCommand cmd = new SqlCommand(interestsQuery, conn))
//            {
//                cmd.Parameters.AddWithValue("@UserID", userID);
//                using (SqlDataReader reader = cmd.ExecuteReader())
//                {
//                    while (reader.Read())
//                    {
//                        notifications.Add(new Notification
//                        {
//                            Type = reader["Type"].ToString(),
//                            NotificationID = Convert.ToInt32(reader["NotificationID"]),
//                            Message = reader["Message"].ToString(),
//                            TimeAgo = GetTimeAgo(Convert.ToDateTime(reader["SentDate"])),
//                            IsRead = Convert.ToBoolean(reader["IsRead"])
//                        });
//                    }
//                }
//            }

//            // Get message notifications
//            string messagesQuery = @"
//                SELECT TOP 5 
//                    'Message' as Type,
//                    m.MessageID as NotificationID,
//                    u.FullName,
//                    m.SentDate,
//                    m.IsRead,
//                    CONCAT('New message from ', u.FullName) as Message
//                FROM Messages m
//                INNER JOIN Users u ON m.FromUserID = u.UserID
//                WHERE m.ToUserID = @UserID AND m.IsRead = 0
//                ORDER BY m.SentDate DESC";

//            using (SqlCommand cmd = new SqlCommand(messagesQuery, conn))
//            {
//                cmd.Parameters.AddWithValue("@UserID", userID);
//                using (SqlDataReader reader = cmd.ExecuteReader())
//                {
//                    while (reader.Read())
//                    {
//                        notifications.Add(new Notification
//                        {
//                            Type = reader["Type"].ToString(),
//                            NotificationID = Convert.ToInt32(reader["NotificationID"]),
//                            Message = reader["Message"].ToString(),
//                            TimeAgo = GetTimeAgo(Convert.ToDateTime(reader["SentDate"])),
//                            IsRead = Convert.ToBoolean(reader["IsRead"])
//                        });
//                    }
//                }
//            }

//            // Sort by date and take top 10
//            return notifications.OrderByDescending(n => n.TimeAgo).Take(10).ToList();
//        }

//        private static string GetTimeAgo(DateTime date)
//        {
//            TimeSpan timeSpan = DateTime.Now - date;

//            if (timeSpan.TotalMinutes < 1)
//                return "just now";
//            if (timeSpan.TotalMinutes < 60)
//                return $"{(int)timeSpan.TotalMinutes} min ago";
//            if (timeSpan.TotalHours < 24)
//                return $"{(int)timeSpan.TotalHours} hours ago";

//            return $"{(int)timeSpan.TotalDays} days ago";
//        }

//        [WebMethod]
//        public static string MarkNotificationAsRead(int notificationID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // This is a simplified version - you might need separate methods for different notification types
//                    // For now, we'll mark both interests and messages as read
//                    string query = @"
//                        UPDATE Interests SET IsRead = 1 WHERE InterestID = @NotificationID;
//                        UPDATE Messages SET IsRead = 1 WHERE MessageID = @NotificationID;";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@NotificationID", notificationID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }

//                return "success";
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static string MarkAllNotificationsAsRead(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        UPDATE Interests SET IsRead = 1 WHERE TargetUserID = @UserID AND IsRead = 0;
//                        UPDATE Messages SET IsRead = 1 WHERE ToUserID = @UserID AND IsRead = 0;";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }

//                return "success";
//            }
//            catch (Exception ex)
//            {
//                return "error";
//            }
//        }

//        // Notification class
//        public class Notification
//        {
//            public string Type { get; set; }
//            public int NotificationID { get; set; }
//            public string Message { get; set; }
//            public string TimeAgo { get; set; }
//            public bool IsRead { get; set; }
//        }

//        protected void btnSearch_Click(object sender, EventArgs e)
//        {
//            LoadOppositeGenderProfilesWithFilters();
//        }

//        private void LoadOppositeGenderProfilesWithFilters()
//        {
//            try
//            {
//                string currentUserGender = hdnCurrentUserGender.Value;
//                if (string.IsNullOrEmpty(currentUserGender))
//                {
//                    pnlNoProfiles.Visible = true;
//                    return;
//                }

//                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
//                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        SELECT 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Gender,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                 THEN 1 ELSE 0 END as IsPremium
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender = @Gender 
//                        AND u.UserID != @CurrentUserID
//                        AND u.CreatedDate IS NOT NULL
//                        AND u.UserID NOT IN (
//                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @CurrentUserID
//                            UNION
//                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @CurrentUserID
//                        )";

//                    List<string> filters = new List<string>();
//                    SqlCommand cmd = new SqlCommand();

//                    cmd.Parameters.AddWithValue("@Gender", oppositeGender);
//                    cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);

//                    if (!string.IsNullOrEmpty(txtAgeFrom.Text) && !string.IsNullOrEmpty(txtAgeTo.Text))
//                    {
//                        int ageFrom = Convert.ToInt32(txtAgeFrom.Text);
//                        int ageTo = Convert.ToInt32(txtAgeTo.Text);
//                        filters.Add("(DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) BETWEEN @AgeFrom AND @AgeTo)");
//                        cmd.Parameters.AddWithValue("@AgeFrom", ageFrom);
//                        cmd.Parameters.AddWithValue("@AgeTo", ageTo);
//                    }

//                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
//                    {
//                        filters.Add("u.City = @City");
//                        cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);
//                    }

//                    if (!string.IsNullOrEmpty(ddlEducation.SelectedValue))
//                    {
//                        filters.Add("u.Education = @Education");
//                        cmd.Parameters.AddWithValue("@Education", ddlEducation.SelectedValue);
//                    }

//                    if (filters.Count > 0)
//                    {
//                        query += " AND " + string.Join(" AND ", filters);
//                    }

//                    query += " ORDER BY NEWID()";

//                    cmd.CommandText = query;
//                    cmd.Connection = conn;

//                    conn.Open();
//                    SqlDataReader reader = cmd.ExecuteReader();

//                    if (reader.HasRows)
//                    {
//                        DataTable dt = new DataTable();
//                        dt.Load(reader);
//                        rptProfiles.DataSource = dt;
//                        rptProfiles.DataBind();
//                        pnlNoProfiles.Visible = false;
//                    }
//                    else
//                    {
//                        rptProfiles.DataSource = null;
//                        rptProfiles.DataBind();
//                        pnlNoProfiles.Visible = true;
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                pnlNoProfiles.Visible = true;
//            }
//        }

//        protected void btnReset_Click(object sender, EventArgs e)
//        {
//            txtAgeFrom.Text = "";
//            txtAgeTo.Text = "";
//            ddlCity.SelectedIndex = 0;
//            ddlEducation.SelectedIndex = 0;
//            LoadOppositeGenderProfiles();
//        }

//        protected void btnLogout_Click(object sender, EventArgs e)
//        {
//            Session.Clear();
//            Session.Abandon();
//            Response.Redirect("Login.aspx");
//        }
//    }
//}


















//using System;
//using System.Collections.Generic;
//using System.Data;
//using System.Data.SqlClient;
//using System.Web.Services;
//using System.Web.UI;
//using System.Web.UI.HtmlControls;
//using System.Web.UI.WebControls;

//namespace JivanBandhan4
//{
//    public partial class Dashboard : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                if (Session["UserID"] != null)
//                {
//                    int userID = Convert.ToInt32(Session["UserID"]);
//                    LoadCurrentUserProfile(userID);
//                    LoadOppositeGenderProfiles();
//                    LoadUserStats(userID);
//                    BindCityDropdown();
//                }
//                else
//                {
//                    Response.Redirect("Login.aspx");
//                }
//            }
//        }

//        private void LoadCurrentUserProfile(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT UserID, Email, FullName, Gender, DateOfBirth, Occupation, 
//                                   City, State, Education, CreatedDate,
//                                   DATEDIFF(YEAR, DateOfBirth, GETDATE()) as Age
//                                   FROM Users 
//                                   WHERE UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            lblUserName.Text = reader["FullName"].ToString();
//                            lblUserFullName.Text = reader["FullName"].ToString();

//                            if (reader["DateOfBirth"] != DBNull.Value)
//                            {
//                                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
//                                int age = DateTime.Now.Year - dob.Year;
//                                string occupation = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
//                                lblUserAgeOccupation.Text = $"{age} Years | {occupation}";
//                            }

//                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
//                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
//                            lblUserLocation.Text = $"{city}, {state}";

//                            if (reader["CreatedDate"] != DBNull.Value)
//                            {
//                                DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
//                                lblMemberSince.Text = createdDate.ToString("MMM yyyy");
//                            }

//                            hdnCurrentUserID.Value = userID.ToString();
//                            hdnCurrentUserGender.Value = reader["Gender"].ToString();

//                            LoadUserHighQualityProfilePhoto(userID, imgUserPhoto);
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadCurrentUserProfile error: " + ex.Message);
//            }
//        }

//        private void LoadUserHighQualityProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                   WHERE UserID = @UserID 
//                                   ORDER BY 
//                                       CASE WHEN PhotoType = 'Profile' THEN 1 ELSE 2 END,
//                                       UploadDate DESC";

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
//                        }
//                        else
//                        {
//                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
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

//        private void LoadOppositeGenderProfiles()
//        {
//            try
//            {
//                string currentUserGender = hdnCurrentUserGender.Value;
//                if (string.IsNullOrEmpty(currentUserGender))
//                {
//                    pnlNoProfiles.Visible = true;
//                    return;
//                }

//                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
//                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Updated query to exclude blocked users
//                    string query = @"
//                        SELECT TOP 12 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Gender,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                 THEN 1 ELSE 0 END as IsPremium
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender = @Gender 
//                        AND u.UserID != @CurrentUserID
//                        AND u.CreatedDate IS NOT NULL
//                        AND u.UserID NOT IN (
//                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @CurrentUserID
//                            UNION
//                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @CurrentUserID
//                        )
//                        ORDER BY NEWID()";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@Gender", oppositeGender);
//                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);

//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.HasRows)
//                        {
//                            DataTable dt = new DataTable();
//                            dt.Load(reader);
//                            rptProfiles.DataSource = dt;
//                            rptProfiles.DataBind();
//                            pnlNoProfiles.Visible = false;
//                        }
//                        else
//                        {
//                            rptProfiles.DataSource = null;
//                            rptProfiles.DataBind();
//                            pnlNoProfiles.Visible = true;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                pnlNoProfiles.Visible = true;
//            }
//        }

//        private void LoadUserStats(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    string viewsQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID";
//                    SqlCommand viewsCmd = new SqlCommand(viewsQuery, conn);
//                    viewsCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblProfileViews.Text = viewsCmd.ExecuteScalar().ToString();
//                    lblTotalViews.Text = lblProfileViews.Text;

//                    string interestsReceivedQuery = "SELECT COUNT(*) FROM Interests WHERE TargetUserID = @UserID AND Status = 'Pending'";
//                    SqlCommand interestsReceivedCmd = new SqlCommand(interestsReceivedQuery, conn);
//                    interestsReceivedCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblInterestsReceived.Text = interestsReceivedCmd.ExecuteScalar().ToString();
//                    lblTotalInterests.Text = lblInterestsReceived.Text;

//                    string interestsSentQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @UserID";
//                    SqlCommand interestsSentCmd = new SqlCommand(interestsSentQuery, conn);
//                    interestsSentCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblInterestsSent.Text = interestsSentCmd.ExecuteScalar().ToString();

//                    string messagesQuery = "SELECT COUNT(*) FROM Messages WHERE FromUserID = @UserID";
//                    SqlCommand messagesCmd = new SqlCommand(messagesQuery, conn);
//                    messagesCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblMessages.Text = messagesCmd.ExecuteScalar().ToString();

//                    Random rnd = new Random();
//                    lblTodayMatches.Text = rnd.Next(5, 20).ToString();
//                    lblNewMessages.Text = rnd.Next(0, 10).ToString();
//                }
//            }
//            catch (Exception ex)
//            {
//                lblProfileViews.Text = "0";
//                lblInterestsReceived.Text = "0";
//                lblInterestsSent.Text = "0";
//                lblMessages.Text = "0";
//                lblTotalViews.Text = "0";
//                lblTotalInterests.Text = "0";
//                lblTodayMatches.Text = "0";
//                lblNewMessages.Text = "0";
//            }
//        }

//        protected void rptProfiles_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
//        {
//            if (e.Item.ItemType == System.Web.UI.WebControls.ListItemType.Item ||
//                e.Item.ItemType == System.Web.UI.WebControls.ListItemType.AlternatingItem)
//            {
//                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
//                if (imgProfile != null)
//                {
//                    imgProfile.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
//                }

//                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
//                if (ltAge != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    ltAge.Text = CalculateAgeInline(row["DateOfBirth"]);
//                }

//                HtmlGenericControl premiumBadge = (HtmlGenericControl)e.Item.FindControl("premiumBadge");
//                if (premiumBadge != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    bool isPremium = Convert.ToBoolean(row["IsPremium"]);
//                    premiumBadge.Visible = isPremium;
//                }
//            }
//        }

//        private void BindCityDropdown()
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT DISTINCT City FROM Users 
//                                   WHERE City IS NOT NULL AND City <> '' 
//                                   ORDER BY City";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        ddlCity.Items.Clear();
//                        ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem("All Cities", ""));

//                        while (reader.Read())
//                        {
//                            string city = reader["City"].ToString();
//                            if (!string.IsNullOrEmpty(city))
//                            {
//                                ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem(city, city));
//                            }
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("BindCityDropdown error: " + ex.Message);
//            }
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

//                // Check if users are blocked
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
//                            // Delete any existing interests and messages between blocked users
//                            DeleteInterestsBetweenUsers(blockedByUserID, blockedUserID);
//                            DeleteMessagesBetweenUsers(blockedByUserID, blockedUserID);

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

//        private static void DeleteInterestsBetweenUsers(int user1ID, int user2ID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"DELETE FROM Interests 
//                                   WHERE (SentByUserID = @User1ID AND TargetUserID = @User2ID)
//                                   OR (SentByUserID = @User2ID AND TargetUserID = @User1ID)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
//                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error but don't throw
//                System.Diagnostics.Debug.WriteLine("DeleteInterestsBetweenUsers error: " + ex.Message);
//            }
//        }

//        private static void DeleteMessagesBetweenUsers(int user1ID, int user2ID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"DELETE FROM Messages 
//                                   WHERE (FromUserID = @User1ID AND ToUserID = @User2ID)
//                                   OR (FromUserID = @User2ID AND ToUserID = @User1ID)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@User1ID", user1ID);
//                        cmd.Parameters.AddWithValue("@User2ID", user2ID);
//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error but don't throw
//                System.Diagnostics.Debug.WriteLine("DeleteMessagesBetweenUsers error: " + ex.Message);
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

//        protected void btnSearch_Click(object sender, EventArgs e)
//        {
//            LoadOppositeGenderProfilesWithFilters();
//        }

//        private void LoadOppositeGenderProfilesWithFilters()
//        {
//            try
//            {
//                string currentUserGender = hdnCurrentUserGender.Value;
//                if (string.IsNullOrEmpty(currentUserGender))
//                {
//                    pnlNoProfiles.Visible = true;
//                    return;
//                }

//                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
//                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        SELECT 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Gender,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                 THEN 1 ELSE 0 END as IsPremium
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender = @Gender 
//                        AND u.UserID != @CurrentUserID
//                        AND u.CreatedDate IS NOT NULL
//                        AND u.UserID NOT IN (
//                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @CurrentUserID
//                            UNION
//                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @CurrentUserID
//                        )";

//                    List<string> filters = new List<string>();
//                    SqlCommand cmd = new SqlCommand();

//                    cmd.Parameters.AddWithValue("@Gender", oppositeGender);
//                    cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);

//                    if (!string.IsNullOrEmpty(txtAgeFrom.Text) && !string.IsNullOrEmpty(txtAgeTo.Text))
//                    {
//                        int ageFrom = Convert.ToInt32(txtAgeFrom.Text);
//                        int ageTo = Convert.ToInt32(txtAgeTo.Text);
//                        filters.Add("(DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) BETWEEN @AgeFrom AND @AgeTo)");
//                        cmd.Parameters.AddWithValue("@AgeFrom", ageFrom);
//                        cmd.Parameters.AddWithValue("@AgeTo", ageTo);
//                    }

//                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
//                    {
//                        filters.Add("u.City = @City");
//                        cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);
//                    }

//                    if (!string.IsNullOrEmpty(ddlEducation.SelectedValue))
//                    {
//                        filters.Add("u.Education = @Education");
//                        cmd.Parameters.AddWithValue("@Education", ddlEducation.SelectedValue);
//                    }

//                    if (filters.Count > 0)
//                    {
//                        query += " AND " + string.Join(" AND ", filters);
//                    }

//                    query += " ORDER BY NEWID()";

//                    cmd.CommandText = query;
//                    cmd.Connection = conn;

//                    conn.Open();
//                    SqlDataReader reader = cmd.ExecuteReader();

//                    if (reader.HasRows)
//                    {
//                        DataTable dt = new DataTable();
//                        dt.Load(reader);
//                        rptProfiles.DataSource = dt;
//                        rptProfiles.DataBind();
//                        pnlNoProfiles.Visible = false;
//                    }
//                    else
//                    {
//                        rptProfiles.DataSource = null;
//                        rptProfiles.DataBind();
//                        pnlNoProfiles.Visible = true;
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                pnlNoProfiles.Visible = true;
//            }
//        }

//        protected void btnReset_Click(object sender, EventArgs e)
//        {
//            txtAgeFrom.Text = "";
//            txtAgeTo.Text = "";
//            ddlCity.SelectedIndex = 0;
//            ddlEducation.SelectedIndex = 0;
//            LoadOppositeGenderProfiles();
//        }

//        protected void btnLogout_Click(object sender, EventArgs e)
//        {
//            Session.Clear();
//            Session.Abandon();
//            Response.Redirect("Login.aspx");
//        }
//    }
//}












//using System;
//using System.Collections.Generic;
//using System.Data;
//using System.Data.SqlClient;
//using System.Web.Services;
//using System.Web.UI;
//using System.Web.UI.HtmlControls;
//using System.Web.UI.WebControls;

//namespace JivanBandhan4
//{
//    public partial class Dashboard : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {

//                MasterPage master = (MasterPage)this.Master;

//                SetPageContent();

//                if (Session["UserID"] != null)
//                {
//                    int userID = Convert.ToInt32(Session["UserID"]);
//                    LoadCurrentUserProfile(userID);
//                    LoadOppositeGenderProfiles();
//                    LoadUserStats(userID);
//                    BindCityDropdown();
//                    LoadProfileViews();
//                    UpdateRemainingCountsUI(userID);

//                    // Load notification badges
//                    LoadNotificationBadges(userID);
//                    LoadNotifications(userID);
//                }
//                else
//                {
//                    Response.Redirect("Login.aspx");
//                }
//            }
//        }


//        private void SetPageContent()
//        {
//            string currentLanguage = Session["CurrentLanguage"] != null ? Session["CurrentLanguage"].ToString() : "en";

//            if (currentLanguage == "mr")
//            {
//                // Marathi content
//                litPageTitle.Text = "जीवनबंधन मध्ये आपले स्वागत आहे";
//                litPageDescription.Text = "आपला परिपूर्ण जीवनसाथी शोधा...";
//            }
//            else
//            {
//                // English content
//                litPageTitle.Text = "Welcome to JivanBandhan";
//                litPageDescription.Text = "Find your perfect life partner...";
//            }
//        }
//        private void LoadCurrentUserProfile(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT UserID, Email, FullName, Gender, DateOfBirth, Occupation, 
//                                   City, State, Education, Caste, Religion, Height, Manglik,
//                                   CreatedDate, AnnualIncome, MaritalStatus,
//                                   DATEDIFF(YEAR, DateOfBirth, GETDATE()) as Age
//                                   FROM Users 
//                                   WHERE UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            // Set user information
//                            lblUserName.Text = reader["FullName"].ToString();
//                            lblUserFullName.Text = reader["FullName"].ToString();

//                            // Age calculation
//                            if (reader["DateOfBirth"] != DBNull.Value)
//                            {
//                                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
//                                int age = DateTime.Now.Year - dob.Year;
//                                if (DateTime.Now.DayOfYear < dob.DayOfYear)
//                                    age--;

//                                string occupation = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
//                                lblUserAgeOccupation.Text = $"{age} Years | {occupation}";
//                            }
//                            else
//                            {
//                                string occupation = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
//                                lblUserAgeOccupation.Text = $"{occupation}";
//                            }

//                            // Location
//                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
//                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
//                            lblUserLocation.Text = $"{city}, {state}";

//                            // Member since
//                            if (reader["CreatedDate"] != DBNull.Value)
//                            {
//                                DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
//                                lblMemberSince.Text = createdDate.ToString("MMM yyyy");
//                            }

//                            // Store user ID and gender in hidden fields
//                            hdnCurrentUserID.Value = userID.ToString();
//                            hdnCurrentUserGender.Value = reader["Gender"].ToString();

//                            // Set recommendation info based on opposite gender
//                            string currentGender = reader["Gender"].ToString();
//                            string oppositeGender = currentGender == "Male" ? "Female" : "Male";
//                            lblRecommendationInfo.Text = $"Recommended {oppositeGender} profiles for you";

//                            // Load current user's profile photo with high quality
//                            LoadUserHighQualityProfilePhoto(userID, imgUserPhoto);

//                            // Check membership status
//                            CheckMembershipStatus(userID);
//                        }
//                        else
//                        {
//                            Response.Redirect("Login.aspx");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadCurrentUserProfile error: " + ex.Message);
//                ShowErrorMessage("Error loading profile: " + ex.Message);
//            }
//        }

//        private void UpdateRemainingCountsUI(int userID)
//        {
//            try
//            {
//                int remainingMessages = Membership.GetRemainingMessageCount(userID);
//                int remainingInterests = Membership.GetRemainingInterestCount(userID);

//                // Show remaining counts for free users
//                if (hdnCurrentMembership.Value.ToLower() == "free")
//                {
//                    pnlRemainingCounts.Visible = true;

//                    // Values will be updated by JavaScript
//                    ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateRemainingCounts",
//                        $"updateRemainingCountsUI({remainingMessages}, {remainingInterests});", true);
//                }
//                else
//                {
//                    pnlRemainingCounts.Visible = false;

//                    // Update premium stats
//                    if (remainingMessages == int.MaxValue)
//                        lblRemainingMessages.Text = "∞";
//                    else
//                        lblRemainingMessages.Text = remainingMessages.ToString();

//                    if (remainingInterests == int.MaxValue)
//                        lblRemainingInterests.Text = "∞";
//                    else
//                        lblRemainingInterests.Text = remainingInterests.ToString();
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("UpdateRemainingCountsUI error: " + ex.Message);
//            }
//        }

//        private void LoadUserHighQualityProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                   WHERE UserID = @UserID 
//                                   ORDER BY 
//                                       CASE WHEN PhotoType = 'Profile' THEN 1 ELSE 2 END,
//                                       UploadDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();

//                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
//                        {
//                            string photoPath = result.ToString();
//                            SetUserHighQualityPhoto(imgControl, photoPath);
//                        }
//                        else
//                        {
//                            imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadUserHighQualityProfilePhoto error: " + ex.Message);
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
//        }

//        private void SetUserHighQualityPhoto(System.Web.UI.WebControls.Image imgControl, string profilePhotoPath)
//        {
//            try
//            {
//                if (!string.IsNullOrEmpty(profilePhotoPath))
//                {
//                    string resolvedPath = ResolveUrl("~/Uploads/" + hdnCurrentUserID.Value + "/" + profilePhotoPath);
//                    imgControl.ImageUrl = resolvedPath;
//                    imgControl.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";

//                    // Add High Quality CSS class
//                    imgControl.CssClass = imgControl.CssClass.Replace("user-photo-large", "user-photo-large high-quality");

//                    // Add quality parameters if supported
//                    if (profilePhotoPath.ToLower().EndsWith(".jpg") || profilePhotoPath.ToLower().EndsWith(".jpeg"))
//                    {
//                        imgControl.ImageUrl += "?q=85";
//                    }
//                }
//                else
//                {
//                    imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("SetUserHighQualityPhoto error: " + ex.Message);
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
//        }

//        // Inline methods for ASPX page
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

//        public string FormatViewDateInline(object viewDate)
//        {
//            try
//            {
//                if (viewDate == null || viewDate == DBNull.Value)
//                    return "Unknown date";

//                DateTime date = Convert.ToDateTime(viewDate);
//                TimeSpan timeDiff = DateTime.Now - date;

//                if (timeDiff.TotalMinutes < 1)
//                    return "Just now";
//                else if (timeDiff.TotalHours < 1)
//                    return $"{(int)timeDiff.TotalMinutes} minutes ago";
//                else if (timeDiff.TotalDays < 1)
//                    return $"{(int)timeDiff.TotalHours} hours ago";
//                else if (timeDiff.TotalDays < 7)
//                    return $"{(int)timeDiff.TotalDays} days ago";
//                else
//                    return date.ToString("dd MMM yyyy");
//            }
//            catch (Exception)
//            {
//                return "Unknown date";
//            }
//        }

//        private void LoadOppositeGenderProfiles()
//        {
//            try
//            {
//                string currentUserGender = hdnCurrentUserGender.Value;
//                if (string.IsNullOrEmpty(currentUserGender))
//                {
//                    pnlNoProfiles.Visible = true;
//                    lblRecommendationInfo.Text = "Please complete your profile";
//                    return;
//                }

//                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
//                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);
//                string currentMembership = hdnCurrentMembership.Value.ToLower();

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        SELECT TOP 12 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Height, u.Manglik, u.Gender,
//                            u.AnnualIncome, u.MaritalStatus,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                 THEN 1 ELSE 0 END as IsPremium
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender = @Gender 
//                        AND u.UserID != @CurrentUserID
//                        AND u.CreatedDate IS NOT NULL
//                        ORDER BY 
//                            CASE WHEN @CurrentMembership = 'free' THEN 
//                                CASE WHEN um.MembershipType IS NOT NULL THEN 2 ELSE 1 END
//                            ELSE 1 END,
//                            NEWID()";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@Gender", oppositeGender);
//                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
//                        cmd.Parameters.AddWithValue("@CurrentMembership", currentMembership);

//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.HasRows)
//                        {
//                            DataTable dt = new DataTable();
//                            dt.Load(reader);
//                            rptProfiles.DataSource = dt;
//                            rptProfiles.DataBind();
//                            pnlNoProfiles.Visible = false;
//                            pnlLoadMore.Visible = dt.Rows.Count >= 12;
//                        }
//                        else
//                        {
//                            rptProfiles.DataSource = null;
//                            rptProfiles.DataBind();
//                            pnlNoProfiles.Visible = true;
//                            pnlLoadMore.Visible = false;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadOppositeGenderProfiles error: " + ex.Message);
//                pnlNoProfiles.Visible = true;
//                lblRecommendationInfo.Text = "Error loading profiles";
//            }
//        }

//        private void LoadUserStats(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Profile views
//                    string viewsQuery = "SELECT COUNT(*) FROM ProfileViews WHERE UserID = @UserID";
//                    SqlCommand viewsCmd = new SqlCommand(viewsQuery, conn);
//                    viewsCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblProfileViews.Text = viewsCmd.ExecuteScalar().ToString();
//                    lblTotalViews.Text = lblProfileViews.Text;

//                    // Interests received
//                    string interestsReceivedQuery = "SELECT COUNT(*) FROM Interests WHERE TargetUserID = @UserID AND Status = 'Pending'";
//                    SqlCommand interestsReceivedCmd = new SqlCommand(interestsReceivedQuery, conn);
//                    interestsReceivedCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblInterestsReceived.Text = interestsReceivedCmd.ExecuteScalar().ToString();
//                    lblTotalInterests.Text = lblInterestsReceived.Text;

//                    // Interests sent
//                    string interestsSentQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @UserID";
//                    SqlCommand interestsSentCmd = new SqlCommand(interestsSentQuery, conn);
//                    interestsSentCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblInterestsSent.Text = interestsSentCmd.ExecuteScalar().ToString();

//                    // New messages
//                    string messagesQuery = "SELECT COUNT(*) FROM Messages WHERE ToUserID = @UserID AND IsRead = 0 AND IsActive = 1";
//                    SqlCommand messagesCmd = new SqlCommand(messagesQuery, conn);
//                    messagesCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblMessages.Text = messagesCmd.ExecuteScalar().ToString();
//                    lblNewMessages.Text = lblMessages.Text;

//                    // Today matches (random for demo)
//                    Random rnd = new Random();
//                    lblTodayMatches.Text = rnd.Next(5, 20).ToString();
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadUserStats error: " + ex.Message);
//                // Set default values
//                lblProfileViews.Text = "0";
//                lblInterestsReceived.Text = "0";
//                lblInterestsSent.Text = "0";
//                lblMessages.Text = "0";
//                lblTotalViews.Text = "0";
//                lblTotalInterests.Text = "0";
//                lblTodayMatches.Text = "0";
//                lblNewMessages.Text = "0";
//            }
//        }

//        // Profile Views Related Methods
//        private void LoadProfileViews()
//        {
//            try
//            {
//                if (Session["UserID"] == null) return;

//                int currentUserID = Convert.ToInt32(Session["UserID"]);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        SELECT 
//                            pv.ViewedByUserID,
//                            pv.ViewDate,
//                            pv.IPAddress,
//                            u.FullName,
//                            u.City,
//                            u.State,
//                            u.Occupation,
//                            u.Gender,
//                            (SELECT COUNT(*) FROM ProfileViews pv2 
//                             WHERE pv2.UserID = pv.UserID AND pv2.ViewedByUserID = pv.ViewedByUserID) as ViewCount
//                        FROM ProfileViews pv
//                        INNER JOIN Users u ON pv.ViewedByUserID = u.UserID
//                        WHERE pv.UserID = @CurrentUserID
//                        ORDER BY pv.ViewDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.HasRows)
//                        {
//                            DataTable dt = new DataTable();
//                            dt.Load(reader);
//                            rptProfileViews.DataSource = dt;
//                            rptProfileViews.DataBind();
//                            pnlNoViews.Visible = false;

//                            // Update total views count
//                            lblTotalProfileViews.Text = dt.Rows.Count.ToString();
//                        }
//                        else
//                        {
//                            rptProfileViews.DataSource = null;
//                            rptProfileViews.DataBind();
//                            pnlNoViews.Visible = true;
//                            lblTotalProfileViews.Text = "0";
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadProfileViews error: " + ex.Message);
//                pnlNoViews.Visible = true;
//            }
//        }

//        protected void rptProfileViews_ItemDataBound(object sender, RepeaterItemEventArgs e)
//        {
//            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
//            {
//                // Add error handling for viewer images
//                System.Web.UI.WebControls.Image imgViewer = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgViewer");
//                if (imgViewer != null)
//                {
//                    imgViewer.Attributes["onerror"] = "this.src='Images/default-profile.jpg'";

//                    // Add high quality class
//                    imgViewer.CssClass = imgViewer.CssClass.Replace("viewer-img-large", "viewer-img-large high-quality");
//                }

//                // Set view date
//                Literal ltViewDate = (Literal)e.Item.FindControl("ltViewDate");
//                if (ltViewDate != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    ltViewDate.Text = FormatViewDateInline(row["ViewDate"]);
//                }
//            }
//        }

//        protected void rptProfiles_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
//        {
//            if (e.Item.ItemType == System.Web.UI.WebControls.ListItemType.Item ||
//                e.Item.ItemType == System.Web.UI.WebControls.ListItemType.AlternatingItem)
//            {
//                // Add error handling for images
//                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
//                if (imgProfile != null)
//                {
//                    imgProfile.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";

//                    // Add high quality class
//                    imgProfile.CssClass = imgProfile.CssClass.Replace("profile-main-photo-large", "profile-main-photo-large high-quality");
//                }

//                // Set age
//                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
//                if (ltAge != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    ltAge.Text = CalculateAgeInline(row["DateOfBirth"]);
//                }

//                // Set premium badge visibility
//                HtmlGenericControl premiumBadge = (HtmlGenericControl)e.Item.FindControl("premiumBadge");
//                if (premiumBadge != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    bool isPremium = Convert.ToBoolean(row["IsPremium"]);
//                    premiumBadge.Visible = isPremium;

//                    if (isPremium)
//                    {
//                        premiumBadge.Attributes["class"] = "premium-badge";
//                        premiumBadge.InnerText = "⭐ Premium";
//                    }
//                }
//            }
//        }

//        private void CheckMembershipStatus(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT 
//                                    ISNULL(um.MembershipType, 'Free') as MembershipType,
//                                    um.ExpiryDate,
//                                    um.CreatedDate as MembershipStartDate
//                                FROM Users u
//                                LEFT JOIN UserMemberships um ON u.UserID = um.UserID 
//                                    AND um.ExpiryDate > GETDATE()
//                                WHERE u.UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            string membershipType = reader["MembershipType"].ToString();
//                            DateTime? expiryDate = reader["ExpiryDate"] as DateTime?;
//                            DateTime? membershipStartDate = reader["MembershipStartDate"] as DateTime?;

//                            lblMembershipStatus.Text = membershipType;
//                            hdnCurrentMembership.Value = membershipType.ToLower();

//                            switch (membershipType.ToLower())
//                            {
//                                case "silver":
//                                    lblMembershipType.Text = "🥈 Silver Member";
//                                    pnlMembership.Visible = false;
//                                    pnlPremiumFeatures.Visible = true;
//                                    pnlPremiumStats.Visible = true;
//                                    pnlRemainingCounts.Visible = false;
//                                    break;
//                                case "gold":
//                                    lblMembershipType.Text = "🥇 Gold Member";
//                                    pnlMembership.Visible = false;
//                                    pnlPremiumFeatures.Visible = true;
//                                    pnlPremiumStats.Visible = true;
//                                    pnlRemainingCounts.Visible = false;
//                                    break;
//                                case "platinum":
//                                    lblMembershipType.Text = "💎 Platinum Member";
//                                    pnlMembership.Visible = false;
//                                    pnlPremiumFeatures.Visible = true;
//                                    pnlPremiumStats.Visible = true;
//                                    pnlRemainingCounts.Visible = false;
//                                    break;
//                                default:
//                                    lblMembershipType.Text = "🔒 Free Member";
//                                    pnlMembership.Visible = true;
//                                    pnlPremiumFeatures.Visible = false;
//                                    pnlPremiumStats.Visible = false;
//                                    pnlRemainingCounts.Visible = true;
//                                    break;
//                            }

//                            // Show expiry date if available
//                            if (expiryDate.HasValue)
//                            {
//                                lblMembershipExpiry.Text = $"Expiry: {expiryDate.Value:dd MMM yyyy}";
//                            }
//                            else
//                            {
//                                lblMembershipExpiry.Text = "Permanent";
//                            }

//                            // Update premium stats
//                            UpdatePremiumStats(userID, membershipType);
//                        }
//                        else
//                        {
//                            lblMembershipStatus.Text = "Free";
//                            lblMembershipType.Text = "🔒 Free Member";
//                            hdnCurrentMembership.Value = "free";
//                            pnlMembership.Visible = true;
//                            pnlPremiumFeatures.Visible = false;
//                            pnlPremiumStats.Visible = false;
//                            pnlRemainingCounts.Visible = true;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CheckMembershipStatus error: " + ex.Message);
//                lblMembershipStatus.Text = "Free";
//                lblMembershipType.Text = "🔒 Free Member";
//                hdnCurrentMembership.Value = "free";
//                pnlMembership.Visible = true;
//                pnlPremiumFeatures.Visible = false;
//                pnlPremiumStats.Visible = false;
//                pnlRemainingCounts.Visible = true;
//            }
//        }

//        private void UpdatePremiumStats(int userID, string membershipType)
//        {
//            try
//            {
//                int remainingMessages = Membership.GetRemainingMessageCount(userID);
//                int remainingInterests = Membership.GetRemainingInterestCount(userID);

//                if (membershipType.ToLower() == "free")
//                {
//                    lblRemainingMessages.Text = remainingMessages.ToString();
//                    lblRemainingInterests.Text = remainingInterests.ToString();
//                }
//                else
//                {
//                    // Premium users have unlimited access
//                    lblRemainingMessages.Text = "∞";
//                    lblRemainingInterests.Text = "∞";
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("UpdatePremiumStats error: " + ex.Message);
//                lblRemainingMessages.Text = "0";
//                lblRemainingInterests.Text = "0";
//            }
//        }

//        private void BindCityDropdown()
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT DISTINCT City FROM Users 
//                                   WHERE City IS NOT NULL AND City <> '' 
//                                   ORDER BY City";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        ddlCity.Items.Clear();
//                        ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem("All Cities", ""));

//                        while (reader.Read())
//                        {
//                            string city = reader["City"].ToString();
//                            if (!string.IsNullOrEmpty(city))
//                            {
//                                ddlCity.Items.Add(new System.Web.UI.WebControls.ListItem(city, city));
//                            }
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("BindCityDropdown error: " + ex.Message);
//            }
//        }

//        // Notification Badges System
//        private void LoadNotificationBadges(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Get unread messages count
//                    string messagesQuery = @"SELECT COUNT(*) FROM Messages 
//                                           WHERE ToUserID = @UserID AND IsRead = 0 AND IsActive = 1";
//                    SqlCommand messagesCmd = new SqlCommand(messagesQuery, conn);
//                    messagesCmd.Parameters.AddWithValue("@UserID", userID);
//                    int unreadMessages = Convert.ToInt32(messagesCmd.ExecuteScalar());

//                    // Get pending interests count (received interests not yet viewed)
//                    string interestsQuery = @"SELECT COUNT(*) FROM Interests 
//                                            WHERE TargetUserID = @UserID AND Status = 'Pending' AND IsViewed = 0";
//                    SqlCommand interestsCmd = new SqlCommand(interestsQuery, conn);
//                    interestsCmd.Parameters.AddWithValue("@UserID", userID);
//                    int pendingInterests = Convert.ToInt32(interestsCmd.ExecuteScalar());

//                    // Get shortlisted count (profiles shortlisted by current user)
//                    string shortlistedQuery = @"SELECT COUNT(*) FROM Shortlists 
//                                              WHERE UserID = @UserID";
//                    SqlCommand shortlistedCmd = new SqlCommand(shortlistedQuery, conn);
//                    shortlistedCmd.Parameters.AddWithValue("@UserID", userID);
//                    int shortlistedCount = Convert.ToInt32(shortlistedCmd.ExecuteScalar());

//                    // Get new profile views count (last 24 hours)
//                    string viewsQuery = @"SELECT COUNT(*) FROM ProfileViews 
//                                        WHERE UserID = @UserID 
//                                        AND ViewDate > DATEADD(HOUR, -24, GETDATE())";
//                    SqlCommand viewsCmd = new SqlCommand(viewsQuery, conn);
//                    viewsCmd.Parameters.AddWithValue("@UserID", userID);
//                    int newViews = Convert.ToInt32(viewsCmd.ExecuteScalar());

//                    // Update badge visibility and counts
//                    UpdateBadge(pnlMessagesBadge, lblMessagesCount, unreadMessages, "messages");
//                    UpdateBadge(pnlInterestsBadge, lblInterestsCount, pendingInterests, "interests");
//                    UpdateBadge(pnlShortlistedBadge, lblShortlistedCount, shortlistedCount, "shortlist");
//                    UpdateBadge(pnlDashboardBadge, lblDashboardCount, newViews, "dashboard");

//                    // Store counts in session for real-time updates
//                    Session["UnreadMessages"] = unreadMessages;
//                    Session["PendingInterests"] = pendingInterests;
//                    Session["ShortlistedCount"] = shortlistedCount;
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadNotificationBadges error: " + ex.Message);
//            }
//        }

//        private void UpdateBadge(Panel badgePanel, Label countLabel, int count, string badgeType)
//        {
//            if (count > 0)
//            {
//                badgePanel.Visible = true;
//                countLabel.Text = count > 99 ? "99+" : count.ToString();

//                // Add pulse animation for important notifications
//                if (badgeType == "messages" || badgeType == "interests")
//                {
//                    badgePanel.CssClass = "nav-badge pulse";
//                }
//                else
//                {
//                    badgePanel.CssClass = "nav-badge";
//                }
//            }
//            else
//            {
//                badgePanel.Visible = false;
//            }
//        }

//        // Load notifications for notification panel
//        private void LoadNotifications(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        SELECT TOP 10 
//                            n.NotificationID, n.NotificationType, n.Message, n.IsRead, n.CreatedDate,
//                            u.FullName as FromUserName
//                        FROM Notifications n
//                        LEFT JOIN Users u ON n.FromUserID = u.UserID
//                        WHERE n.UserID = @UserID
//                        ORDER BY n.CreatedDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.HasRows)
//                        {
//                            DataTable dt = new DataTable();
//                            dt.Load(reader);
//                            rptNotifications.DataSource = dt;
//                            rptNotifications.DataBind();
//                            pnlNoNotifications.Visible = false;
//                        }
//                        else
//                        {
//                            rptNotifications.DataSource = null;
//                            rptNotifications.DataBind();
//                            pnlNoNotifications.Visible = true;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadNotifications error: " + ex.Message);
//                pnlNoNotifications.Visible = true;
//            }
//        }

//        // Helper method for notification icons
//        public string GetNotificationIcon(object notificationType)
//        {
//            if (notificationType == null) return "🔔";

//            switch (notificationType.ToString().ToLower())
//            {
//                case "message": return "💌";
//                case "interest": return "💝";
//                case "shortlist": return "⭐";
//                case "profile_view": return "👀";
//                default: return "🔔";
//            }
//        }

//        // Helper method for notification time
//        public string FormatNotificationTime(object createdDate)
//        {
//            if (createdDate == null || createdDate == DBNull.Value)
//                return "Unknown time";

//            DateTime date = Convert.ToDateTime(createdDate);
//            TimeSpan timeDiff = DateTime.Now - date;

//            if (timeDiff.TotalMinutes < 1)
//                return "Just now";
//            else if (timeDiff.TotalHours < 1)
//                return $"{(int)timeDiff.TotalMinutes} minutes ago";
//            else if (timeDiff.TotalDays < 1)
//                return $"{(int)timeDiff.TotalHours} hours ago";
//            else if (timeDiff.TotalDays < 7)
//                return $"{(int)timeDiff.TotalDays} days ago";
//            else
//                return date.ToString("dd MMM yyyy");
//        }

//        [WebMethod]
//        public static string SendInterest(int sentByUserID, int targetUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                // Check if user can send interest based on membership
//                if (!Membership.CanUserSendInterest(sentByUserID))
//                {
//                    return "limit_exceeded";
//                }

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Check if interest already exists
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

//                    // Insert new interest
//                    string insertQuery = @"INSERT INTO Interests (SentByUserID, TargetUserID, SentDate, Status) 
//                                         VALUES (@SentByUserID, @TargetUserID, GETDATE(), 'Pending')";
//                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
//                    {
//                        insertCmd.Parameters.AddWithValue("@SentByUserID", sentByUserID);
//                        insertCmd.Parameters.AddWithValue("@TargetUserID", targetUserID);
//                        int rowsAffected = insertCmd.ExecuteNonQuery();

//                        if (rowsAffected > 0)
//                        {
//                            // Create notification for the receiver
//                            CreateNotification(targetUserID, sentByUserID, "interest", $"You have received a new interest");
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
//                System.Diagnostics.Debug.WriteLine("SendInterest error: " + ex.Message);
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static bool CanSendMessage(int userID)
//        {
//            return Membership.CanUserSendMessage(userID);
//        }

//        [WebMethod]
//        public static bool CanSendInterest(int userID)
//        {
//            return Membership.CanUserSendInterest(userID);
//        }

//        [WebMethod]
//        public static string GetRemainingCounts(int userID)
//        {
//            try
//            {
//                int remainingMessages = Membership.GetRemainingMessageCount(userID);
//                int remainingInterests = Membership.GetRemainingInterestCount(userID);

//                return $"{remainingMessages},{remainingInterests}";
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("GetRemainingCounts error: " + ex.Message);
//                return "0,0";
//            }
//        }

//        [WebMethod]
//        public static string CheckNewNotifications(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Check for new messages
//                    string messagesQuery = @"SELECT COUNT(*) FROM Messages 
//                                           WHERE ToUserID = @UserID AND IsRead = 0 AND IsActive = 1";
//                    SqlCommand messagesCmd = new SqlCommand(messagesQuery, conn);
//                    messagesCmd.Parameters.AddWithValue("@UserID", userID);
//                    int newMessages = Convert.ToInt32(messagesCmd.ExecuteScalar());

//                    // Check for new interests
//                    string interestsQuery = @"SELECT COUNT(*) FROM Interests 
//                                            WHERE TargetUserID = @UserID AND Status = 'Pending' AND IsViewed = 0";
//                    SqlCommand interestsCmd = new SqlCommand(interestsQuery, conn);
//                    interestsCmd.Parameters.AddWithValue("@UserID", userID);
//                    int newInterests = Convert.ToInt32(interestsCmd.ExecuteScalar());

//                    return $"{newMessages},{newInterests}";
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CheckNewNotifications error: " + ex.Message);
//                return "0,0";
//            }
//        }

//        [WebMethod]
//        public static string MarkNotificationsAsRead(int userID, string notificationType)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    if (notificationType == "messages")
//                    {
//                        string query = "UPDATE Messages SET IsRead = 1 WHERE ToUserID = @UserID AND IsRead = 0";
//                        SqlCommand cmd = new SqlCommand(query, conn);
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        cmd.ExecuteNonQuery();
//                    }
//                    else if (notificationType == "interests")
//                    {
//                        string query = "UPDATE Interests SET IsViewed = 1 WHERE TargetUserID = @UserID AND IsViewed = 0";
//                        SqlCommand cmd = new SqlCommand(query, conn);
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        cmd.ExecuteNonQuery();
//                    }
//                    else if (notificationType == "all")
//                    {
//                        // Mark all notifications as read
//                        string messagesQuery = "UPDATE Messages SET IsRead = 1 WHERE ToUserID = @UserID AND IsRead = 0";
//                        SqlCommand messagesCmd = new SqlCommand(messagesQuery, conn);
//                        messagesCmd.Parameters.AddWithValue("@UserID", userID);
//                        messagesCmd.ExecuteNonQuery();

//                        string interestsQuery = "UPDATE Interests SET IsViewed = 1 WHERE TargetUserID = @UserID AND IsViewed = 0";
//                        SqlCommand interestsCmd = new SqlCommand(interestsQuery, conn);
//                        interestsCmd.Parameters.AddWithValue("@UserID", userID);
//                        interestsCmd.ExecuteNonQuery();

//                        string notificationsQuery = "UPDATE Notifications SET IsRead = 1 WHERE UserID = @UserID AND IsRead = 0";
//                        SqlCommand notificationsCmd = new SqlCommand(notificationsQuery, conn);
//                        notificationsCmd.Parameters.AddWithValue("@UserID", userID);
//                        notificationsCmd.ExecuteNonQuery();
//                    }

//                    return "success";
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("MarkNotificationsAsRead error: " + ex.Message);
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static string SendMessage(int fromUserID, int toUserID, string messageText)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                // Check if user can send message based on membership
//                if (!Membership.CanUserSendMessage(fromUserID))
//                {
//                    return "limit_exceeded";
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
//                            // Create notification for the receiver
//                            CreateNotification(toUserID, fromUserID, "message", $"You have received a new message");
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
//                System.Diagnostics.Debug.WriteLine("SendMessage error: " + ex.Message);
//                return "error";
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
//                    // Check if already shortlisted
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

//                    // Insert new shortlist
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
//                            CreateNotification(shortlistedUserID, userID, "shortlist", $"Your profile has been shortlisted");
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
//                System.Diagnostics.Debug.WriteLine("ShortlistProfile error: " + ex.Message);
//                return "error";
//            }
//        }

//        [WebMethod]
//        public static bool CheckShortlistStatus(int userID, int shortlistedUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = "SELECT COUNT(*) FROM Shortlists WHERE UserID = @UserID AND ShortlistedUserID = @ShortlistedUserID";
//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        cmd.Parameters.AddWithValue("@ShortlistedUserID", shortlistedUserID);
//                        conn.Open();
//                        int count = (int)cmd.ExecuteScalar();
//                        return count > 0;
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CheckShortlistStatus error: " + ex.Message);
//                return false;
//            }
//        }

//        [WebMethod]
//        public static int GetShortlistCount(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Count of profiles shortlisted by user
//                    string query = "SELECT COUNT(*) FROM Shortlists WHERE UserID = @UserID";
//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        return (int)cmd.ExecuteScalar();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("GetShortlistCount error: " + ex.Message);
//                return 0;
//            }
//        }

//        // Helper method for creating notifications
//        private static void CreateNotification(int userID, int fromUserID, string notificationType, string message)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"INSERT INTO Notifications (UserID, FromUserID, NotificationType, Message, IsRead, CreatedDate)
//                                   VALUES (@UserID, @FromUserID, @NotificationType, @Message, 0, GETDATE())";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        cmd.Parameters.AddWithValue("@FromUserID", fromUserID);
//                        cmd.Parameters.AddWithValue("@NotificationType", notificationType);
//                        cmd.Parameters.AddWithValue("@Message", message);

//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CreateNotification error: " + ex.Message);
//            }
//        }

//        protected void btnSearch_Click(object sender, EventArgs e)
//        {
//            LoadOppositeGenderProfilesWithFilters();
//        }

//        private void LoadOppositeGenderProfilesWithFilters()
//        {
//            try
//            {
//                string currentUserGender = hdnCurrentUserGender.Value;
//                if (string.IsNullOrEmpty(currentUserGender))
//                {
//                    pnlNoProfiles.Visible = true;
//                    return;
//                }

//                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
//                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);
//                string currentMembership = hdnCurrentMembership.Value.ToLower();

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        SELECT 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Height, u.Manglik, u.Gender,
//                            u.AnnualIncome, u.MaritalStatus,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                 THEN 1 ELSE 0 END as IsPremium
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender = @Gender 
//                        AND u.UserID != @CurrentUserID
//                        AND u.CreatedDate IS NOT NULL";

//                    // Add filters
//                    List<string> filters = new List<string>();
//                    SqlCommand cmd = new SqlCommand();

//                    cmd.Parameters.AddWithValue("@Gender", oppositeGender);
//                    cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
//                    cmd.Parameters.AddWithValue("@CurrentMembership", currentMembership);

//                    // Age filter
//                    if (!string.IsNullOrEmpty(txtAgeFrom.Text) && !string.IsNullOrEmpty(txtAgeTo.Text))
//                    {
//                        int ageFrom = Convert.ToInt32(txtAgeFrom.Text);
//                        int ageTo = Convert.ToInt32(txtAgeTo.Text);
//                        filters.Add("(DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) BETWEEN @AgeFrom AND @AgeTo)");
//                        cmd.Parameters.AddWithValue("@AgeFrom", ageFrom);
//                        cmd.Parameters.AddWithValue("@AgeTo", ageTo);
//                    }

//                    // Height filter
//                    if (!string.IsNullOrEmpty(ddlHeight.SelectedValue))
//                    {
//                        filters.Add("u.Height = @Height");
//                        cmd.Parameters.AddWithValue("@Height", ddlHeight.SelectedValue);
//                    }

//                    // Education filter
//                    if (!string.IsNullOrEmpty(ddlEducation.SelectedValue))
//                    {
//                        filters.Add("u.Education = @Education");
//                        cmd.Parameters.AddWithValue("@Education", ddlEducation.SelectedValue);
//                    }

//                    // City filter
//                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
//                    {
//                        filters.Add("u.City = @City");
//                        cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);
//                    }

//                    // Occupation filter
//                    if (!string.IsNullOrEmpty(ddlOccupation.SelectedValue))
//                    {
//                        filters.Add("u.Occupation = @Occupation");
//                        cmd.Parameters.AddWithValue("@Occupation", ddlOccupation.SelectedValue);
//                    }

//                    // Manglik filter
//                    if (!string.IsNullOrEmpty(ddlManglik.SelectedValue))
//                    {
//                        filters.Add("u.Manglik = @Manglik");
//                        cmd.Parameters.AddWithValue("@Manglik", ddlManglik.SelectedValue);
//                    }

//                    // Add WHERE conditions
//                    if (filters.Count > 0)
//                    {
//                        query += " AND " + string.Join(" AND ", filters);
//                    }

//                    query += @" ORDER BY 
//                                CASE WHEN @CurrentMembership = 'free' THEN 
//                                    CASE WHEN um.MembershipType IS NOT NULL THEN 2 ELSE 1 END
//                                ELSE 1 END,
//                                NEWID()";

//                    cmd.CommandText = query;
//                    cmd.Connection = conn;

//                    conn.Open();
//                    SqlDataReader reader = cmd.ExecuteReader();

//                    if (reader.HasRows)
//                    {
//                        DataTable dt = new DataTable();
//                        dt.Load(reader);
//                        rptProfiles.DataSource = dt;
//                        rptProfiles.DataBind();
//                        pnlNoProfiles.Visible = false;
//                        pnlLoadMore.Visible = dt.Rows.Count >= 12;
//                    }
//                    else
//                    {
//                        rptProfiles.DataSource = null;
//                        rptProfiles.DataBind();
//                        pnlNoProfiles.Visible = true;
//                        pnlLoadMore.Visible = false;
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadOppositeGenderProfilesWithFilters error: " + ex.Message);
//                pnlNoProfiles.Visible = true;
//            }
//        }

//        protected void btnReset_Click(object sender, EventArgs e)
//        {
//            txtAgeFrom.Text = "";
//            txtAgeTo.Text = "";
//            ddlHeight.SelectedIndex = 0;
//            ddlEducation.SelectedIndex = 0;
//            ddlCity.SelectedIndex = 0;
//            ddlOccupation.SelectedIndex = 0;
//            ddlManglik.SelectedIndex = 0;
//            LoadOppositeGenderProfiles();
//        }

//        protected void btnRefresh_Click(object sender, EventArgs e)
//        {
//            LoadOppositeGenderProfiles();
//        }

//        protected void btnLoadMore_Click(object sender, EventArgs e)
//        {
//            LoadOppositeGenderProfiles();
//        }

//        protected void btnRefreshViews_Click(object sender, EventArgs e)
//        {
//            LoadProfileViews();
//        }

//        protected void btnImproveProfile_Click(object sender, EventArgs e)
//        {
//            Response.Redirect("MyProfile.aspx?edit=true");
//        }

//        protected void btnUpgradeMembership_Click(object sender, EventArgs e)
//        {
//            Response.Redirect("Membership.aspx");
//        }

//        protected void btnLogout_Click(object sender, EventArgs e)
//        {
//            Session.Clear();
//            Session.Abandon();
//            Response.Redirect("Login.aspx");
//        }

//        private void ShowErrorMessage(string message)
//        {
//            ScriptManager.RegisterStartupScript(this, this.GetType(), "showError",
//                $"alert('{message}');", true);
//        }
//    }
//}




















