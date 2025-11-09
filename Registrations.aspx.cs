






using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JivanBandhan4
{
    public partial class Registrations : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // All data is now handled through dropdowns in frontend
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    // Check if email already exists
                    if (IsEmailExists(txtEmail.Text))
                    {
                        ShowError("This email is already registered");
                        return;
                    }

                    // Validate passwords match
                    if (txtPassword.Text != txtConfirmPassword.Text)
                    {
                        ShowError("Passwords do not match");
                        return;
                    }

                    // Save user data
                    int userID = SaveUserData();

                    if (userID > 0)
                    {
                        // Save photos
                        SavePhotos(userID);

                        // Show celebration
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "showCelebration", "showCelebration();", true);

                        // Clear form
                        ClearForm();
                    }
                }
                catch (Exception ex)
                {
                    ShowError("Error occurred: " + ex.Message);
                }
            }
        }

        private int SaveUserData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO Users (
                    Email, Password, ProfileCreatedFor, FullName, Gender, DateOfBirth, Height, 
                    Weight, BloodGroup, PhysicalStatus, Religion, Caste, SubCaste, Gothra, 
                    Manglik, MotherTongue, MaritalStatus, EatingHabits, DrinkingHabits, SmokingHabits,
                    Education, EducationField, College, Occupation, OccupationField, Company, 
                    AnnualIncome, WorkingLocation, Country, State, District, City, Phone, 
                    FamilyType, FamilyStatus, FatherOccupation, MotherOccupation, NoOfBrothers, 
                    NoOfSisters, NativePlace, FamilyDetails, AboutMe, Hobbies, PartnerExpectations,
                    CreatedDate
                ) VALUES (
                    @Email, @Password, @ProfileCreatedFor, @FullName, @Gender, @DateOfBirth, @Height,
                    @Weight, @BloodGroup, @PhysicalStatus, @Religion, @Caste, @SubCaste, @Gothra,
                    @Manglik, @MotherTongue, @MaritalStatus, @EatingHabits, @DrinkingHabits, @SmokingHabits,
                    @Education, @EducationField, @College, @Occupation, @OccupationField, @Company,
                    @AnnualIncome, @WorkingLocation, @Country, @State, @District, @City, @Phone,
                    @FamilyType, @FamilyStatus, @FatherOccupation, @MotherOccupation, @NoOfBrothers,
                    @NoOfSisters, @NativePlace, @FamilyDetails, @AboutMe, @Hobbies, @PartnerExpectations,
                    GETDATE()
                ); SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    // Basic Information
                    cmd.Parameters.AddWithValue("@Email", GetSafeString(txtEmail.Text));
                    // SIMPLE PASSWORD - NO HASHING
                    cmd.Parameters.AddWithValue("@Password", GetSafeString(txtPassword.Text));
                    cmd.Parameters.AddWithValue("@ProfileCreatedFor", GetSafeString(ddlProfileFor.SelectedValue));
                    cmd.Parameters.AddWithValue("@FullName", GetSafeString(txtFullName.Text));
                    cmd.Parameters.AddWithValue("@Gender", GetSafeString(ddlGender.SelectedValue));
                    cmd.Parameters.AddWithValue("@DateOfBirth", GetSafeDateTime(txtDOB.Text));
                    cmd.Parameters.AddWithValue("@Height", GetSafeString(ddlHeight.SelectedValue));
                    cmd.Parameters.AddWithValue("@Weight", GetSafeString(ddlWeight.SelectedValue));
                    cmd.Parameters.AddWithValue("@BloodGroup", GetSafeString(ddlBloodGroup.SelectedValue));
                    cmd.Parameters.AddWithValue("@PhysicalStatus", GetSafeString(ddlPhysicalStatus.SelectedValue));

                    // Religious Information
                    cmd.Parameters.AddWithValue("@Religion", GetSafeString(ddlReligion.SelectedValue));
                    cmd.Parameters.AddWithValue("@Caste", GetSafeString(ddlCaste.SelectedValue));
                    cmd.Parameters.AddWithValue("@SubCaste", GetSafeString(ddlSubCaste.SelectedValue));
                    cmd.Parameters.AddWithValue("@Gothra", GetSafeString(ddlGothra.SelectedValue));
                    cmd.Parameters.AddWithValue("@Manglik", GetSafeString(ddlManglik.SelectedValue));
                    cmd.Parameters.AddWithValue("@MotherTongue", GetSafeString(ddlMotherTongue.SelectedValue));

                    // Personal Information
                    cmd.Parameters.AddWithValue("@MaritalStatus", GetSafeString(ddlMaritalStatus.SelectedValue));
                    cmd.Parameters.AddWithValue("@EatingHabits", GetSafeString(ddlEatingHabits.SelectedValue));
                    cmd.Parameters.AddWithValue("@DrinkingHabits", GetSafeString(ddlDrinkingHabits.SelectedValue));
                    cmd.Parameters.AddWithValue("@SmokingHabits", GetSafeString(ddlSmokingHabits.SelectedValue));

                    // Education & Career
                    cmd.Parameters.AddWithValue("@Education", GetSafeString(ddlEducation.SelectedValue));
                    cmd.Parameters.AddWithValue("@EducationField", GetSafeString(ddlEducationField.SelectedValue));
                    cmd.Parameters.AddWithValue("@College", GetSafeString(ddlCollege.SelectedValue));
                    cmd.Parameters.AddWithValue("@Occupation", GetSafeString(ddlOccupation.SelectedValue));
                    cmd.Parameters.AddWithValue("@OccupationField", GetSafeString(ddlOccupationField.SelectedValue));
                    cmd.Parameters.AddWithValue("@Company", GetSafeString(ddlCompany.SelectedValue));
                    cmd.Parameters.AddWithValue("@AnnualIncome", GetSafeDecimal(ddlIncome.SelectedValue));
                    cmd.Parameters.AddWithValue("@WorkingLocation", GetSafeString(ddlWorkingLocation.SelectedValue));

                    // Location
                    cmd.Parameters.AddWithValue("@Country", "India");
                    cmd.Parameters.AddWithValue("@State", GetSafeString(ddlState.SelectedValue));
                    cmd.Parameters.AddWithValue("@District", GetSafeString(ddlDistrict.SelectedValue));
                    cmd.Parameters.AddWithValue("@City", GetSafeString(ddlCity.SelectedValue));
                    cmd.Parameters.AddWithValue("@Phone", GetSafeString(txtPhone.Text));

                    // Family Information
                    cmd.Parameters.AddWithValue("@FamilyType", GetSafeString(ddlFamilyType.SelectedValue));
                    cmd.Parameters.AddWithValue("@FamilyStatus", GetSafeString(ddlFamilyStatus.SelectedValue));
                    cmd.Parameters.AddWithValue("@FatherOccupation", GetSafeString(ddlFatherOccupation.SelectedValue));
                    cmd.Parameters.AddWithValue("@MotherOccupation", GetSafeString(ddlMotherOccupation.SelectedValue));
                    cmd.Parameters.AddWithValue("@NoOfBrothers", GetSafeInt(ddlNoOfBrothers.SelectedValue));
                    cmd.Parameters.AddWithValue("@NoOfSisters", GetSafeInt(ddlNoOfSisters.SelectedValue));
                    cmd.Parameters.AddWithValue("@NativePlace", GetSafeString(ddlNativePlace.SelectedValue));
                    cmd.Parameters.AddWithValue("@FamilyDetails", GetSafeString(txtFamilyDetails.Text));

                    // Partner Expectations
                    cmd.Parameters.AddWithValue("@PartnerExpectations", GetSafeString(txtPartnerExpectations.Text));

                    // Additional Information
                    cmd.Parameters.AddWithValue("@AboutMe", GetSafeString(txtAboutMe.Text));
                    cmd.Parameters.AddWithValue("@Hobbies", GetSafeString(txtHobbies.Text));

                    conn.Open();
                    int userID = Convert.ToInt32(cmd.ExecuteScalar());
                    return userID;
                }
            }
        }

        private void SavePhotos(int userID)
        {
            try
            {
                // Save profile photo
                if (fuProfilePhoto.HasFile)
                {
                    string profilePhotoPath = SaveUploadedFile(fuProfilePhoto.PostedFile, userID, "Profile");
                    if (!string.IsNullOrEmpty(profilePhotoPath))
                    {
                        SavePhotoToDatabase(userID, profilePhotoPath, "Profile");
                    }
                }

                // Save additional photos
                if (fuAdditionalPhotos.HasFiles)
                {
                    int photoCount = 0;
                    foreach (HttpPostedFile file in fuAdditionalPhotos.PostedFiles)
                    {
                        if (photoCount >= 5) break; // Maximum 5 photos

                        if (file != null && file.ContentLength > 0)
                        {
                            string additionalPhotoPath = SaveUploadedFile(file, userID, "Additional");
                            if (!string.IsNullOrEmpty(additionalPhotoPath))
                            {
                                SavePhotoToDatabase(userID, additionalPhotoPath, "Additional");
                                photoCount++;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log photo error but don't stop registration
                System.Diagnostics.Debug.WriteLine("Photo save error: " + ex.Message);
            }
        }

        private string SaveUploadedFile(HttpPostedFile file, int userID, string photoType)
        {
            string fileName = Path.GetFileName(file.FileName);
            string extension = Path.GetExtension(fileName).ToLower();

            // Validate file type
            if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
            {
                throw new Exception("Only JPG, JPEG and PNG files are allowed");
            }

            // Validate file size (5MB)
            if (file.ContentLength > 5242880)
            {
                throw new Exception("File size should be less than 5MB");
            }

            // Create user directory
            string uploadsFolder = Server.MapPath("~/Uploads/");
            if (!Directory.Exists(uploadsFolder))
            {
                Directory.CreateDirectory(uploadsFolder);
            }

            string userFolder = Path.Combine(uploadsFolder, userID.ToString());
            if (!Directory.Exists(userFolder))
            {
                Directory.CreateDirectory(userFolder);
            }

            // Generate unique file name
            string newFileName = $"{photoType}_{Guid.NewGuid().ToString()}{extension}";
            string filePath = Path.Combine(userFolder, newFileName);
            file.SaveAs(filePath);

            return newFileName;
        }

        private void SavePhotoToDatabase(int userID, string photoPath, string photoType)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO UserPhotos (UserID, PhotoPath, PhotoType, UploadDate) 
                                VALUES (@UserID, @PhotoPath, @PhotoType, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    cmd.Parameters.AddWithValue("@PhotoPath", photoPath);
                    cmd.Parameters.AddWithValue("@PhotoType", photoType);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private bool IsEmailExists(string email)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

                    conn.Open();
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        // Helper methods for safe data conversion
        private string GetSafeString(string value)
        {
            return string.IsNullOrEmpty(value) ? string.Empty : value;
        }

        private DateTime GetSafeDateTime(string value)
        {
            if (string.IsNullOrEmpty(value))
                return DateTime.MinValue;

            DateTime result;
            return DateTime.TryParse(value, out result) ? result : DateTime.MinValue;
        }

        private decimal GetSafeDecimal(string value)
        {
            if (string.IsNullOrEmpty(value))
                return 0;

            decimal result;
            return decimal.TryParse(value, out result) ? result : 0;
        }

        private int GetSafeInt(string value)
        {
            if (string.IsNullOrEmpty(value))
                return 0;

            int result;
            return int.TryParse(value, out result) ? result : 0;
        }

        // REMOVED HASH PASSWORD FUNCTION - Now using plain text

        private void ClearForm()
        {
            try
            {
                // Clear all form fields
                txtEmail.Text = "";
                txtPassword.Text = "";
                txtConfirmPassword.Text = "";
                txtFullName.Text = "";
                txtDOB.Text = "";
                txtPhone.Text = "";
                txtFamilyDetails.Text = "";
                txtPartnerExpectations.Text = "";
                txtAboutMe.Text = "";
                txtHobbies.Text = "";

                // Reset dropdowns
                ddlProfileFor.ClearSelection();
                ddlGender.ClearSelection();
                ddlHeight.ClearSelection();
                ddlWeight.ClearSelection();
                ddlBloodGroup.ClearSelection();
                ddlPhysicalStatus.ClearSelection();
                ddlReligion.ClearSelection();
                ddlCaste.ClearSelection();
                ddlSubCaste.ClearSelection();
                ddlGothra.ClearSelection();
                ddlManglik.ClearSelection();
                ddlMotherTongue.ClearSelection();
                ddlMaritalStatus.ClearSelection();
                ddlEatingHabits.ClearSelection();
                ddlDrinkingHabits.ClearSelection();
                ddlSmokingHabits.ClearSelection();
                ddlEducation.ClearSelection();
                ddlEducationField.ClearSelection();
                ddlCollege.ClearSelection();
                ddlOccupation.ClearSelection();
                ddlOccupationField.ClearSelection();
                ddlCompany.ClearSelection();
                ddlIncome.ClearSelection();
                ddlWorkingLocation.ClearSelection();
                ddlState.ClearSelection();
                ddlDistrict.ClearSelection();
                ddlCity.ClearSelection();
                ddlFamilyType.ClearSelection();
                ddlFamilyStatus.ClearSelection();
                ddlFatherOccupation.ClearSelection();
                ddlMotherOccupation.ClearSelection();
                ddlNoOfBrothers.ClearSelection();
                ddlNoOfSisters.ClearSelection();
                ddlNativePlace.ClearSelection();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Clear form error: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showError",
                $"alert('{message}');", true);
        }

        private void ShowSuccess(string message)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showSuccess",
                $"alert('{message}');", true);
        }
    }
}






















//using System;
//using System.Data;
//using System.Data.SqlClient;
//using System.IO;
//using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;

//namespace JivanBandhan4
//{
//    public partial class Registrations : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                // All data is now handled through dropdowns in frontend
//            }
//        }

//        protected void btnSubmit_Click(object sender, EventArgs e)
//        {
//            if (Page.IsValid)
//            {
//                try
//                {
//                    // Check if email already exists
//                    if (IsEmailExists(txtEmail.Text))
//                    {
//                        ShowError("This email is already registered");
//                        return;
//                    }

//                    // Validate passwords match
//                    if (txtPassword.Text != txtConfirmPassword.Text)
//                    {
//                        ShowError("Passwords do not match");
//                        return;
//                    }

//                    // Save user data
//                    int userID = SaveUserData();

//                    if (userID > 0)
//                    {
//                        // Save photos
//                        SavePhotos(userID);

//                        // Show celebration
//                        ScriptManager.RegisterStartupScript(this, this.GetType(), "showCelebration", "showCelebration();", true);

//                        // Clear form
//                        ClearForm();
//                    }
//                }
//                catch (Exception ex)
//                {
//                    ShowError("Error occurred: " + ex.Message);
//                }
//            }
//        }

//        private int SaveUserData()
//        {
//            using (SqlConnection conn = new SqlConnection(connectionString))
//            {
//                string query = @"INSERT INTO Users (
//                    Email, Password, ProfileCreatedFor, FullName, Gender, DateOfBirth, Height, 
//                    Weight, BloodGroup, PhysicalStatus, Religion, Caste, SubCaste, Gothra, 
//                    Manglik, MotherTongue, MaritalStatus, EatingHabits, DrinkingHabits, SmokingHabits,
//                    Education, EducationField, College, Occupation, OccupationField, Company, 
//                    AnnualIncome, WorkingLocation, Country, State, District, City, Phone, 
//                    FamilyType, FamilyStatus, FatherOccupation, MotherOccupation, NoOfBrothers, 
//                    NoOfSisters, NativePlace, FamilyDetails, AboutMe, Hobbies, PartnerExpectations,
//                    CreatedDate
//                ) VALUES (
//                    @Email, @Password, @ProfileCreatedFor, @FullName, @Gender, @DateOfBirth, @Height,
//                    @Weight, @BloodGroup, @PhysicalStatus, @Religion, @Caste, @SubCaste, @Gothra,
//                    @Manglik, @MotherTongue, @MaritalStatus, @EatingHabits, @DrinkingHabits, @SmokingHabits,
//                    @Education, @EducationField, @College, @Occupation, @OccupationField, @Company,
//                    @AnnualIncome, @WorkingLocation, @Country, @State, @District, @City, @Phone,
//                    @FamilyType, @FamilyStatus, @FatherOccupation, @MotherOccupation, @NoOfBrothers,
//                    @NoOfSisters, @NativePlace, @FamilyDetails, @AboutMe, @Hobbies, @PartnerExpectations,
//                    GETDATE()
//                ); SELECT SCOPE_IDENTITY();";

//                using (SqlCommand cmd = new SqlCommand(query, conn))
//                {
//                    // Basic Information
//                    cmd.Parameters.AddWithValue("@Email", GetSafeString(txtEmail.Text));
//                    // SIMPLE PASSWORD - NO HASHING
//                    cmd.Parameters.AddWithValue("@Password", GetSafeString(txtPassword.Text));
//                    cmd.Parameters.AddWithValue("@ProfileCreatedFor", GetSafeString(ddlProfileFor.SelectedValue));
//                    cmd.Parameters.AddWithValue("@FullName", GetSafeString(txtFullName.Text));
//                    cmd.Parameters.AddWithValue("@Gender", GetSafeString(ddlGender.SelectedValue));
//                    cmd.Parameters.AddWithValue("@DateOfBirth", GetSafeDateTime(txtDOB.Text));
//                    cmd.Parameters.AddWithValue("@Height", GetSafeString(ddlHeight.SelectedValue));
//                    cmd.Parameters.AddWithValue("@Weight", GetSafeString(ddlWeight.SelectedValue));
//                    cmd.Parameters.AddWithValue("@BloodGroup", GetSafeString(ddlBloodGroup.SelectedValue));
//                    cmd.Parameters.AddWithValue("@PhysicalStatus", GetSafeString(ddlPhysicalStatus.SelectedValue));

//                    // Religious Information
//                    cmd.Parameters.AddWithValue("@Religion", GetSafeString(ddlReligion.SelectedValue));
//                    cmd.Parameters.AddWithValue("@Caste", GetSafeString(ddlCaste.SelectedValue));
//                    cmd.Parameters.AddWithValue("@SubCaste", GetSafeString(ddlSubCaste.SelectedValue));
//                    cmd.Parameters.AddWithValue("@Gothra", GetSafeString(ddlGothra.SelectedValue));
//                    cmd.Parameters.AddWithValue("@Manglik", GetSafeString(ddlManglik.SelectedValue));
//                    cmd.Parameters.AddWithValue("@MotherTongue", GetSafeString(ddlMotherTongue.SelectedValue));

//                    // Personal Information
//                    cmd.Parameters.AddWithValue("@MaritalStatus", GetSafeString(ddlMaritalStatus.SelectedValue));
//                    cmd.Parameters.AddWithValue("@EatingHabits", GetSafeString(ddlEatingHabits.SelectedValue));
//                    cmd.Parameters.AddWithValue("@DrinkingHabits", GetSafeString(ddlDrinkingHabits.SelectedValue));
//                    cmd.Parameters.AddWithValue("@SmokingHabits", GetSafeString(ddlSmokingHabits.SelectedValue));

//                    // Education & Career
//                    cmd.Parameters.AddWithValue("@Education", GetSafeString(ddlEducation.SelectedValue));
//                    cmd.Parameters.AddWithValue("@EducationField", GetSafeString(ddlEducationField.SelectedValue));
//                    cmd.Parameters.AddWithValue("@College", GetSafeString(ddlCollege.SelectedValue));
//                    cmd.Parameters.AddWithValue("@Occupation", GetSafeString(ddlOccupation.SelectedValue));
//                    cmd.Parameters.AddWithValue("@OccupationField", GetSafeString(ddlOccupationField.SelectedValue));
//                    cmd.Parameters.AddWithValue("@Company", GetSafeString(ddlCompany.SelectedValue));
//                    cmd.Parameters.AddWithValue("@AnnualIncome", GetSafeDecimal(ddlIncome.SelectedValue));
//                    cmd.Parameters.AddWithValue("@WorkingLocation", GetSafeString(ddlWorkingLocation.SelectedValue));

//                    // Location
//                    cmd.Parameters.AddWithValue("@Country", "India");
//                    cmd.Parameters.AddWithValue("@State", GetSafeString(ddlState.SelectedValue));
//                    cmd.Parameters.AddWithValue("@District", GetSafeString(ddlDistrict.SelectedValue));
//                    cmd.Parameters.AddWithValue("@City", GetSafeString(ddlCity.SelectedValue));
//                    cmd.Parameters.AddWithValue("@Phone", GetSafeString(txtPhone.Text));

//                    // Family Information
//                    cmd.Parameters.AddWithValue("@FamilyType", GetSafeString(ddlFamilyType.SelectedValue));
//                    cmd.Parameters.AddWithValue("@FamilyStatus", GetSafeString(ddlFamilyStatus.SelectedValue));
//                    cmd.Parameters.AddWithValue("@FatherOccupation", GetSafeString(ddlFatherOccupation.SelectedValue));
//                    cmd.Parameters.AddWithValue("@MotherOccupation", GetSafeString(ddlMotherOccupation.SelectedValue));
//                    cmd.Parameters.AddWithValue("@NoOfBrothers", GetSafeInt(ddlNoOfBrothers.SelectedValue));
//                    cmd.Parameters.AddWithValue("@NoOfSisters", GetSafeInt(ddlNoOfSisters.SelectedValue));
//                    cmd.Parameters.AddWithValue("@NativePlace", GetSafeString(ddlNativePlace.SelectedValue));
//                    cmd.Parameters.AddWithValue("@FamilyDetails", GetSafeString(txtFamilyDetails.Text));

//                    // Partner Expectations
//                    cmd.Parameters.AddWithValue("@PartnerExpectations", GetSafeString(txtPartnerExpectations.Text));

//                    // Additional Information
//                    cmd.Parameters.AddWithValue("@AboutMe", GetSafeString(txtAboutMe.Text));
//                    cmd.Parameters.AddWithValue("@Hobbies", GetSafeString(txtHobbies.Text));

//                    conn.Open();
//                    int userID = Convert.ToInt32(cmd.ExecuteScalar());
//                    return userID;
//                }
//            }
//        }

//        private void SavePhotos(int userID)
//        {
//            try
//            {
//                // Save profile photo
//                if (fuProfilePhoto.HasFile)
//                {
//                    string profilePhotoPath = SaveUploadedFile(fuProfilePhoto.PostedFile, userID, "Profile");
//                    if (!string.IsNullOrEmpty(profilePhotoPath))
//                    {
//                        SavePhotoToDatabase(userID, profilePhotoPath, "Profile");
//                    }
//                }

//                // Save additional photos
//                if (fuAdditionalPhotos.HasFiles)
//                {
//                    int photoCount = 0;
//                    foreach (HttpPostedFile file in fuAdditionalPhotos.PostedFiles)
//                    {
//                        if (photoCount >= 5) break; // Maximum 5 photos

//                        if (file != null && file.ContentLength > 0)
//                        {
//                            string additionalPhotoPath = SaveUploadedFile(file, userID, "Additional");
//                            if (!string.IsNullOrEmpty(additionalPhotoPath))
//                            {
//                                SavePhotoToDatabase(userID, additionalPhotoPath, "Additional");
//                                photoCount++;
//                            }
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log photo error but don't stop registration
//                System.Diagnostics.Debug.WriteLine("Photo save error: " + ex.Message);
//            }
//        }

//        private string SaveUploadedFile(HttpPostedFile file, int userID, string photoType)
//        {
//            string fileName = Path.GetFileName(file.FileName);
//            string extension = Path.GetExtension(fileName).ToLower();

//            // Validate file type
//            if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
//            {
//                throw new Exception("Only JPG, JPEG and PNG files are allowed");
//            }

//            // Validate file size (5MB)
//            if (file.ContentLength > 5242880)
//            {
//                throw new Exception("File size should be less than 5MB");
//            }

//            // Create user directory
//            string uploadsFolder = Server.MapPath("~/Uploads/");
//            if (!Directory.Exists(uploadsFolder))
//            {
//                Directory.CreateDirectory(uploadsFolder);
//            }

//            string userFolder = Path.Combine(uploadsFolder, userID.ToString());
//            if (!Directory.Exists(userFolder))
//            {
//                Directory.CreateDirectory(userFolder);
//            }

//            // Generate unique file name
//            string newFileName = $"{photoType}_{Guid.NewGuid().ToString()}{extension}";
//            string filePath = Path.Combine(userFolder, newFileName);
//            file.SaveAs(filePath);

//            return newFileName;
//        }

//        private void SavePhotoToDatabase(int userID, string photoPath, string photoType)
//        {
//            using (SqlConnection conn = new SqlConnection(connectionString))
//            {
//                string query = @"INSERT INTO UserPhotos (UserID, PhotoPath, PhotoType, UploadDate) 
//                                VALUES (@UserID, @PhotoPath, @PhotoType, GETDATE())";

//                using (SqlCommand cmd = new SqlCommand(query, conn))
//                {
//                    cmd.Parameters.AddWithValue("@UserID", userID);
//                    cmd.Parameters.AddWithValue("@PhotoPath", photoPath);
//                    cmd.Parameters.AddWithValue("@PhotoType", photoType);

//                    conn.Open();
//                    cmd.ExecuteNonQuery();
//                }
//            }
//        }

//        private bool IsEmailExists(string email)
//        {
//            using (SqlConnection conn = new SqlConnection(connectionString))
//            {
//                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";

//                using (SqlCommand cmd = new SqlCommand(query, conn))
//                {
//                    cmd.Parameters.AddWithValue("@Email", email);

//                    conn.Open();
//                    int count = Convert.ToInt32(cmd.ExecuteScalar());
//                    return count > 0;
//                }
//            }
//        }

//        // Helper methods for safe data conversion
//        private string GetSafeString(string value)
//        {
//            return string.IsNullOrEmpty(value) ? string.Empty : value;
//        }

//        private DateTime GetSafeDateTime(string value)
//        {
//            if (string.IsNullOrEmpty(value))
//                return DateTime.MinValue;

//            DateTime result;
//            return DateTime.TryParse(value, out result) ? result : DateTime.MinValue;
//        }

//        private decimal GetSafeDecimal(string value)
//        {
//            if (string.IsNullOrEmpty(value))
//                return 0;

//            decimal result;
//            return decimal.TryParse(value, out result) ? result : 0;
//        }

//        private int GetSafeInt(string value)
//        {
//            if (string.IsNullOrEmpty(value))
//                return 0;

//            int result;
//            return int.TryParse(value, out result) ? result : 0;
//        }

//        // REMOVED HASH PASSWORD FUNCTION - Now using plain text

//        private void ClearForm()
//        {
//            try
//            {
//                // Clear all form fields
//                txtEmail.Text = "";
//                txtPassword.Text = "";
//                txtConfirmPassword.Text = "";
//                txtFullName.Text = "";
//                txtDOB.Text = "";
//                txtPhone.Text = "";
//                txtFamilyDetails.Text = "";
//                txtPartnerExpectations.Text = "";
//                txtAboutMe.Text = "";
//                txtHobbies.Text = "";

//                // Reset dropdowns
//                ddlProfileFor.ClearSelection();
//                ddlGender.ClearSelection();
//                ddlHeight.ClearSelection();
//                ddlWeight.ClearSelection();
//                ddlBloodGroup.ClearSelection();
//                ddlPhysicalStatus.ClearSelection();
//                ddlReligion.ClearSelection();
//                ddlCaste.ClearSelection();
//                ddlSubCaste.ClearSelection();
//                ddlGothra.ClearSelection();
//                ddlManglik.ClearSelection();
//                ddlMotherTongue.ClearSelection();
//                ddlMaritalStatus.ClearSelection();
//                ddlEatingHabits.ClearSelection();
//                ddlDrinkingHabits.ClearSelection();
//                ddlSmokingHabits.ClearSelection();
//                ddlEducation.ClearSelection();
//                ddlEducationField.ClearSelection();
//                ddlCollege.ClearSelection();
//                ddlOccupation.ClearSelection();
//                ddlOccupationField.ClearSelection();
//                ddlCompany.ClearSelection();
//                ddlIncome.ClearSelection();
//                ddlWorkingLocation.ClearSelection();
//                ddlState.ClearSelection();
//                ddlDistrict.ClearSelection();
//                ddlCity.ClearSelection();
//                ddlFamilyType.ClearSelection();
//                ddlFamilyStatus.ClearSelection();
//                ddlFatherOccupation.ClearSelection();
//                ddlMotherOccupation.ClearSelection();
//                ddlNoOfBrothers.ClearSelection();
//                ddlNoOfSisters.ClearSelection();
//                ddlNativePlace.ClearSelection();
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Clear form error: " + ex.Message);
//            }
//        }

//        private void ShowError(string message)
//        {
//            ScriptManager.RegisterStartupScript(this, this.GetType(), "showError",
//                $"alert('{message}');", true);
//        }

//        private void ShowSuccess(string message)
//        {
//            ScriptManager.RegisterStartupScript(this, this.GetType(), "showSuccess",
//                $"alert('{message}');", true);
//        }
//    }
//}































