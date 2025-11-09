
using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace JivanBandhan4
{
    public partial class Matches : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SetPageContent();
                MasterPage master = (MasterPage)this.Master;

                if (Session["UserID"] != null)
                {
                    int userID = Convert.ToInt32(Session["UserID"]);
                    LoadCurrentUserProfile(userID);
                    LoadMatchedProfiles(userID);
                    LoadComparisonProfiles(userID);
                    LoadMatchStatistics(userID);
                    UpdateMatchBadges(userID);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void SetPageContent()
        {
            string currentLanguage = Session["CurrentLanguage"] != null ? Session["CurrentLanguage"].ToString() : "en";

            if (currentLanguage == "mr")
            {
                // Marathi content
                litPageTitle.Text = "जीवनबंधन मध्ये आपले स्वागत आहे";
                litPageDescription.Text = "आपला परिपूर्ण जीवनसाथी शोधा...";
            }
            else
            {
                // English content
                litPageTitle.Text = "Welcome to JivanBandhan";
                litPageDescription.Text = "Find your perfect life partner...";
            }
        }

        private void LoadCurrentUserProfile(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT UserID, Email, FullName, Gender, DateOfBirth, Occupation, 
                                   City, State, Education, 
                                   PreferredMinAge, PreferredMaxAge, PreferredEducation, PreferredOccupation
                                   FROM Users 
                                   WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            lblUserFullName.Text = reader["FullName"].ToString();

                            // Age calculation
                            if (reader["DateOfBirth"] != DBNull.Value)
                            {
                                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
                                int age = DateTime.Now.Year - dob.Year;
                                if (DateTime.Now.DayOfYear < dob.DayOfYear)
                                    age--;

                                string occupation = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
                                lblUserAgeOccupation.Text = $"{age} Years | {occupation}";
                            }

                            // Location
                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
                            lblUserLocation.Text = $"{city}, {state}";

                            // Store user ID and gender
                            hdnCurrentUserID.Value = userID.ToString();
                            hdnCurrentUserGender.Value = reader["Gender"].ToString();

                            // Load profile photo
                            LoadUserProfilePhoto(userID, imgUserPhoto);

                            // Set preferred criteria
                            SetPreferredCriteria(reader);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadCurrentUserProfile error: " + ex.Message);
            }
        }

        private void SetPreferredCriteria(SqlDataReader reader)
        {
            try
            {
                string currentGender = reader["Gender"].ToString();
                string oppositeGender = currentGender == "Male" ? "Female" : "Male";
                lblPreferredGender.Text = oppositeGender;

                // Age range
                int minAge = reader["PreferredMinAge"] != DBNull.Value ? Convert.ToInt32(reader["PreferredMinAge"]) : 18;
                int maxAge = reader["PreferredMaxAge"] != DBNull.Value ? Convert.ToInt32(reader["PreferredMaxAge"]) : 40;
                lblPreferredAge.Text = $"{minAge} - {maxAge} Years";

                // Education
                string education = reader["PreferredEducation"] != DBNull.Value ? reader["PreferredEducation"].ToString() : "Any";
                lblPreferredEducation.Text = education;

                // Occupation
                string occupation = reader["PreferredOccupation"] != DBNull.Value ? reader["PreferredOccupation"].ToString() : "Any";
                lblPreferredOccupation.Text = occupation;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("SetPreferredCriteria error: " + ex.Message);
            }
        }

        private void LoadMatchedProfiles(int currentUserID)
        {
            try
            {
                string currentUserGender = hdnCurrentUserGender.Value;
                if (string.IsNullOrEmpty(currentUserGender))
                {
                    pnlNoMatches.Visible = true;
                    return;
                }

                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
                string matchType = ddlMatchType.SelectedValue;
                string sortBy = ddlSortBy.SelectedValue;
                int matchScore = Convert.ToInt32(ddlMatchScore.SelectedValue);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
                            u.Education, u.Caste, u.Religion, u.Height, u.Manglik, u.Gender,
                            u.AnnualIncome, u.MaritalStatus,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
                                 THEN 1 ELSE 0 END as IsPremium,
                            -- Match Scores Calculation
                            dbo.CalculateAgeMatchScore(@CurrentUserID, u.UserID) as AgeMatchScore,
                            dbo.CalculateEducationMatchScore(@CurrentUserID, u.UserID) as EducationMatchScore,
                            dbo.CalculateLocationMatchScore(@CurrentUserID, u.UserID) as LocationMatchScore,
                            dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) as MatchPercentage,
                            u.CreatedDate
                        FROM Users u
                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
                        WHERE u.Gender = @Gender 
                        AND u.UserID != @CurrentUserID
                        AND u.IsActive = 1
                        AND dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) >= @MatchScore
                        AND dbo.CheckMutualPreferences(@CurrentUserID, u.UserID) = 1";

                    // Add match type filters
                    switch (matchType)
                    {
                        case "mutual":
                            query += " AND dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) >= 70";
                            break;
                        case "new":
                            query += " AND u.CreatedDate >= DATEADD(DAY, -1, GETDATE())";
                            break;
                        case "premium":
                            query += " AND um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE()";
                            break;
                    }

                    // Add sorting
                    switch (sortBy)
                    {
                        case "newest":
                            query += " ORDER BY u.CreatedDate DESC";
                            break;
                        case "relevance":
                            query += " ORDER BY dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) DESC";
                            break;
                        case "premium":
                            query += " ORDER BY CASE WHEN um.MembershipType IS NOT NULL THEN 1 ELSE 0 END DESC, dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) DESC";
                            break;
                        case "age":
                            query += " ORDER BY DATEDIFF(YEAR, u.DateOfBirth, GETDATE())";
                            break;
                        default:
                            query += " ORDER BY dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) DESC";
                            break;
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                        cmd.Parameters.AddWithValue("@Gender", oppositeGender);
                        cmd.Parameters.AddWithValue("@MatchScore", matchScore);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptMatchedProfiles.DataSource = dt;
                            rptMatchedProfiles.DataBind();
                            pnlNoMatches.Visible = false;
                            pnlLoadMore.Visible = dt.Rows.Count >= 12;

                            lblTotalMatches.Text = dt.Rows.Count.ToString();
                            lblMatchInfo.Text = $"Found {dt.Rows.Count} profiles matching your criteria";
                        }
                        else
                        {
                            rptMatchedProfiles.DataSource = null;
                            rptMatchedProfiles.DataBind();
                            pnlNoMatches.Visible = true;
                            pnlLoadMore.Visible = false;
                            lblMatchInfo.Text = "No matches found with current criteria";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadMatchedProfiles error: " + ex.Message);
                pnlNoMatches.Visible = true;
                lblMatchInfo.Text = "Error loading matches";
            }
        }

        // Load comparison profiles (first two profiles for side-by-side view)
        private void LoadComparisonProfiles(int currentUserID)
        {
            try
            {
                string currentUserGender = hdnCurrentUserGender.Value;
                if (string.IsNullOrEmpty(currentUserGender)) return;

                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
                string matchType = ddlMatchType.SelectedValue;
                int matchScore = Convert.ToInt32(ddlMatchScore.SelectedValue);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT TOP 2
                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
                            u.Education, u.Gender,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
                                 THEN 1 ELSE 0 END as IsPremium,
                            dbo.CalculateAgeMatchScore(@CurrentUserID, u.UserID) as AgeMatchScore,
                            dbo.CalculateEducationMatchScore(@CurrentUserID, u.UserID) as EducationMatchScore,
                            dbo.CalculateLocationMatchScore(@CurrentUserID, u.UserID) as LocationMatchScore,
                            dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) as MatchPercentage
                        FROM Users u
                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
                        WHERE u.Gender = @Gender 
                        AND u.UserID != @CurrentUserID
                        AND u.IsActive = 1
                        AND dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) >= @MatchScore
                        AND dbo.CheckMutualPreferences(@CurrentUserID, u.UserID) = 1";

                    // Add match type filters
                    switch (matchType)
                    {
                        case "mutual":
                            query += " AND dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) >= 70";
                            break;
                        case "new":
                            query += " AND u.CreatedDate >= DATEADD(DAY, -1, GETDATE())";
                            break;
                        case "premium":
                            query += " AND um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE()";
                            break;
                    }

                    query += " ORDER BY dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                        cmd.Parameters.AddWithValue("@Gender", oppositeGender);
                        cmd.Parameters.AddWithValue("@MatchScore", matchScore);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptComparisonProfiles.DataSource = dt;
                            rptComparisonProfiles.DataBind();
                        }
                        else
                        {
                            rptComparisonProfiles.DataSource = null;
                            rptComparisonProfiles.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadComparisonProfiles error: " + ex.Message);
            }
        }

        private void LoadMatchStatistics(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Mutual matches (both preferences match)
                    string mutualQuery = @"
                        SELECT COUNT(*) 
                        FROM Users u 
                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
                        AND u.UserID != @UserID
                        AND dbo.CheckMutualPreferences(@UserID, u.UserID) = 1
                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 60";

                    SqlCommand mutualCmd = new SqlCommand(mutualQuery, conn);
                    mutualCmd.Parameters.AddWithValue("@UserID", userID);
                    lblMutualMatches.Text = mutualCmd.ExecuteScalar().ToString();

                    // Today's matches
                    string todayQuery = @"
                        SELECT COUNT(*) 
                        FROM Users u 
                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
                        AND u.UserID != @UserID
                        AND u.CreatedDate >= CAST(GETDATE() AS DATE)
                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 40";

                    SqlCommand todayCmd = new SqlCommand(todayQuery, conn);
                    todayCmd.Parameters.AddWithValue("@UserID", userID);
                    lblTodayMatches.Text = todayCmd.ExecuteScalar().ToString();

                    // New matches (last 3 days)
                    string newQuery = @"
                        SELECT COUNT(*) 
                        FROM Users u 
                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
                        AND u.UserID != @UserID
                        AND u.CreatedDate >= DATEADD(DAY, -3, GETDATE())
                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 50";

                    SqlCommand newCmd = new SqlCommand(newQuery, conn);
                    newCmd.Parameters.AddWithValue("@UserID", userID);
                    lblNewMatches.Text = newCmd.ExecuteScalar().ToString();

                    // Premium matches
                    string premiumQuery = @"
                        SELECT COUNT(*) 
                        FROM Users u
                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
                        AND u.UserID != @UserID
                        AND um.MembershipType IS NOT NULL
                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 40";

                    SqlCommand premiumCmd = new SqlCommand(premiumQuery, conn);
                    premiumCmd.Parameters.AddWithValue("@UserID", userID);
                    lblPremiumMatches.Text = premiumCmd.ExecuteScalar().ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadMatchStatistics error: " + ex.Message);
            }
        }

        private void UpdateMatchBadges(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Count new high-quality matches (70%+ match score, created in last 24 hours)
                    string query = @"
                        SELECT COUNT(*) 
                        FROM Users u 
                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
                        AND u.UserID != @UserID
                        AND u.CreatedDate >= DATEADD(HOUR, -24, GETDATE())
                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 70";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    int newMatchesCount = Convert.ToInt32(cmd.ExecuteScalar());

                    // Update badge
                    if (newMatchesCount > 0)
                    {
                        pnlMatchesBadge.Visible = true;
                        lblMatchesCount.Text = newMatchesCount > 99 ? "99+" : newMatchesCount.ToString();
                    }
                    else
                    {
                        pnlMatchesBadge.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("UpdateMatchBadges error: " + ex.Message);
            }
        }

        private void LoadUserProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
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
                System.Diagnostics.Debug.WriteLine("LoadUserProfilePhoto error: " + ex.Message);
                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
            }
        }

        // Get profile photo URL for background
        protected string GetProfilePhotoUrl(object userIDObj)
        {
            if (userIDObj == null) return ResolveUrl("~/Images/default-profile.jpg");

            int userID = Convert.ToInt32(userIDObj);
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
                            return ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
                        }
                        else
                        {
                            return ResolveUrl("~/Images/default-profile.jpg");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetProfilePhotoUrl error: " + ex.Message);
                return ResolveUrl("~/Images/default-profile.jpg");
            }
        }

        protected void rptMatchedProfiles_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Add error handling for images
                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
                if (imgProfile != null)
                {
                    imgProfile.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
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
                }
            }
        }

        protected void rptComparisonProfiles_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // Add error handling for images
                System.Web.UI.WebControls.Image imgComparisonProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgComparisonProfile");
                if (imgComparisonProfile != null)
                {
                    imgComparisonProfile.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
                }

                // Set age
                Literal ltComparisonAge = (Literal)e.Item.FindControl("ltComparisonAge");
                if (ltComparisonAge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltComparisonAge.Text = CalculateAgeInline(row["DateOfBirth"]);
                }
            }
        }

        // Inline methods for ASPX page
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

        public string GetMatchColor(int score)
        {
            if (score >= 80) return "high";
            else if (score >= 60) return "medium";
            else return "low";
        }

        // Web Methods for AJAX calls
        [WebMethod]
        public static string SendInterest(int sentByUserID, int targetUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Check if interest already exists
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

                    // Insert new interest
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
                System.Diagnostics.Debug.WriteLine("SendInterest error: " + ex.Message);
                return "error";
            }
        }

        [WebMethod]
        public static string SendMessage(int fromUserID, int toUserID, string messageText)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

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
                System.Diagnostics.Debug.WriteLine("SendMessage error: " + ex.Message);
                return "error";
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
                    // Check if already shortlisted
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

                    // Insert new shortlist
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
                System.Diagnostics.Debug.WriteLine("ShortlistProfile error: " + ex.Message);
                return "error";
            }
        }

        // Event Handlers
        protected void ddlMatchType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                int userID = Convert.ToInt32(Session["UserID"]);
                LoadMatchedProfiles(userID);
                LoadComparisonProfiles(userID);
            }
        }

        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                int userID = Convert.ToInt32(Session["UserID"]);
                LoadMatchedProfiles(userID);
                LoadComparisonProfiles(userID);
            }
        }

        protected void ddlMatchScore_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                int userID = Convert.ToInt32(Session["UserID"]);
                LoadMatchedProfiles(userID);
                LoadComparisonProfiles(userID);
            }
        }

        protected void btnRefreshMatches_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                int userID = Convert.ToInt32(Session["UserID"]);
                LoadMatchedProfiles(userID);
                LoadComparisonProfiles(userID);
                LoadMatchStatistics(userID);
            }
        }

        protected void btnFindMore_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnUpdatePreferences_Click(object sender, EventArgs e)
        {
            Response.Redirect("MyProfile.aspx?section=preferences");
        }

        protected void btnBrowseProfiles_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnLoadMore_Click(object sender, EventArgs e)
        {
            // Implement load more functionality
            if (Session["UserID"] != null)
            {
                int userID = Convert.ToInt32(Session["UserID"]);
                LoadMatchedProfiles(userID);
                LoadComparisonProfiles(userID);
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}






















//using System;
//using System.Data;
//using System.Data.SqlClient;
//using System.Web.Services;
//using System.Web.UI;
//using System.Web.UI.HtmlControls;
//using System.Web.UI.WebControls;

//namespace JivanBandhan4
//{
//    public partial class Matches : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {

//                SetPageContent();
//                MasterPage master = (MasterPage)this.Master;


//                if (Session["UserID"] != null)
//                {
//                    int userID = Convert.ToInt32(Session["UserID"]);
//                    LoadCurrentUserProfile(userID);
//                    LoadMatchedProfiles(userID);
//                    LoadMatchStatistics(userID);
//                    UpdateMatchBadges(userID);
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
//                                   City, State, Education, 
//                                   PreferredMinAge, PreferredMaxAge, PreferredEducation, PreferredOccupation
//                                   FROM Users 
//                                   WHERE UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
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

//                            // Location
//                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
//                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
//                            lblUserLocation.Text = $"{city}, {state}";

//                            // Store user ID and gender
//                            hdnCurrentUserID.Value = userID.ToString();
//                            hdnCurrentUserGender.Value = reader["Gender"].ToString();

//                            // Load profile photo
//                            LoadUserProfilePhoto(userID, imgUserPhoto);

//                            // Set preferred criteria
//                            SetPreferredCriteria(reader);
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadCurrentUserProfile error: " + ex.Message);
//            }
//        }

//        private void SetPreferredCriteria(SqlDataReader reader)
//        {
//            try
//            {
//                string currentGender = reader["Gender"].ToString();
//                string oppositeGender = currentGender == "Male" ? "Female" : "Male";
//                lblPreferredGender.Text = oppositeGender;

//                // Age range
//                int minAge = reader["PreferredMinAge"] != DBNull.Value ? Convert.ToInt32(reader["PreferredMinAge"]) : 18;
//                int maxAge = reader["PreferredMaxAge"] != DBNull.Value ? Convert.ToInt32(reader["PreferredMaxAge"]) : 40;
//                lblPreferredAge.Text = $"{minAge} - {maxAge} Years";

//                // Education
//                string education = reader["PreferredEducation"] != DBNull.Value ? reader["PreferredEducation"].ToString() : "Any";
//                lblPreferredEducation.Text = education;

//                // Occupation
//                string occupation = reader["PreferredOccupation"] != DBNull.Value ? reader["PreferredOccupation"].ToString() : "Any";
//                lblPreferredOccupation.Text = occupation;
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("SetPreferredCriteria error: " + ex.Message);
//            }
//        }

//        private void LoadMatchedProfiles(int currentUserID)
//        {
//            try
//            {
//                string currentUserGender = hdnCurrentUserGender.Value;
//                if (string.IsNullOrEmpty(currentUserGender))
//                {
//                    pnlNoMatches.Visible = true;
//                    return;
//                }

//                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
//                string matchType = ddlMatchType.SelectedValue;
//                string sortBy = ddlSortBy.SelectedValue;
//                int matchScore = Convert.ToInt32(ddlMatchScore.SelectedValue);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"
//                        SELECT 
//                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
//                            u.Education, u.Caste, u.Religion, u.Height, u.Manglik, u.Gender,
//                            u.AnnualIncome, u.MaritalStatus,
//                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                 THEN 1 ELSE 0 END as IsPremium,
//                            -- Match Scores Calculation
//                            dbo.CalculateAgeMatchScore(@CurrentUserID, u.UserID) as AgeMatchScore,
//                            dbo.CalculateEducationMatchScore(@CurrentUserID, u.UserID) as EducationMatchScore,
//                            dbo.CalculateLocationMatchScore(@CurrentUserID, u.UserID) as LocationMatchScore,
//                            dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) as MatchPercentage,
//                            u.CreatedDate
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender = @Gender 
//                        AND u.UserID != @CurrentUserID
//                        AND u.IsActive = 1
//                        AND dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) >= @MatchScore
//                        AND dbo.CheckMutualPreferences(@CurrentUserID, u.UserID) = 1";

//                    // Add match type filters
//                    switch (matchType)
//                    {
//                        case "mutual":
//                            query += " AND dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) >= 70";
//                            break;
//                        case "new":
//                            query += " AND u.CreatedDate >= DATEADD(DAY, -1, GETDATE())";
//                            break;
//                        case "premium":
//                            query += " AND um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE()";
//                            break;
//                    }

//                    // Add sorting
//                    switch (sortBy)
//                    {
//                        case "newest":
//                            query += " ORDER BY u.CreatedDate DESC";
//                            break;
//                        case "relevance":
//                            query += " ORDER BY dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) DESC";
//                            break;
//                        case "premium":
//                            query += " ORDER BY CASE WHEN um.MembershipType IS NOT NULL THEN 1 ELSE 0 END DESC, dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) DESC";
//                            break;
//                        case "age":
//                            query += " ORDER BY DATEDIFF(YEAR, u.DateOfBirth, GETDATE())";
//                            break;
//                        default:
//                            query += " ORDER BY dbo.CalculateOverallMatchScore(@CurrentUserID, u.UserID) DESC";
//                            break;
//                    }

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
//                        cmd.Parameters.AddWithValue("@Gender", oppositeGender);
//                        cmd.Parameters.AddWithValue("@MatchScore", matchScore);

//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.HasRows)
//                        {
//                            DataTable dt = new DataTable();
//                            dt.Load(reader);
//                            rptMatchedProfiles.DataSource = dt;
//                            rptMatchedProfiles.DataBind();
//                            pnlNoMatches.Visible = false;
//                            pnlLoadMore.Visible = dt.Rows.Count >= 12;

//                            lblTotalMatches.Text = dt.Rows.Count.ToString();
//                            lblMatchInfo.Text = $"Found {dt.Rows.Count} profiles matching your criteria";
//                        }
//                        else
//                        {
//                            rptMatchedProfiles.DataSource = null;
//                            rptMatchedProfiles.DataBind();
//                            pnlNoMatches.Visible = true;
//                            pnlLoadMore.Visible = false;
//                            lblMatchInfo.Text = "No matches found with current criteria";
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadMatchedProfiles error: " + ex.Message);
//                pnlNoMatches.Visible = true;
//                lblMatchInfo.Text = "Error loading matches";
//            }
//        }

//        private void LoadMatchStatistics(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Mutual matches (both preferences match)
//                    string mutualQuery = @"
//                        SELECT COUNT(*) 
//                        FROM Users u 
//                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
//                        AND u.UserID != @UserID
//                        AND dbo.CheckMutualPreferences(@UserID, u.UserID) = 1
//                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 60";

//                    SqlCommand mutualCmd = new SqlCommand(mutualQuery, conn);
//                    mutualCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblMutualMatches.Text = mutualCmd.ExecuteScalar().ToString();

//                    // Today's matches
//                    string todayQuery = @"
//                        SELECT COUNT(*) 
//                        FROM Users u 
//                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
//                        AND u.UserID != @UserID
//                        AND u.CreatedDate >= CAST(GETDATE() AS DATE)
//                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 40";

//                    SqlCommand todayCmd = new SqlCommand(todayQuery, conn);
//                    todayCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblTodayMatches.Text = todayCmd.ExecuteScalar().ToString();

//                    // New matches (last 3 days)
//                    string newQuery = @"
//                        SELECT COUNT(*) 
//                        FROM Users u 
//                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
//                        AND u.UserID != @UserID
//                        AND u.CreatedDate >= DATEADD(DAY, -3, GETDATE())
//                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 50";

//                    SqlCommand newCmd = new SqlCommand(newQuery, conn);
//                    newCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblNewMatches.Text = newCmd.ExecuteScalar().ToString();

//                    // Premium matches
//                    string premiumQuery = @"
//                        SELECT COUNT(*) 
//                        FROM Users u
//                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
//                        AND u.UserID != @UserID
//                        AND um.MembershipType IS NOT NULL
//                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 40";

//                    SqlCommand premiumCmd = new SqlCommand(premiumQuery, conn);
//                    premiumCmd.Parameters.AddWithValue("@UserID", userID);
//                    lblPremiumMatches.Text = premiumCmd.ExecuteScalar().ToString();
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadMatchStatistics error: " + ex.Message);
//            }
//        }

//        private void UpdateMatchBadges(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Count new high-quality matches (70%+ match score, created in last 24 hours)
//                    string query = @"
//                        SELECT COUNT(*) 
//                        FROM Users u 
//                        WHERE u.Gender != (SELECT Gender FROM Users WHERE UserID = @UserID)
//                        AND u.UserID != @UserID
//                        AND u.CreatedDate >= DATEADD(HOUR, -24, GETDATE())
//                        AND dbo.CalculateOverallMatchScore(@UserID, u.UserID) >= 70";

//                    SqlCommand cmd = new SqlCommand(query, conn);
//                    cmd.Parameters.AddWithValue("@UserID", userID);
//                    int newMatchesCount = Convert.ToInt32(cmd.ExecuteScalar());

//                    // Update badge
//                    if (newMatchesCount > 0)
//                    {
//                        pnlMatchesBadge.Visible = true;
//                        lblMatchesCount.Text = newMatchesCount > 99 ? "99+" : newMatchesCount.ToString();
//                    }
//                    else
//                    {
//                        pnlMatchesBadge.Visible = false;
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("UpdateMatchBadges error: " + ex.Message);
//            }
//        }

//        private void LoadUserProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
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
//                            imgControl.ImageUrl = ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
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
//                System.Diagnostics.Debug.WriteLine("LoadUserProfilePhoto error: " + ex.Message);
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
//        }

//        protected void rptMatchedProfiles_ItemDataBound(object sender, RepeaterItemEventArgs e)
//        {
//            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
//            {
//                // Add error handling for images
//                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
//                if (imgProfile != null)
//                {
//                    imgProfile.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
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
//                }
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

//        public string GetMatchColor(int score)
//        {
//            if (score >= 80) return "high";
//            else if (score >= 60) return "medium";
//            else return "low";
//        }

//        // Web Methods for AJAX calls
//        [WebMethod]
//        public static string SendInterest(int sentByUserID, int targetUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

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
//        public static string SendMessage(int fromUserID, int toUserID, string messageText)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

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

//        // Event Handlers
//        protected void ddlMatchType_SelectedIndexChanged(object sender, EventArgs e)
//        {
//            if (Session["UserID"] != null)
//            {
//                int userID = Convert.ToInt32(Session["UserID"]);
//                LoadMatchedProfiles(userID);
//            }
//        }

//        protected void ddlSortBy_SelectedIndexChanged(object sender, EventArgs e)
//        {
//            if (Session["UserID"] != null)
//            {
//                int userID = Convert.ToInt32(Session["UserID"]);
//                LoadMatchedProfiles(userID);
//            }
//        }

//        protected void ddlMatchScore_SelectedIndexChanged(object sender, EventArgs e)
//        {
//            if (Session["UserID"] != null)
//            {
//                int userID = Convert.ToInt32(Session["UserID"]);
//                LoadMatchedProfiles(userID);
//            }
//        }

//        protected void btnRefreshMatches_Click(object sender, EventArgs e)
//        {
//            if (Session["UserID"] != null)
//            {
//                int userID = Convert.ToInt32(Session["UserID"]);
//                LoadMatchedProfiles(userID);
//                LoadMatchStatistics(userID);
//            }
//        }

//        protected void btnFindMore_Click(object sender, EventArgs e)
//        {
//            Response.Redirect("Dashboard.aspx");
//        }

//        protected void btnUpdatePreferences_Click(object sender, EventArgs e)
//        {
//            Response.Redirect("MyProfile.aspx?section=preferences");
//        }

//        protected void btnBrowseProfiles_Click(object sender, EventArgs e)
//        {
//            Response.Redirect("Dashboard.aspx");
//        }

//        protected void btnLoadMore_Click(object sender, EventArgs e)
//        {
//            // Implement load more functionality
//            if (Session["UserID"] != null)
//            {
//                int userID = Convert.ToInt32(Session["UserID"]);
//                LoadMatchedProfiles(userID);
//            }
//        }

//        protected void btnLogout_Click(object sender, EventArgs e)
//        {
//            Session.Clear();
//            Session.Abandon();
//            Response.Redirect("Login.aspx");
//        }
//    }
//}