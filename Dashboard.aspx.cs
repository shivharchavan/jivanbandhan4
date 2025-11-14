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
                    BindEducationDropdown();
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
                                   City, State, Education, Religion, CreatedDate, Phone,
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
                hdnCurrentUserMembership.Value = membershipType;

                // Set membership badge style
                HtmlGenericControl membershipBadge = (HtmlGenericControl)FindControl("membershipBadge");
                if (membershipBadge != null)
                {
                    membershipBadge.InnerText = membershipType;
                    membershipBadge.Attributes["class"] = $"membership-status membership-{membershipType.ToLower()}";
                }

                // Set user membership tag
                HtmlGenericControl userMembershipTag = (HtmlGenericControl)FindControl("userMembershipTag");
                if (userMembershipTag != null)
                {
                    userMembershipTag.InnerText = membershipType;
                    userMembershipTag.Attributes["class"] = $"membership-tag tag-{membershipType.ToLower()}";
                }

                // Show upgrade prompt for non-platinum users
                pnlUpgradePrompt.Visible = (membershipType != "Platinum");

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

        // Helper method to get membership tag class
        public string GetMembershipTagClass(object membershipType)
        {
            if (membershipType == null || membershipType == DBNull.Value)
                return "tag-free";

            string type = membershipType.ToString().ToLower();
            return $"tag-{type}";
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
                    // Updated query to include membership type and phone number
                    string query = @"
                        SELECT TOP 12 
                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
                            u.Education, u.Caste, u.Religion, u.Gender, u.Phone,
                            ISNULL(um.MembershipType, 'Free') as MembershipType,
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
                HtmlGenericControl profileMembershipTag = (HtmlGenericControl)e.Item.FindControl("profileMembershipTag");
                HtmlGenericControl contactNumberDisplay = (HtmlGenericControl)e.Item.FindControl("contactNumberDisplay");
                HtmlGenericControl contactLocked = (HtmlGenericControl)e.Item.FindControl("contactLocked");
                HtmlButton btnViewContact = (HtmlButton)e.Item.FindControl("btnViewContact");

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

                // Set membership tag
                if (profileMembershipTag != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    string membershipType = row["MembershipType"].ToString();
                    profileMembershipTag.InnerText = membershipType;
                    profileMembershipTag.Attributes["class"] = $"membership-tag tag-{membershipType.ToLower()}";
                }

                // Handle contact number display based on current user's membership - ONLY FOR PLATINUM
                if (contactNumberDisplay != null && contactLocked != null && btnViewContact != null)
                {
                    string currentUserMembership = hdnCurrentUserMembership.Value;

                    // ONLY Platinum members can view contact numbers
                    bool canViewContact = currentUserMembership == "Platinum";

                    if (canViewContact)
                    {
                        // User has Platinum membership - show contact number
                        contactNumberDisplay.Style["display"] = "none"; // Hide initially, will show on button click
                        contactLocked.Style["display"] = "none";
                        btnViewContact.Style["display"] = "block";

                        // Set the contact number in literal
                        Literal ltContactNumber = (Literal)e.Item.FindControl("ltContactNumber");
                        if (ltContactNumber != null)
                        {
                            DataRowView row = (DataRowView)e.Item.DataItem;
                            string phoneNumber = row["Phone"] != DBNull.Value ? row["Phone"].ToString() : "";
                            ltContactNumber.Text = phoneNumber;
                        }
                    }
                    else
                    {
                        // User does NOT have Platinum membership
                        contactNumberDisplay.Style["display"] = "none";
                        contactLocked.Style["display"] = "block";
                        btnViewContact.Style["display"] = "block";
                    }
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
                    // Get all Maharashtra cities from Users table
                    string query = @"SELECT DISTINCT City FROM Users 
                                   WHERE City IS NOT NULL AND City <> '' 
                                   AND State = 'Maharashtra'
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

        private void BindEducationDropdown()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Get all education levels from Users table
                    string query = @"SELECT DISTINCT Education FROM Users 
                                   WHERE Education IS NOT NULL AND Education <> '' 
                                   ORDER BY Education";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlEducation.Items.Clear();
                        ddlEducation.Items.Add(new System.Web.UI.WebControls.ListItem("All Education", ""));

                        while (reader.Read())
                        {
                            string education = reader["Education"].ToString();
                            if (!string.IsNullOrEmpty(education))
                            {
                                ddlEducation.Items.Add(new System.Web.UI.WebControls.ListItem(education, education));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("BindEducationDropdown error: " + ex.Message);
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

        // New method to log contact views
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
                            u.Education, u.Caste, u.Religion, u.Gender, u.MotherTongue, u.Income, u.Phone,
                            ISNULL(um.MembershipType, 'Free') as MembershipType,
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

                    // Religion Filter
                    if (!string.IsNullOrEmpty(ddlReligion.SelectedValue))
                    {
                        query.Append(" AND u.Religion = @Religion");
                        parameters.Add(new SqlParameter("@Religion", ddlReligion.SelectedValue));
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
            ddlReligion.SelectedIndex = 0;
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
//using System.Text;
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
//                                   City, State, Education, Religion, CreatedDate,
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
//                HtmlGenericControl profileHeaderBackground = (HtmlGenericControl)e.Item.FindControl("profileHeaderBackground");

//                if (imgProfile != null && profileHeaderBackground != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    int profileUserID = Convert.ToInt32(row["UserID"]);

//                    // Load high quality photo for each profile
//                    string photoUrl = LoadProfileHighQualityPhoto(profileUserID, imgProfile);

//                    // Set background image for profile header
//                    if (!string.IsNullOrEmpty(photoUrl) && photoUrl != ResolveUrl("~/Images/default-profile.jpg"))
//                    {
//                        profileHeaderBackground.Style.Add("background-image", $"url('{photoUrl}')");
//                        // Add overlay for better text readability
//                        profileHeaderBackground.Style.Add("position", "relative");
//                        profileHeaderBackground.Style.Add("background-size", "cover");
//                        profileHeaderBackground.Style.Add("background-position", "center");

//                        // Add dark overlay for better contrast
//                        profileHeaderBackground.Style.Add("background-blend-mode", "overlay");
//                        profileHeaderBackground.Style.Add("background-color", "rgba(0,0,0,0.3)");
//                    }

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

//        private string LoadProfileHighQualityPhoto(int userID, System.Web.UI.WebControls.Image imgControl)
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
//                            return resolvedPath; // Return the URL for background use
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

//        private void BindCityDropdown()
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT DISTINCT City FROM Users 
//                                   WHERE City IS NOT NULL AND City <> '' 
//                                   AND State = 'Maharashtra'
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
//                    StringBuilder query = new StringBuilder(@"
//                        SELECT 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Gender, u.MotherTongue, u.Income,
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
//                        )");

//                    List<SqlParameter> parameters = new List<SqlParameter>
//                    {
//                        new SqlParameter("@Gender", oppositeGender),
//                        new SqlParameter("@CurrentUserID", currentUserID)
//                    };

//                    // Age Filter
//                    if (!string.IsNullOrEmpty(txtAgeFrom.Text) && int.TryParse(txtAgeFrom.Text, out int ageFrom))
//                    {
//                        query.Append(" AND DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) >= @AgeFrom");
//                        parameters.Add(new SqlParameter("@AgeFrom", ageFrom));
//                    }

//                    if (!string.IsNullOrEmpty(txtAgeTo.Text) && int.TryParse(txtAgeTo.Text, out int ageTo))
//                    {
//                        query.Append(" AND DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) <= @AgeTo");
//                        parameters.Add(new SqlParameter("@AgeTo", ageTo));
//                    }

//                    // City Filter
//                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
//                    {
//                        query.Append(" AND u.City = @City");
//                        parameters.Add(new SqlParameter("@City", ddlCity.SelectedValue));
//                    }

//                    // Education Filter
//                    if (!string.IsNullOrEmpty(ddlEducation.SelectedValue))
//                    {
//                        query.Append(" AND u.Education = @Education");
//                        parameters.Add(new SqlParameter("@Education", ddlEducation.SelectedValue));
//                    }

//                    // Religion Filter
//                    if (!string.IsNullOrEmpty(ddlReligion.SelectedValue))
//                    {
//                        query.Append(" AND u.Religion = @Religion");
//                        parameters.Add(new SqlParameter("@Religion", ddlReligion.SelectedValue));
//                    }

//                    query.Append(" ORDER BY NEWID()");

//                    using (SqlCommand cmd = new SqlCommand(query.ToString(), conn))
//                    {
//                        cmd.Parameters.AddRange(parameters.ToArray());
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
//                System.Diagnostics.Debug.WriteLine("LoadOppositeGenderProfilesWithFilters error: " + ex.Message);
//            }
//        }

//        protected void btnReset_Click(object sender, EventArgs e)
//        {
//            txtAgeFrom.Text = "";
//            txtAgeTo.Text = "";
//            ddlCity.SelectedIndex = 0;
//            ddlEducation.SelectedIndex = 0;
//            ddlReligion.SelectedIndex = 0;
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
//using System.Text;
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
//                HtmlGenericControl profileHeaderBackground = (HtmlGenericControl)e.Item.FindControl("profileHeaderBackground");

//                if (imgProfile != null && profileHeaderBackground != null)
//                {
//                    DataRowView row = (DataRowView)e.Item.DataItem;
//                    int profileUserID = Convert.ToInt32(row["UserID"]);

//                    // Load high quality photo for each profile
//                    string photoUrl = LoadProfileHighQualityPhoto(profileUserID, imgProfile);

//                    // Set background image for profile header
//                    if (!string.IsNullOrEmpty(photoUrl) && photoUrl != ResolveUrl("~/Images/default-profile.jpg"))
//                    {
//                        profileHeaderBackground.Style.Add("background-image", $"url('{photoUrl}')");
//                        // Add overlay for better text readability
//                        profileHeaderBackground.Style.Add("position", "relative");
//                        profileHeaderBackground.Style.Add("background-size", "cover");
//                        profileHeaderBackground.Style.Add("background-position", "center");

//                        // Add dark overlay for better contrast
//                        profileHeaderBackground.Style.Add("background-blend-mode", "overlay");
//                        profileHeaderBackground.Style.Add("background-color", "rgba(0,0,0,0.3)");
//                    }

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

//        private string LoadProfileHighQualityPhoto(int userID, System.Web.UI.WebControls.Image imgControl)
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
//                            return resolvedPath; // Return the URL for background use
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
//                    StringBuilder query = new StringBuilder(@"
//                        SELECT 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Gender, u.MotherTongue, u.Income,
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
//                        )");

//                    List<SqlParameter> parameters = new List<SqlParameter>
//                    {
//                        new SqlParameter("@Gender", oppositeGender),
//                        new SqlParameter("@CurrentUserID", currentUserID)
//                    };

//                    // Age Filter
//                    if (!string.IsNullOrEmpty(txtAgeFrom.Text) && int.TryParse(txtAgeFrom.Text, out int ageFrom))
//                    {
//                        query.Append(" AND DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) >= @AgeFrom");
//                        parameters.Add(new SqlParameter("@AgeFrom", ageFrom));
//                    }

//                    if (!string.IsNullOrEmpty(txtAgeTo.Text) && int.TryParse(txtAgeTo.Text, out int ageTo))
//                    {
//                        query.Append(" AND DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) <= @AgeTo");
//                        parameters.Add(new SqlParameter("@AgeTo", ageTo));
//                    }

//                    // City Filter
//                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
//                    {
//                        query.Append(" AND u.City = @City");
//                        parameters.Add(new SqlParameter("@City", ddlCity.SelectedValue));
//                    }

//                    // Education Filter
//                    if (!string.IsNullOrEmpty(ddlEducation.SelectedValue))
//                    {
//                        query.Append(" AND u.Education = @Education");
//                        parameters.Add(new SqlParameter("@Education", ddlEducation.SelectedValue));
//                    }

//                    query.Append(" ORDER BY NEWID()");

//                    using (SqlCommand cmd = new SqlCommand(query.ToString(), conn))
//                    {
//                        cmd.Parameters.AddRange(parameters.ToArray());
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
//                System.Diagnostics.Debug.WriteLine("LoadOppositeGenderProfilesWithFilters error: " + ex.Message);
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






























