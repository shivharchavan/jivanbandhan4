using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace JivanBandhan4
{
    public partial class ViewUserProfile : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    hdnCurrentUserID.Value = Session["UserID"].ToString();

                    if (Request.QueryString["UserID"] != null)
                    {
                        int viewedUserID = Convert.ToInt32(Request.QueryString["UserID"]);
                        hdnViewedUserID.Value = viewedUserID.ToString();
                        LoadUserProfile(viewedUserID);
                        LoadUserPhotos(viewedUserID);
                        UpdateProfileViewCount(viewedUserID);
                        CheckUserActions(Convert.ToInt32(Session["UserID"]), viewedUserID);
                    }
                    else
                    {
                        Response.Redirect("Dashboard.aspx");
                    }
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadUserProfile(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT 
                                    u.UserID, u.Email, u.FullName, u.Gender, u.DateOfBirth, 
                                    u.Height, u.Weight, u.BloodGroup, u.PhysicalStatus,
                                    u.Religion, u.Caste, u.SubCaste, u.Gothra, u.Manglik,
                                    u.MotherTongue, u.MaritalStatus, u.EatingHabits,
                                    u.DrinkingHabits, u.SmokingHabits, u.Education,
                                    u.EducationField, u.College, u.Occupation, u.OccupationField,
                                    u.Company, u.AnnualIncome, u.WorkingLocation,
                                    u.Country, u.State, u.District, u.City, u.Phone,
                                    u.FamilyType, u.FamilyStatus, u.FatherOccupation,
                                    u.MotherOccupation, u.NoOfBrothers, u.NoOfSisters,
                                    u.NativePlace, u.FamilyDetails, u.AboutMe, u.Hobbies,
                                    u.PartnerExpectations, u.ProfilePhoto, u.CreatedDate,
                                    DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age
                                FROM Users u
                                WHERE u.UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // Set basic information
                            lblFullName.Text = reader["FullName"].ToString();
                            lblPersonalFullName.Text = reader["FullName"].ToString();

                            // Age
                            if (reader["Age"] != DBNull.Value)
                            {
                                lblAge.Text = reader["Age"].ToString();
                            }
                            else
                            {
                                lblAge.Text = "Not specified";
                            }

                            // Height
                            lblHeight.Text = reader["Height"] != DBNull.Value ? reader["Height"].ToString() : "Not specified";

                            // Religion and Caste
                            lblReligion.Text = reader["Religion"] != DBNull.Value ? reader["Religion"].ToString() : "Not specified";
                            lblPersonalReligion.Text = lblReligion.Text;
                            lblCaste.Text = reader["Caste"] != DBNull.Value ? reader["Caste"].ToString() : "Not specified";
                            lblPersonalCaste.Text = lblCaste.Text;

                            // Location
                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
                            lblLocation.Text = $"{city}, {state}";

                            // Occupation and Education
                            lblOccupation.Text = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
                            lblCareerOccupation.Text = lblOccupation.Text;
                            lblEducation.Text = reader["Education"] != DBNull.Value ? reader["Education"].ToString() : "Not specified";
                            lblHighestEducation.Text = lblEducation.Text;

                            // Profile ID
                            lblProfileID.Text = "MB" + userID.ToString("D4");

                            // Set personal information
                            lblGender.Text = reader["Gender"] != DBNull.Value ? reader["Gender"].ToString() : "Not specified";

                            if (reader["DateOfBirth"] != DBNull.Value)
                            {
                                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
                                lblDOB.Text = dob.ToString("dd MMM yyyy");
                            }
                            else
                            {
                                lblDOB.Text = "Not specified";
                            }

                            lblMaritalStatus.Text = reader["MaritalStatus"] != DBNull.Value ? reader["MaritalStatus"].ToString() : "Not specified";
                            lblPersonalMaritalStatus.Text = lblMaritalStatus.Text;

                            // Religious details
                            lblSubCaste.Text = reader["SubCaste"] != DBNull.Value ? reader["SubCaste"].ToString() : "Not specified";
                            lblManglik.Text = reader["Manglik"] != DBNull.Value ? reader["Manglik"].ToString() : "Not specified";

                            // Education details
                            lblEducationField.Text = reader["EducationField"] != DBNull.Value ? reader["EducationField"].ToString() : "Not specified";
                            lblCollege.Text = reader["College"] != DBNull.Value ? reader["College"].ToString() : "Not specified";

                            // Career details
                            lblOccupationField.Text = reader["OccupationField"] != DBNull.Value ? reader["OccupationField"].ToString() : "Not specified";
                            lblAnnualIncome.Text = reader["AnnualIncome"] != DBNull.Value ? reader["AnnualIncome"].ToString() : "Not specified";

                            // Family information
                            lblFamilyType.Text = reader["FamilyType"] != DBNull.Value ? reader["FamilyType"].ToString() : "Not specified";
                            lblFatherOccupation.Text = reader["FatherOccupation"] != DBNull.Value ? reader["FatherOccupation"].ToString() : "Not specified";
                            lblMotherOccupation.Text = reader["MotherOccupation"] != DBNull.Value ? reader["MotherOccupation"].ToString() : "Not specified";

                            // Load profile photo
                            LoadProfilePhoto(userID, imgProfileLarge);
                        }
                        else
                        {
                            Response.Redirect("Dashboard.aspx");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUserProfile error: " + ex.Message);
                Response.Redirect("Dashboard.aspx");
            }
        }

        private void LoadUserPhotos(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT PhotoID, PhotoPath, PhotoType, UploadDate, IsProfilePhoto 
                                   FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsActive = 1
                                   ORDER BY 
                                       CASE WHEN IsProfilePhoto = 1 THEN 0 ELSE 1 END,
                                       UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        List<PhotoData> photos = new List<PhotoData>();
                        int photoCount = 0;

                        while (reader.Read())
                        {
                            string photoPath = reader["PhotoPath"].ToString();
                            string photoType = reader["PhotoType"].ToString();
                            bool isProfilePhoto = Convert.ToBoolean(reader["IsProfilePhoto"]);

                            if (!string.IsNullOrEmpty(photoPath))
                            {
                                string photoUrl = GetPhotoUrl(userID, photoPath);
                                string photoTitle = isProfilePhoto ? "Profile Photo" : $"{photoType} Photo";

                                photos.Add(new PhotoData
                                {
                                    Url = photoUrl,
                                    Title = photoTitle,
                                    IsProfilePhoto = isProfilePhoto
                                });

                                photoCount++;
                            }
                        }

                        if (photos.Count > 0)
                        {
                            // Store photos in hidden field for JavaScript
                            hdnUserPhotos.Value = Newtonsoft.Json.JsonConvert.SerializeObject(photos);

                            // Generate HTML for photo gallery
                            StringBuilder galleryHtml = new StringBuilder();
                            for (int i = 0; i < photos.Count; i++)
                            {
                                galleryHtml.Append($@"
                                    <div class='gallery-item' onclick='openModal({i})'>
                                        <img src='{photos[i].Url}' alt='{photos[i].Title}' class='gallery-photo' 
                                             onerror='this.src=""Images/default-profile.jpg""' />
                                        <div class='photo-overlay'>
                                            <div class='marathi-font'>{photos[i].Title}</div>
                                        </div>
                                    </div>");
                            }

                            photoGallery.InnerHtml = galleryHtml.ToString();
                            pnlNoPhotos.Visible = false;
                        }
                        else
                        {
                            pnlNoPhotos.Visible = true;
                            hdnUserPhotos.Value = "[]"; // Empty array for JavaScript
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUserPhotos error: " + ex.Message);
                pnlNoPhotos.Visible = true;
                hdnUserPhotos.Value = "[]"; // Empty array for JavaScript
            }
        }

        private string GetPhotoUrl(int userID, string photoPath)
        {
            try
            {
                // Check if photo exists in physical path
                string physicalPath = Server.MapPath($"~/Uploads/{userID}/{photoPath}");
                if (System.IO.File.Exists(physicalPath))
                {
                    return ResolveUrl($"~/Uploads/{userID}/{photoPath}");
                }
                else
                {
                    // If photo doesn't exist, return default image
                    return ResolveUrl("~/Images/default-profile.jpg");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetPhotoUrl error: " + ex.Message);
                return ResolveUrl("~/Images/default-profile.jpg");
            }
        }

        private void LoadProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // First try to get profile photo
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsProfilePhoto = 1 AND IsActive = 1
                                   ORDER BY UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            string photoPath = result.ToString();
                            string photoUrl = GetPhotoUrl(userID, photoPath);
                            imgControl.ImageUrl = photoUrl;
                        }
                        else
                        {
                            // If no profile photo, get any active photo
                            query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                     WHERE UserID = @UserID AND IsActive = 1
                                     ORDER BY UploadDate DESC";

                            using (SqlCommand cmd2 = new SqlCommand(query, conn))
                            {
                                cmd2.Parameters.AddWithValue("@UserID", userID);
                                result = cmd2.ExecuteScalar();

                                if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                                {
                                    string photoPath = result.ToString();
                                    string photoUrl = GetPhotoUrl(userID, photoPath);
                                    imgControl.ImageUrl = photoUrl;
                                }
                                else
                                {
                                    imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadProfilePhoto error: " + ex.Message);
                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
            }
        }

        private void UpdateProfileViewCount(int viewedUserID)
        {
            try
            {
                int currentUserID = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO ProfileViews (UserID, ViewedByUserID, ViewDate, IPAddress)
                                   VALUES (@UserID, @ViewedByUserID, GETDATE(), @IPAddress)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", viewedUserID);
                        cmd.Parameters.AddWithValue("@ViewedByUserID", currentUserID);
                        cmd.Parameters.AddWithValue("@IPAddress", Request.UserHostAddress);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("UpdateProfileViewCount error: " + ex.Message);
            }
        }

        private void CheckUserActions(int currentUserID, int viewedUserID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if interest already sent
                    string interestQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @CurrentUserID AND TargetUserID = @ViewedUserID";
                    SqlCommand interestCmd = new SqlCommand(interestQuery, conn);
                    interestCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                    interestCmd.Parameters.AddWithValue("@ViewedUserID", viewedUserID);
                    int interestCount = (int)interestCmd.ExecuteScalar();

                    if (interestCount > 0)
                    {
                        btnSendInterest.Text = "✅ Already Sent";
                        btnSendInterest.Enabled = false;
                        btnSendInterest.Style["background"] = "#ffc107";
                    }

                    // Check if already shortlisted
                    string shortlistQuery = "SELECT COUNT(*) FROM Shortlists WHERE UserID = @CurrentUserID AND ShortlistedUserID = @ViewedUserID";
                    SqlCommand shortlistCmd = new SqlCommand(shortlistQuery, conn);
                    shortlistCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                    shortlistCmd.Parameters.AddWithValue("@ViewedUserID", viewedUserID);
                    int shortlistCount = (int)shortlistCmd.ExecuteScalar();

                    if (shortlistCount > 0)
                    {
                        btnShortlist.Text = "✅ Already Shortlisted";
                        btnShortlist.Enabled = false;
                        btnShortlist.Style["background"] = "#ffc107";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CheckUserActions error: " + ex.Message);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        [WebMethod]
        public static string SendInterest(int sentByUserID, int targetUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Check if interest already exists
                    string checkQuery = @"SELECT COUNT(*) FROM Interests 
                                        WHERE SentByUserID = @SentByUserID 
                                        AND TargetUserID = @TargetUserID";
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
                    string checkQuery = @"SELECT COUNT(*) FROM Shortlists 
                                        WHERE UserID = @UserID 
                                        AND ShortlistedUserID = @ShortlistedUserID";
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

        [WebMethod]
        public static string BlockUser(int blockedByUserID, int blockedUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Check if already blocked
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

                    // Insert new block
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
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("BlockUser error: " + ex.Message);
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
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("ReportUser error: " + ex.Message);
                return "error";
            }
        }

        // Photo data class for JSON serialization
        public class PhotoData
        {
            public string Url { get; set; }
            public string Title { get; set; }
            public bool IsProfilePhoto { get; set; }
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
//    public partial class ViewUserProfile : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                if (Session["UserID"] != null)
//                {
//                    hdnCurrentUserID.Value = Session["UserID"].ToString();

//                    // Get UserID from query string
//                    if (Request.QueryString["UserID"] != null)
//                    {
//                        int viewedUserID = Convert.ToInt32(Request.QueryString["UserID"]);
//                        hdnViewedUserID.Value = viewedUserID.ToString();
//                        LoadUserProfile(viewedUserID);
//                        LoadUserPhotos(viewedUserID);
//                        UpdateProfileViewCount(viewedUserID);

//                        // Check if current user has already sent interest/shortlisted
//                        CheckUserActions(Convert.ToInt32(Session["UserID"]), viewedUserID);
//                    }
//                    else
//                    {
//                        Response.Redirect("Dashboard.aspx");
//                    }
//                }
//                else
//                {
//                    Response.Redirect("Login.aspx");
//                }
//            }
//        }

//        private void LoadUserProfile(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT 
//                                    u.UserID, u.Email, u.FullName, u.Gender, u.DateOfBirth, 
//                                    u.Height, u.Weight, u.BloodGroup, u.PhysicalStatus,
//                                    u.Religion, u.Caste, u.SubCaste, u.Gothra, u.Manglik,
//                                    u.MotherTongue, u.MaritalStatus, u.EatingHabits,
//                                    u.DrinkingHabits, u.SmokingHabits, u.Education,
//                                    u.EducationField, u.College, u.Occupation, u.OccupationField,
//                                    u.Company, u.AnnualIncome, u.WorkingLocation,
//                                    u.Country, u.State, u.District, u.City, u.Phone,
//                                    u.FamilyType, u.FamilyStatus, u.FatherOccupation,
//                                    u.MotherOccupation, u.NoOfBrothers, u.NoOfSisters,
//                                    u.NativePlace, u.FamilyDetails, u.AboutMe, u.Hobbies,
//                                    u.PartnerExpectations, u.ProfilePhoto, u.CreatedDate,
//                                    DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
//                                    CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
//                                         THEN 1 ELSE 0 END as IsPremium,
//                                    (SELECT COUNT(*) FROM ProfileViews WHERE UserID = u.UserID) as ProfileViews,
//                                    (SELECT COUNT(*) FROM Interests WHERE TargetUserID = u.UserID) as InterestsReceived
//                                FROM Users u
//                                LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
//                                WHERE u.UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            // Set basic information
//                            lblFullName.Text = reader["FullName"].ToString();
//                            lblPersonalFullName.Text = reader["FullName"].ToString();

//                            // Age
//                            if (reader["Age"] != DBNull.Value)
//                            {
//                                lblAge.Text = reader["Age"].ToString();
//                            }
//                            else
//                            {
//                                lblAge.Text = "Not specified";
//                            }

//                            // Height
//                            lblHeight.Text = reader["Height"] != DBNull.Value ? reader["Height"].ToString() : "Not specified";

//                            // Religion and Caste
//                            lblReligion.Text = reader["Religion"] != DBNull.Value ? reader["Religion"].ToString() : "Not specified";
//                            lblPersonalReligion.Text = lblReligion.Text;
//                            lblCaste.Text = reader["Caste"] != DBNull.Value ? reader["Caste"].ToString() : "Not specified";
//                            lblPersonalCaste.Text = lblCaste.Text;

//                            // Location
//                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
//                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
//                            lblLocation.Text = $"{city}, {state}";

//                            // Occupation and Education
//                            lblOccupation.Text = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
//                            lblCareerOccupation.Text = lblOccupation.Text;
//                            lblEducation.Text = reader["Education"] != DBNull.Value ? reader["Education"].ToString() : "Not specified";
//                            lblHighestEducation.Text = lblEducation.Text;

//                            // Profile ID
//                            lblProfileID.Text = "MB" + userID.ToString("D4");

//                            // Set personal information
//                            lblGender.Text = reader["Gender"] != DBNull.Value ? reader["Gender"].ToString() : "Not specified";

//                            if (reader["DateOfBirth"] != DBNull.Value)
//                            {
//                                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
//                                lblDOB.Text = dob.ToString("dd MMM yyyy");
//                            }
//                            else
//                            {
//                                lblDOB.Text = "Not specified";
//                            }

//                            lblMaritalStatus.Text = reader["MaritalStatus"] != DBNull.Value ? reader["MaritalStatus"].ToString() : "Not specified";
//                            lblPhysicalStatus.Text = reader["PhysicalStatus"] != DBNull.Value ? reader["PhysicalStatus"].ToString() : "Not specified";

//                            // Religious details
//                            lblSubCaste.Text = reader["SubCaste"] != DBNull.Value ? reader["SubCaste"].ToString() : "Not specified";
//                            lblGothra.Text = reader["Gothra"] != DBNull.Value ? reader["Gothra"].ToString() : "Not specified";
//                            lblManglik.Text = reader["Manglik"] != DBNull.Value ? reader["Manglik"].ToString() : "Not specified";

//                            // Education details
//                            lblEducationField.Text = reader["EducationField"] != DBNull.Value ? reader["EducationField"].ToString() : "Not specified";
//                            lblCollege.Text = reader["College"] != DBNull.Value ? reader["College"].ToString() : "Not specified";

//                            // Career details
//                            lblOccupationField.Text = reader["OccupationField"] != DBNull.Value ? reader["OccupationField"].ToString() : "Not specified";
//                            lblCompany.Text = reader["Company"] != DBNull.Value ? reader["Company"].ToString() : "Not specified";
//                            lblAnnualIncome.Text = reader["AnnualIncome"] != DBNull.Value ? reader["AnnualIncome"].ToString() : "Not specified";

//                            // Family information
//                            lblFamilyType.Text = reader["FamilyType"] != DBNull.Value ? reader["FamilyType"].ToString() : "Not specified";
//                            lblFamilyStatus.Text = reader["FamilyStatus"] != DBNull.Value ? reader["FamilyStatus"].ToString() : "Not specified";
//                            lblFatherOccupation.Text = reader["FatherOccupation"] != DBNull.Value ? reader["FatherOccupation"].ToString() : "Not specified";
//                            lblMotherOccupation.Text = reader["MotherOccupation"] != DBNull.Value ? reader["MotherOccupation"].ToString() : "Not specified";
//                            lblBrothers.Text = reader["NoOfBrothers"] != DBNull.Value ? reader["NoOfBrothers"].ToString() : "0";
//                            lblSisters.Text = reader["NoOfSisters"] != DBNull.Value ? reader["NoOfSisters"].ToString() : "0";
//                            lblNativePlace.Text = reader["NativePlace"] != DBNull.Value ? reader["NativePlace"].ToString() : "Not specified";

//                            // Lifestyle
//                            lblEatingHabits.Text = reader["EatingHabits"] != DBNull.Value ? reader["EatingHabits"].ToString() : "Not specified";
//                            lblDrinkingHabits.Text = reader["DrinkingHabits"] != DBNull.Value ? reader["DrinkingHabits"].ToString() : "Not specified";
//                            lblSmokingHabits.Text = reader["SmokingHabits"] != DBNull.Value ? reader["SmokingHabits"].ToString() : "Not specified";
//                            lblHobbies.Text = reader["Hobbies"] != DBNull.Value ? reader["Hobbies"].ToString() : "Not specified";
//                            lblAboutMe.Text = reader["AboutMe"] != DBNull.Value ? reader["AboutMe"].ToString() : "Not specified";

//                            // Stats
//                            lblProfileViews.Text = reader["ProfileViews"].ToString();
//                            lblInterestsReceived.Text = reader["InterestsReceived"].ToString();

//                            // Premium badge
//                            bool isPremium = Convert.ToBoolean(reader["IsPremium"]);
//                            pnlPremiumBadge.Visible = isPremium;

//                            // Online status (random for demo)
//                            Random rnd = new Random();
//                            bool isOnline = rnd.Next(0, 100) > 50;
//                            onlineStatus.Attributes["class"] = isOnline ?
//                                "online-status marathi-font online" :
//                                "online-status marathi-font offline";

//                            HtmlGenericControl statusTextControl = (HtmlGenericControl)onlineStatus.FindControl("statusText");
//                            if (statusTextControl != null)
//                            {
//                                statusTextControl.InnerText = isOnline ? "Online Now" : "Offline";
//                            }

//                            // Load profile photo
//                            LoadProfilePhoto(userID, imgProfileLarge);
//                        }
//                        else
//                        {
//                            Response.Redirect("Dashboard.aspx");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadUserProfile error: " + ex.Message);
//                Response.Redirect("Dashboard.aspx");
//            }
//        }

//        private void LoadProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
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
//                            SetProfilePhoto(imgControl, photoPath);
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
//                System.Diagnostics.Debug.WriteLine("LoadProfilePhoto error: " + ex.Message);
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
//        }

//        private void SetProfilePhoto(System.Web.UI.WebControls.Image imgControl, string photoPath)
//        {
//            try
//            {
//                if (!string.IsNullOrEmpty(photoPath))
//                {
//                    string resolvedPath = ResolveUrl("~/Uploads/" + hdnViewedUserID.Value + "/" + photoPath);
//                    imgControl.ImageUrl = resolvedPath;
//                    imgControl.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
//                }
//                else
//                {
//                    imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("SetProfilePhoto error: " + ex.Message);
//                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//            }
//        }

//        private void LoadUserPhotos(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT PhotoPath, PhotoType FROM UserPhotos 
//                                   WHERE UserID = @UserID AND IsActive = 1
//                                   ORDER BY 
//                                       CASE WHEN PhotoType = 'Profile' THEN 1 ELSE 2 END,
//                                       UploadDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.HasRows)
//                        {
//                            DataTable dt = new DataTable();
//                            dt.Load(reader);
//                            rptPhotoGallery.DataSource = dt;
//                            rptPhotoGallery.DataBind();
//                            pnlNoPhotos.Visible = false;
//                        }
//                        else
//                        {
//                            rptPhotoGallery.DataSource = null;
//                            rptPhotoGallery.DataBind();
//                            pnlNoPhotos.Visible = true;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadUserPhotos error: " + ex.Message);
//                pnlNoPhotos.Visible = true;
//            }
//        }

//        protected void rptPhotoGallery_ItemDataBound(object sender, RepeaterItemEventArgs e)
//        {
//            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
//            {
//                Label lblPhotoType = (Label)e.Item.FindControl("lblPhotoType");
//                if (lblPhotoType != null)
//                {
//                    string photoType = lblPhotoType.Text;
//                    // Translate photo types to Marathi if needed
//                    if (photoType == "Profile")
//                        lblPhotoType.Text = "प्रोफाइल";
//                    else if (photoType == "Family")
//                        lblPhotoType.Text = "कुटुंब";
//                    else if (photoType == "Hobby")
//                        lblPhotoType.Text = "छंद";
//                    else if (photoType == "Education")
//                        lblPhotoType.Text = "शिक्षण";
//                    else if (photoType == "Career")
//                        lblPhotoType.Text = "करिअर";
//                }

//                // Set the image path correctly
//                System.Web.UI.WebControls.Image img = (System.Web.UI.WebControls.Image)e.Item.FindControl("galleryPhoto");
//                if (img != null)
//                {
//                    string photoPath = DataBinder.Eval(e.Item.DataItem, "PhotoPath").ToString();
//                    if (!string.IsNullOrEmpty(photoPath))
//                    {
//                        string resolvedPath = ResolveUrl("~/Uploads/" + hdnViewedUserID.Value + "/" + photoPath);
//                        img.ImageUrl = resolvedPath;
//                        img.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
//                    }
//                }
//            }
//        }

//        private void UpdateProfileViewCount(int viewedUserID)
//        {
//            try
//            {
//                int currentUserID = Convert.ToInt32(Session["UserID"]);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"INSERT INTO ProfileViews (UserID, ViewedByUserID, ViewDate, IPAddress)
//                                   VALUES (@UserID, @ViewedByUserID, GETDATE(), @IPAddress)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", viewedUserID);
//                        cmd.Parameters.AddWithValue("@ViewedByUserID", currentUserID);
//                        cmd.Parameters.AddWithValue("@IPAddress", Request.UserHostAddress);

//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("UpdateProfileViewCount error: " + ex.Message);
//            }
//        }

//        private void CheckUserActions(int currentUserID, int viewedUserID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Check if interest already sent
//                    string interestQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @CurrentUserID AND TargetUserID = @ViewedUserID";
//                    SqlCommand interestCmd = new SqlCommand(interestQuery, conn);
//                    interestCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
//                    interestCmd.Parameters.AddWithValue("@ViewedUserID", viewedUserID);
//                    int interestCount = (int)interestCmd.ExecuteScalar();

//                    if (interestCount > 0)
//                    {
//                        btnSendInterest.Text = "✅ Already Sent";
//                        btnSendInterest.Enabled = false;
//                        btnSendInterest.Style["background"] = "#ffc107";
//                    }

//                    // Check if already shortlisted
//                    string shortlistQuery = "SELECT COUNT(*) FROM Shortlists WHERE UserID = @CurrentUserID AND ShortlistedUserID = @ViewedUserID";
//                    SqlCommand shortlistCmd = new SqlCommand(shortlistQuery, conn);
//                    shortlistCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
//                    shortlistCmd.Parameters.AddWithValue("@ViewedUserID", viewedUserID);
//                    int shortlistCount = (int)shortlistCmd.ExecuteScalar();

//                    if (shortlistCount > 0)
//                    {
//                        btnShortlist.Text = "✅ Already Shortlisted";
//                        btnShortlist.Enabled = false;
//                        btnShortlist.Style["background"] = "#ffc107";
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CheckUserActions error: " + ex.Message);
//            }
//        }

//        protected void btnBack_Click(object sender, EventArgs e)
//        {
//            Response.Redirect("Dashboard.aspx");
//        }

//        [WebMethod]
//        public static string SendInterest(int sentByUserID, int targetUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                // Check if user can send interest based on membership
//                if (!CanUserSendInterest(sentByUserID))
//                {
//                    return "limit_exceeded";
//                }

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Check if interest already exists
//                    string checkQuery = @"SELECT COUNT(*) FROM Interests 
//                                        WHERE SentByUserID = @SentByUserID 
//                                        AND TargetUserID = @TargetUserID";
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
//                            // Update daily interest count for free users
//                            UpdateDailyInterestCount(sentByUserID);

//                            // Create notification for the receiver
//                            CreateNotification(targetUserID, sentByUserID, "interest",
//                                "You have received a new interest from a user");
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

//                // Check if user can send message based on membership
//                if (!CanUserSendMessage(fromUserID))
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
//                            // Update daily message count for free users
//                            UpdateDailyMessageCount(fromUserID);

//                            // Create notification for the receiver
//                            CreateNotification(toUserID, fromUserID, "message",
//                                "You have received a new message");
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
//                    string checkQuery = @"SELECT COUNT(*) FROM Shortlists 
//                                        WHERE UserID = @UserID 
//                                        AND ShortlistedUserID = @ShortlistedUserID";
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
//                            CreateNotification(shortlistedUserID, userID, "shortlist",
//                                "Your profile has been shortlisted by a user");
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

//        // Helper method to check if user can send interest
//        private static bool CanUserSendInterest(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Check membership type first
//                    string membershipQuery = @"SELECT ISNULL(um.MembershipType, 'Free') as MembershipType
//                                            FROM Users u
//                                            LEFT JOIN UserMemberships um ON u.UserID = um.UserID 
//                                                AND um.ExpiryDate > GETDATE()
//                                            WHERE u.UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        string membershipType = cmd.ExecuteScalar()?.ToString() ?? "Free";

//                        // Premium users have unlimited access
//                        if (membershipType != "Free")
//                        {
//                            return true;
//                        }

//                        // For free users, check daily limit
//                        string limitQuery = @"SELECT COUNT(*) FROM Interests 
//                                            WHERE SentByUserID = @UserID 
//                                            AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)";
//                        using (SqlCommand limitCmd = new SqlCommand(limitQuery, conn))
//                        {
//                            limitCmd.Parameters.AddWithValue("@UserID", userID);
//                            int todayCount = (int)limitCmd.ExecuteScalar();

//                            // Free users can send maximum 5 interests per day
//                            return todayCount < 5;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CanUserSendInterest error: " + ex.Message);
//                return true; // Assume can send on error
//            }
//        }

//        // Helper method to check if user can send message
//        private static bool CanUserSendMessage(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Check membership type first
//                    string membershipQuery = @"SELECT ISNULL(um.MembershipType, 'Free') as MembershipType
//                                            FROM Users u
//                                            LEFT JOIN UserMemberships um ON u.UserID = um.UserID 
//                                                AND um.ExpiryDate > GETDATE()
//                                            WHERE u.UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        string membershipType = cmd.ExecuteScalar()?.ToString() ?? "Free";

//                        // Premium users have unlimited access
//                        if (membershipType != "Free")
//                        {
//                            return true;
//                        }

//                        // For free users, check daily limit
//                        string limitQuery = @"SELECT COUNT(*) FROM Messages 
//                                            WHERE FromUserID = @UserID 
//                                            AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)
//                                            AND IsActive = 1";
//                        using (SqlCommand limitCmd = new SqlCommand(limitQuery, conn))
//                        {
//                            limitCmd.Parameters.AddWithValue("@UserID", userID);
//                            int todayCount = (int)limitCmd.ExecuteScalar();

//                            // Free users can send maximum 3 messages per day
//                            return todayCount < 3;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CanUserSendMessage error: " + ex.Message);
//                return true; // Assume can send on error
//            }
//        }

//        // Update daily interest count for free users
//        private static void UpdateDailyInterestCount(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // For free users, we track daily counts (premium users have unlimited)
//                    string checkMembershipQuery = @"SELECT ISNULL(um.MembershipType, 'Free') as MembershipType
//                                                  FROM Users u
//                                                  LEFT JOIN UserMemberships um ON u.UserID = um.UserID 
//                                                      AND um.ExpiryDate > GETDATE()
//                                                  WHERE u.UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(checkMembershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        string membershipType = cmd.ExecuteScalar()?.ToString() ?? "Free";

//                        if (membershipType == "Free")
//                        {
//                            // Update or insert daily count for free user
//                            string updateQuery = @"IF EXISTS (SELECT 1 FROM UserDailyCounts 
//                                                    WHERE UserID = @UserID AND CountDate = CAST(GETDATE() AS DATE))
//                                                BEGIN
//                                                    UPDATE UserDailyCounts 
//                                                    SET InterestsSent = InterestsSent + 1
//                                                    WHERE UserID = @UserID AND CountDate = CAST(GETDATE() AS DATE)
//                                                END
//                                                ELSE
//                                                BEGIN
//                                                    INSERT INTO UserDailyCounts (UserID, CountDate, InterestsSent, MessagesSent)
//                                                    VALUES (@UserID, CAST(GETDATE() AS DATE), 1, 0)
//                                                END";

//                            using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
//                            {
//                                updateCmd.Parameters.AddWithValue("@UserID", userID);
//                                updateCmd.ExecuteNonQuery();
//                            }
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("UpdateDailyInterestCount error: " + ex.Message);
//            }
//        }

//        // Update daily message count for free users
//        private static void UpdateDailyMessageCount(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // For free users, we track daily counts (premium users have unlimited)
//                    string checkMembershipQuery = @"SELECT ISNULL(um.MembershipType, 'Free') as MembershipType
//                                                  FROM Users u
//                                                  LEFT JOIN UserMemberships um ON u.UserID = um.UserID 
//                                                      AND um.ExpiryDate > GETDATE()
//                                                  WHERE u.UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(checkMembershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        string membershipType = cmd.ExecuteScalar()?.ToString() ?? "Free";

//                        if (membershipType == "Free")
//                        {
//                            // Update or insert daily count for free user
//                            string updateQuery = @"IF EXISTS (SELECT 1 FROM UserDailyCounts 
//                                                    WHERE UserID = @UserID AND CountDate = CAST(GETDATE() AS DATE))
//                                                BEGIN
//                                                    UPDATE UserDailyCounts 
//                                                    SET MessagesSent = MessagesSent + 1
//                                                    WHERE UserID = @UserID AND CountDate = CAST(GETDATE() AS DATE)
//                                                END
//                                                ELSE
//                                                BEGIN
//                                                    INSERT INTO UserDailyCounts (UserID, CountDate, InterestsSent, MessagesSent)
//                                                    VALUES (@UserID, CAST(GETDATE() AS DATE), 0, 1)
//                                                END";

//                            using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
//                            {
//                                updateCmd.Parameters.AddWithValue("@UserID", userID);
//                                updateCmd.ExecuteNonQuery();
//                            }
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("UpdateDailyMessageCount error: " + ex.Message);
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
//                    // Get from user's name for the notification
//                    string fromUserNameQuery = "SELECT FullName FROM Users WHERE UserID = @FromUserID";
//                    string fromUserName = "";

//                    using (SqlCommand nameCmd = new SqlCommand(fromUserNameQuery, conn))
//                    {
//                        nameCmd.Parameters.AddWithValue("@FromUserID", fromUserID);
//                        conn.Open();
//                        object result = nameCmd.ExecuteScalar();
//                        fromUserName = result?.ToString() ?? "A user";
//                    }

//                    // Create personalized notification message
//                    string personalizedMessage = $"{fromUserName} {message.ToLower()}";

//                    string query = @"INSERT INTO Notifications (UserID, FromUserID, NotificationType, Message, IsRead, CreatedDate)
//                                   VALUES (@UserID, @FromUserID, @NotificationType, @Message, 0, GETDATE())";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        cmd.Parameters.AddWithValue("@FromUserID", fromUserID);
//                        cmd.Parameters.AddWithValue("@NotificationType", notificationType);
//                        cmd.Parameters.AddWithValue("@Message", personalizedMessage);
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CreateNotification error: " + ex.Message);
//            }
//        }

//        // Get remaining counts for free users
//        [WebMethod]
//        public static string GetRemainingCounts(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Check membership type
//                    string membershipQuery = @"SELECT ISNULL(um.MembershipType, 'Free') as MembershipType
//                                            FROM Users u
//                                            LEFT JOIN UserMemberships um ON u.UserID = um.UserID 
//                                                AND um.ExpiryDate > GETDATE()
//                                            WHERE u.UserID = @UserID";

//                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        string membershipType = cmd.ExecuteScalar()?.ToString() ?? "Free";

//                        if (membershipType != "Free")
//                        {
//                            // Premium users have unlimited access
//                            return "∞,∞";
//                        }

//                        // For free users, calculate remaining counts
//                        string countsQuery = @"SELECT 
//                                            ISNULL(SUM(CASE WHEN CountDate = CAST(GETDATE() AS DATE) THEN InterestsSent ELSE 0 END), 0) as TodayInterests,
//                                            ISNULL(SUM(CASE WHEN CountDate = CAST(GETDATE() AS DATE) THEN MessagesSent ELSE 0 END), 0) as TodayMessages
//                                        FROM UserDailyCounts 
//                                        WHERE UserID = @UserID";

//                        using (SqlCommand countsCmd = new SqlCommand(countsQuery, conn))
//                        {
//                            countsCmd.Parameters.AddWithValue("@UserID", userID);
//                            using (SqlDataReader reader = countsCmd.ExecuteReader())
//                            {
//                                int todayInterests = 0;
//                                int todayMessages = 0;

//                                if (reader.Read())
//                                {
//                                    todayInterests = reader.GetInt32(0);
//                                    todayMessages = reader.GetInt32(1);
//                                }

//                                int remainingInterests = Math.Max(0, 5 - todayInterests); // 5 daily limit for interests
//                                int remainingMessages = Math.Max(0, 3 - todayMessages); // 3 daily limit for messages

//                                return $"{remainingMessages},{remainingInterests}";
//                            }
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("GetRemainingCounts error: " + ex.Message);
//                return "0,0";
//            }
//        }
//    }
//}

