using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

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
                        CheckPlatinumMembershipAndShowContact(Convert.ToInt32(Session["UserID"]), viewedUserID);
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
                            lblFlipName.Text = reader["FullName"].ToString();

                            // Age
                            if (reader["Age"] != DBNull.Value)
                            {
                                lblAge.Text = reader["Age"].ToString();
                                lblFlipAge.Text = reader["Age"].ToString();
                            }
                            else
                            {
                                lblAge.Text = "Not specified";
                                lblFlipAge.Text = "Not specified";
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
                            string country = reader["Country"] != DBNull.Value ? reader["Country"].ToString() : "";
                            lblLocation.Text = !string.IsNullOrEmpty(city) ? $"{city}, {state}" : "Not specified";
                            lblFlipLocation.Text = lblLocation.Text;

                            // Occupation and Education
                            lblOccupation.Text = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
                            lblCareerOccupation.Text = lblOccupation.Text;
                            lblFlipOccupation.Text = lblOccupation.Text;
                            lblEducation.Text = reader["Education"] != DBNull.Value ? reader["Education"].ToString() : "Not specified";
                            lblHighestEducation.Text = lblEducation.Text;

                            // Phone Number - Directly from database
                            lblPhone.Text = reader["Phone"] != DBNull.Value ? reader["Phone"].ToString() : "Not specified";

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
                            hdnUserPhotos.Value = JsonConvert.SerializeObject(photos);

                            // Generate HTML for photo gallery
                            StringBuilder galleryHtml = new StringBuilder();
                            for (int i = 0; i < photos.Count; i++)
                            {
                                galleryHtml.Append($@"
                                    <div class='gallery-item'>
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

        private void CheckPlatinumMembershipAndShowContact(int currentUserID, int viewedUserID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Get current user's membership
                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
                                             FROM UserMemberships 
                                             WHERE UserID = @CurrentUserID AND ExpiryDate > GETDATE()";

                    string currentUserMembership = "Free";
                    using (SqlCommand membershipCmd = new SqlCommand(membershipQuery, conn))
                    {
                        membershipCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                        object result = membershipCmd.ExecuteScalar();
                        if (result != null)
                        {
                            currentUserMembership = result.ToString();
                        }
                    }

                    // Check if current user has PLATINUM membership - ONLY PLATINUM
                    bool canViewContact = currentUserMembership.Equals("Platinum", StringComparison.OrdinalIgnoreCase);

                    if (canViewContact)
                    {
                        // Get viewed user's contact number
                        string contactQuery = "SELECT Phone FROM Users WHERE UserID = @ViewedUserID";
                        using (SqlCommand contactCmd = new SqlCommand(contactQuery, conn))
                        {
                            contactCmd.Parameters.AddWithValue("@ViewedUserID", viewedUserID);
                            object contactResult = contactCmd.ExecuteScalar();

                            if (contactResult != null && contactResult != DBNull.Value && !string.IsNullOrEmpty(contactResult.ToString()))
                            {
                                string contactNumber = contactResult.ToString();

                                // Show platinum badge and contact number panel
                                pnlPlatinumBadge.Visible = true;
                                pnlContactNumber.Visible = true;
                                lblContactNumber.Text = contactNumber;

                                // Show in basic info panel as well
                                pnlPhoneBasicInfo.Visible = true;
                                lblPhone.Text = contactNumber;

                                // Hide other panels
                                pnlContactRestricted.Visible = false;
                                pnlPlatinumInfo.Visible = false;
                            }
                            else
                            {
                                pnlContactNumber.Visible = false;
                                pnlContactRestricted.Visible = true;
                                pnlContactRestricted.Controls.Clear();
                                pnlContactRestricted.Controls.Add(new LiteralControl("<i class='fas fa-info-circle'></i> Contact number not available"));
                            }
                        }
                    }
                    else
                    {
                        // Not a PLATINUM member
                        pnlPlatinumBadge.Visible = false;
                        pnlContactNumber.Visible = false;
                        pnlPlatinumInfo.Visible = true;
                        pnlContactRestricted.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CheckPlatinumMembershipAndShowContact error: " + ex.Message);
                // Don't show contact number panels if there's an error
                pnlPlatinumBadge.Visible = false;
                pnlContactNumber.Visible = false;
                pnlPlatinumInfo.Visible = true;
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
//using System.Collections.Generic;
//using System.Data;
//using System.Data.SqlClient;
//using System.Text;
//using System.Web.Services;
//using System.Web.UI;
//using System.Web.UI.HtmlControls;
//using System.Web.UI.WebControls;

//namespace JivanBandhan4
//{
//    public partial class ViewUserProfile : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        // Add these protected declarations to match the aspx page
//        protected global::System.Web.UI.WebControls.HiddenField hdnViewedUserGender;
//        protected global::System.Web.UI.WebControls.HiddenField hdnCurrentUserGender;

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                if (Session["UserID"] != null)
//                {
//                    hdnCurrentUserID.Value = Session["UserID"].ToString();

//                    if (Request.QueryString["UserID"] != null)
//                    {
//                        int viewedUserID = Convert.ToInt32(Request.QueryString["UserID"]);
//                        hdnViewedUserID.Value = viewedUserID.ToString();
//                        LoadUserProfile(viewedUserID);
//                        LoadUserPhotos(viewedUserID);
//                        UpdateProfileViewCount(viewedUserID);
//                        CheckUserActions(Convert.ToInt32(Session["UserID"]), viewedUserID);
//                        CheckPlatinumMembershipAndShowContact(Convert.ToInt32(Session["UserID"]), viewedUserID);
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
//                                    DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age
//                                FROM Users u
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

//                            // Store viewed user's gender in hidden field
//                            if (hdnViewedUserGender != null)
//                            {
//                                hdnViewedUserGender.Value = reader["Gender"] != DBNull.Value ? reader["Gender"].ToString() : "";
//                            }

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

//                            // Phone Number - Directly from database
//                            lblPhone.Text = reader["Phone"] != DBNull.Value ? reader["Phone"].ToString() : "Not specified";

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
//                            lblPersonalMaritalStatus.Text = lblMaritalStatus.Text;

//                            // Religious details
//                            lblSubCaste.Text = reader["SubCaste"] != DBNull.Value ? reader["SubCaste"].ToString() : "Not specified";
//                            lblManglik.Text = reader["Manglik"] != DBNull.Value ? reader["Manglik"].ToString() : "Not specified";

//                            // Education details
//                            lblEducationField.Text = reader["EducationField"] != DBNull.Value ? reader["EducationField"].ToString() : "Not specified";
//                            lblCollege.Text = reader["College"] != DBNull.Value ? reader["College"].ToString() : "Not specified";

//                            // Career details
//                            lblOccupationField.Text = reader["OccupationField"] != DBNull.Value ? reader["OccupationField"].ToString() : "Not specified";
//                            lblAnnualIncome.Text = reader["AnnualIncome"] != DBNull.Value ? reader["AnnualIncome"].ToString() : "Not specified";

//                            // Family information
//                            lblFamilyType.Text = reader["FamilyType"] != DBNull.Value ? reader["FamilyType"].ToString() : "Not specified";
//                            lblFatherOccupation.Text = reader["FatherOccupation"] != DBNull.Value ? reader["FatherOccupation"].ToString() : "Not specified";
//                            lblMotherOccupation.Text = reader["MotherOccupation"] != DBNull.Value ? reader["MotherOccupation"].ToString() : "Not specified";

//                            // Load profile photo
//                            LoadProfilePhoto(userID, imgProfileLarge);

//                            // Set flip photo data
//                            SetFlipPhotoData();
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

//        private void CheckPlatinumMembershipAndShowContact(int currentUserID, int viewedUserID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Get current user's membership
//                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
//                                             FROM UserMemberships 
//                                             WHERE UserID = @CurrentUserID AND ExpiryDate > GETDATE()";

//                    string currentUserMembership = "Free";
//                    using (SqlCommand membershipCmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        membershipCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
//                        object result = membershipCmd.ExecuteScalar();
//                        if (result != null)
//                        {
//                            currentUserMembership = result.ToString();
//                        }
//                    }

//                    // Check if current user has PLATINUM membership - ONLY PLATINUM
//                    bool canViewContact = currentUserMembership == "Platinum";

//                    if (canViewContact)
//                    {
//                        // Get viewed user's contact number
//                        string contactQuery = "SELECT Phone FROM Users WHERE UserID = @ViewedUserID";
//                        using (SqlCommand contactCmd = new SqlCommand(contactQuery, conn))
//                        {
//                            contactCmd.Parameters.AddWithValue("@ViewedUserID", viewedUserID);
//                            object contactResult = contactCmd.ExecuteScalar();

//                            if (contactResult != null && contactResult != DBNull.Value && !string.IsNullOrEmpty(contactResult.ToString()))
//                            {
//                                string contactNumber = contactResult.ToString();

//                                // Show platinum badge and contact number panel
//                                pnlPlatinumBadge.Visible = true;
//                                pnlContactNumber.Visible = true;
//                                lblContactNumber.Text = contactNumber;

//                                // Hide other panels
//                                pnlContactRestricted.Visible = false;
//                                pnlPlatinumInfo.Visible = false;
//                            }
//                            else
//                            {
//                                pnlContactNumber.Visible = false;
//                                pnlContactRestricted.Visible = true;
//                                pnlContactRestricted.Controls.Clear();
//                                pnlContactRestricted.Controls.Add(new LiteralControl("<i class='fas fa-info-circle'></i> Contact number not available"));
//                            }
//                        }
//                    }
//                    else
//                    {
//                        // Not a PLATINUM member
//                        pnlPlatinumBadge.Visible = false;
//                        pnlContactNumber.Visible = false;
//                        pnlPlatinumInfo.Visible = true;
//                        pnlContactRestricted.Visible = false;
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CheckPlatinumMembershipAndShowContact error: " + ex.Message);
//                // Don't show contact number panels if there's an error
//                pnlPlatinumBadge.Visible = false;
//                pnlContactNumber.Visible = false;
//                pnlPlatinumInfo.Visible = true;
//            }
//        }

//        private void LoadUserPhotos(int userID)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT PhotoID, PhotoPath, PhotoType, UploadDate, IsProfilePhoto 
//                                   FROM UserPhotos 
//                                   WHERE UserID = @UserID AND IsActive = 1
//                                   ORDER BY 
//                                       CASE WHEN IsProfilePhoto = 1 THEN 0 ELSE 1 END,
//                                       UploadDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        List<PhotoData> photos = new List<PhotoData>();
//                        int photoCount = 0;

//                        while (reader.Read())
//                        {
//                            string photoPath = reader["PhotoPath"].ToString();
//                            string photoType = reader["PhotoType"].ToString();
//                            bool isProfilePhoto = Convert.ToBoolean(reader["IsProfilePhoto"]);

//                            if (!string.IsNullOrEmpty(photoPath))
//                            {
//                                string photoUrl = GetPhotoUrl(userID, photoPath);
//                                string photoTitle = isProfilePhoto ? "Profile Photo" : $"{photoType} Photo";

//                                photos.Add(new PhotoData
//                                {
//                                    Url = photoUrl,
//                                    Title = photoTitle,
//                                    IsProfilePhoto = isProfilePhoto
//                                });

//                                photoCount++;
//                            }
//                        }

//                        if (photos.Count > 0)
//                        {
//                            // Store photos in hidden field for JavaScript
//                            hdnUserPhotos.Value = Newtonsoft.Json.JsonConvert.SerializeObject(photos);

//                            // Generate HTML for photo gallery
//                            StringBuilder galleryHtml = new StringBuilder();
//                            for (int i = 0; i < photos.Count; i++)
//                            {
//                                galleryHtml.Append($@"
//                                    <div class='gallery-item' onclick='openModal({i})'>
//                                        <img src='{photos[i].Url}' alt='{photos[i].Title}' class='gallery-photo' 
//                                             onerror='this.src=""Images/default-profile.jpg""' />
//                                        <div class='photo-overlay'>
//                                            <div class='marathi-font'>{photos[i].Title}</div>
//                                        </div>
//                                    </div>");
//                            }

//                            photoGallery.InnerHtml = galleryHtml.ToString();
//                            pnlNoPhotos.Visible = false;
//                        }
//                        else
//                        {
//                            pnlNoPhotos.Visible = true;
//                            hdnUserPhotos.Value = "[]"; // Empty array for JavaScript
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadUserPhotos error: " + ex.Message);
//                pnlNoPhotos.Visible = true;
//                hdnUserPhotos.Value = "[]"; // Empty array for JavaScript
//            }
//        }

//        private string GetPhotoUrl(int userID, string photoPath)
//        {
//            try
//            {
//                // Check if photo exists in physical path
//                string physicalPath = Server.MapPath($"~/Uploads/{userID}/{photoPath}");
//                if (System.IO.File.Exists(physicalPath))
//                {
//                    return ResolveUrl($"~/Uploads/{userID}/{photoPath}");
//                }
//                else
//                {
//                    // If photo doesn't exist, return default image
//                    return ResolveUrl("~/Images/default-profile.jpg");
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("GetPhotoUrl error: " + ex.Message);
//                return ResolveUrl("~/Images/default-profile.jpg");
//            }
//        }

//        private void LoadProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // First try to get profile photo
//                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                   WHERE UserID = @UserID AND IsProfilePhoto = 1 AND IsActive = 1
//                                   ORDER BY UploadDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();

//                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
//                        {
//                            string photoPath = result.ToString();
//                            string photoUrl = GetPhotoUrl(userID, photoPath);
//                            imgControl.ImageUrl = photoUrl;
//                        }
//                        else
//                        {
//                            // If no profile photo, get any active photo
//                            query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
//                                     WHERE UserID = @UserID AND IsActive = 1
//                                     ORDER BY UploadDate DESC";

//                            using (SqlCommand cmd2 = new SqlCommand(query, conn))
//                            {
//                                cmd2.Parameters.AddWithValue("@UserID", userID);
//                                result = cmd2.ExecuteScalar();

//                                if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
//                                {
//                                    string photoPath = result.ToString();
//                                    string photoUrl = GetPhotoUrl(userID, photoPath);
//                                    imgControl.ImageUrl = photoUrl;
//                                }
//                                else
//                                {
//                                    imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
//                                }
//                            }
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

//        // Set data for flip photo back side
//        private void SetFlipPhotoData()
//        {
//            lblFlipName.Text = lblFullName.Text;
//            lblFlipAge.Text = lblAge.Text;
//            lblFlipLocation.Text = lblLocation.Text;
//            lblFlipOccupation.Text = lblOccupation.Text;
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
//        public static string BlockUser(int blockedByUserID, int blockedUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Check if already blocked
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

//                    // Insert new block
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
//                System.Diagnostics.Debug.WriteLine("BlockUser error: " + ex.Message);
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
//                System.Diagnostics.Debug.WriteLine("ReportUser error: " + ex.Message);
//                return "error";
//            }
//        }

//        // Photo data class for JSON serialization
//        public class PhotoData
//        {
//            public string Url { get; set; }
//            public string Title { get; set; }
//            public bool IsProfilePhoto { get; set; }
//        }
//    }
//}


