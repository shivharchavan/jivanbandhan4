using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;

namespace JivanBandhan4
{
    public partial class MyProfile : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    int userID = Convert.ToInt32(Session["UserID"]);
                    LoadUserProfile(userID);
                    LoadUserPhotos(userID);
                    CalculateProfileCompleteness(userID);
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
                    string query = @"SELECT * FROM Users WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            LoadProfileCard(reader);
                            LoadPersonalInfo(reader);
                            LoadProfessionalInfo(reader);
                            LoadAdditionalInfo(reader);
                            LoadProfilePhoto(userID);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading profile: " + ex.Message, false);
            }
        }

        private void LoadProfileCard(SqlDataReader reader)
        {
            // Basic Information
            ltFullName.Text = GetSafeString(reader["FullName"]);

            // Age and Occupation
            string ageOccupation = CalculateAgeAndOccupation(reader);
            ltAgeOccupation.Text = ageOccupation;

            // Location
            ltLocation.Text = GetLocation(reader);

            // Stats
            ltStatAge.Text = CalculateAge(reader).ToString();
            ltStatHeight.Text = GetSafeString(reader["Height"]);

            // Badges
            ltBadgeReligion.Text = GetSafeString(reader["Religion"]);
            ltBadgeCaste.Text = GetSafeString(reader["Caste"]);
            ltBadgeEducation.Text = GetSafeString(reader["Education"]);
        }

        private void LoadPersonalInfo(SqlDataReader reader)
        {
            var personalInfo = new List<InfoItem>
            {
                new InfoItem { Label = "Full Name", Value = GetSafeString(reader["FullName"]) },
                new InfoItem { Label = "Email", Value = GetSafeString(reader["Email"]) },
                new InfoItem { Label = "Mobile", Value = GetSafeString(reader["Phone"]) },
                new InfoItem { Label = "Date of Birth", Value = GetFormattedDate(reader["DateOfBirth"]) },
                new InfoItem { Label = "Gender", Value = GetSafeString(reader["Gender"]) },
                new InfoItem { Label = "Height", Value = GetSafeString(reader["Height"]) },
                new InfoItem { Label = "Weight", Value = GetSafeString(reader["Weight"]) },
                new InfoItem { Label = "Blood Group", Value = GetSafeString(reader["BloodGroup"]) }
            };

            rptPersonalInfo.DataSource = personalInfo;
            rptPersonalInfo.DataBind();

            // Set edit values
            txtFullName.Text = GetSafeString(reader["FullName"]);
            txtEmail.Text = GetSafeString(reader["Email"]);
            txtPhone.Text = GetSafeString(reader["Phone"]);

            if (reader["DateOfBirth"] != DBNull.Value)
                txtDOB.Text = Convert.ToDateTime(reader["DateOfBirth"]).ToString("yyyy-MM-dd");

            ddlGender.SelectedValue = GetSafeString(reader["Gender"]);
            ddlHeight.SelectedValue = GetSafeString(reader["Height"]);
        }

        private void LoadProfessionalInfo(SqlDataReader reader)
        {
            var professionalInfo = new List<InfoItem>
            {
                new InfoItem { Label = "Education", Value = GetSafeString(reader["Education"]) },
                new InfoItem { Label = "Occupation", Value = GetSafeString(reader["Occupation"]) },
                new InfoItem { Label = "Company", Value = GetSafeString(reader["Company"]) },
                new InfoItem { Label = "Annual Income", Value = FormatIncome(reader["AnnualIncome"]) },
                new InfoItem { Label = "Education Field", Value = GetSafeString(reader["EducationField"]) },
                new InfoItem { Label = "College", Value = GetSafeString(reader["College"]) }
            };

            rptProfessionalInfo.DataSource = professionalInfo;
            rptProfessionalInfo.DataBind();

            // Set edit values
            ddlEducation.SelectedValue = GetSafeString(reader["Education"]);
            ddlOccupation.SelectedValue = GetSafeString(reader["Occupation"]);
            txtCompany.Text = GetSafeString(reader["Company"]);

            if (reader["AnnualIncome"] != DBNull.Value)
                ddlIncome.SelectedValue = reader["AnnualIncome"].ToString();
        }

        private void LoadAdditionalInfo(SqlDataReader reader)
        {
            var additionalInfo = new List<InfoItem>
            {
                new InfoItem { Label = "Marital Status", Value = GetSafeString(reader["MaritalStatus"]) },
                new InfoItem { Label = "Religion", Value = GetSafeString(reader["Religion"]) },
                new InfoItem { Label = "Caste", Value = GetSafeString(reader["Caste"]) },
                new InfoItem { Label = "Mother Tongue", Value = GetSafeString(reader["MotherTongue"]) },
                new InfoItem { Label = "Eating Habits", Value = GetSafeString(reader["EatingHabits"]) },
                new InfoItem { Label = "Drinking Habits", Value = GetSafeString(reader["DrinkingHabits"]) },
                new InfoItem { Label = "Smoking Habits", Value = GetSafeString(reader["SmokingHabits"]) }
            };

            rptAdditionalInfo.DataSource = additionalInfo;
            rptAdditionalInfo.DataBind();

            // Set edit values
            ddlMaritalStatus.SelectedValue = GetSafeString(reader["MaritalStatus"]);
            ddlReligion.SelectedValue = GetSafeString(reader["Religion"]);
            txtCaste.Text = GetSafeString(reader["Caste"]);
            ddlMotherTongue.SelectedValue = GetSafeString(reader["MotherTongue"]);
        }

        private void LoadUserPhotos(int userID)
        {
            try
            {
                var photos = new List<PhotoInfo>();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT PhotoID, PhotoPath, PhotoType 
                                   FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsActive = 1 
                                   ORDER BY UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {
                            photos.Add(new PhotoInfo
                            {
                                PhotoID = Convert.ToInt32(reader["PhotoID"]),
                                PhotoPath = reader["PhotoPath"].ToString(),
                                PhotoType = reader["PhotoType"].ToString()
                            });
                        }
                    }
                }

                // Bind photos repeater
                rptPhotos.DataSource = photos.Take(5);
                rptPhotos.DataBind();

                // Create empty slots
                int emptySlots = 5 - photos.Count;
                var emptySlotsList = Enumerable.Range(1, emptySlots).Select(i => new { ID = i }).ToList();
                rptEmptySlots.DataSource = emptySlotsList;
                rptEmptySlots.DataBind();

                // Update photo count
                ltStatPhotos.Text = photos.Count.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUserPhotos error: " + ex.Message);
            }
        }

        private void LoadProfilePhoto(int userID)
        {
            try
            {
                string profilePhotoUrl = "~/Images/default-profile.jpg";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID AND PhotoType = 'Profile' AND IsActive = 1 
                                   ORDER BY UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null)
                        {
                            profilePhotoUrl = GetPhotoUrl(result.ToString());
                        }
                    }
                }

                imgProfile.ImageUrl = profilePhotoUrl;
            }
            catch (Exception ex)
            {
                imgProfile.ImageUrl = "~/Images/default-profile.jpg";
            }
        }

        // Photo Repeater Item Command
        protected void rptPhotos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "RemovePhoto")
            {
                int photoID = Convert.ToInt32(e.CommandArgument);
                RemovePhoto(photoID);
            }
        }

        private void RemovePhoto(int photoID)
        {
            if (Session["UserID"] != null)
            {
                int userID = Convert.ToInt32(Session["UserID"]);
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE UserPhotos SET IsActive = 0 WHERE PhotoID = @PhotoID AND UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@PhotoID", photoID);
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                LoadUserPhotos(userID);
                ShowMessage("Photo removed successfully!", true);
            }
        }

        // Edit/Save Buttons
        protected void btnEditPersonal_Click(object sender, EventArgs e)
        {
            pnlPersonalView.Visible = false;
            pnlPersonalEdit.Visible = true;
        }

        protected void btnSavePersonal_Click(object sender, EventArgs e)
        {
            if (UpdatePersonalInfo())
            {
                pnlPersonalView.Visible = true;
                pnlPersonalEdit.Visible = false;
                LoadUserProfile(Convert.ToInt32(Session["UserID"]));
                ShowMessage("Personal information updated successfully!", true);
            }
        }

        protected void btnCancelPersonal_Click(object sender, EventArgs e)
        {
            pnlPersonalView.Visible = true;
            pnlPersonalEdit.Visible = false;
            LoadUserProfile(Convert.ToInt32(Session["UserID"]));
        }

        protected void btnEditProfessional_Click(object sender, EventArgs e)
        {
            pnlProfessionalView.Visible = false;
            pnlProfessionalEdit.Visible = true;
        }

        protected void btnSaveProfessional_Click(object sender, EventArgs e)
        {
            if (UpdateProfessionalInfo())
            {
                pnlProfessionalView.Visible = true;
                pnlProfessionalEdit.Visible = false;
                LoadUserProfile(Convert.ToInt32(Session["UserID"]));
                ShowMessage("Professional information updated successfully!", true);
            }
        }

        protected void btnCancelProfessional_Click(object sender, EventArgs e)
        {
            pnlProfessionalView.Visible = true;
            pnlProfessionalEdit.Visible = false;
            LoadUserProfile(Convert.ToInt32(Session["UserID"]));
        }

        protected void btnEditAdditional_Click(object sender, EventArgs e)
        {
            pnlAdditionalView.Visible = false;
            pnlAdditionalEdit.Visible = true;
        }

        protected void btnSaveAdditional_Click(object sender, EventArgs e)
        {
            if (UpdateAdditionalInfo())
            {
                pnlAdditionalView.Visible = true;
                pnlAdditionalEdit.Visible = false;
                LoadUserProfile(Convert.ToInt32(Session["UserID"]));
                ShowMessage("Additional information updated successfully!", true);
            }
        }

        protected void btnCancelAdditional_Click(object sender, EventArgs e)
        {
            pnlAdditionalView.Visible = true;
            pnlAdditionalEdit.Visible = false;
            LoadUserProfile(Convert.ToInt32(Session["UserID"]));
        }

        // Photo Upload
        protected void btnUploadNewPhoto_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] != null && fuNewPhoto.HasFile)
            {
                int userID = Convert.ToInt32(Session["UserID"]);
                if (UploadNewPhoto(userID))
                {
                    LoadUserPhotos(userID);
                    LoadProfilePhoto(userID);
                    ShowMessage("Photo uploaded successfully!", true);
                    closePhotoModal();
                }
            }
            else
            {
                ShowMessage("Please select a photo to upload!", false);
            }
        }

        private bool UploadNewPhoto(int userID)
        {
            try
            {
                string photoType = cbSetAsProfile.Checked ? "Profile" : "Additional";
                string photoPath = SaveUploadedFile(userID, fuNewPhoto.PostedFile);

                if (!string.IsNullOrEmpty(photoPath))
                {
                    return SavePhotoToDatabase(userID, photoPath, photoType);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error uploading photo: " + ex.Message, false);
            }
            return false;
        }

        // Update Methods
        private bool UpdatePersonalInfo()
        {
            if (Session["UserID"] == null) return false;

            int userID = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE Users SET 
                               FullName = @FullName, Email = @Email, Phone = @Phone,
                               DateOfBirth = @DateOfBirth, Gender = @Gender, Height = @Height,
                               LastUpdated = GETDATE()
                               WHERE UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@Height", ddlHeight.SelectedValue);
                    cmd.Parameters.AddWithValue("@UserID", userID);

                    if (DateTime.TryParse(txtDOB.Text, out DateTime dob))
                        cmd.Parameters.AddWithValue("@DateOfBirth", dob);
                    else
                        cmd.Parameters.AddWithValue("@DateOfBirth", DBNull.Value);

                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        private bool UpdateProfessionalInfo()
        {
            if (Session["UserID"] == null) return false;

            int userID = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE Users SET 
                               Education = @Education, Occupation = @Occupation, 
                               Company = @Company, AnnualIncome = @AnnualIncome,
                               LastUpdated = GETDATE()
                               WHERE UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Education", ddlEducation.SelectedValue);
                    cmd.Parameters.AddWithValue("@Occupation", ddlOccupation.SelectedValue);
                    cmd.Parameters.AddWithValue("@Company", txtCompany.Text.Trim());
                    cmd.Parameters.AddWithValue("@UserID", userID);

                    if (decimal.TryParse(ddlIncome.SelectedValue, out decimal income))
                        cmd.Parameters.AddWithValue("@AnnualIncome", income);
                    else
                        cmd.Parameters.AddWithValue("@AnnualIncome", DBNull.Value);

                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        private bool UpdateAdditionalInfo()
        {
            if (Session["UserID"] == null) return false;

            int userID = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE Users SET 
                               MaritalStatus = @MaritalStatus, Religion = @Religion, 
                               Caste = @Caste, MotherTongue = @MotherTongue,
                               LastUpdated = GETDATE()
                               WHERE UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@MaritalStatus", ddlMaritalStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@Religion", ddlReligion.SelectedValue);
                    cmd.Parameters.AddWithValue("@Caste", txtCaste.Text.Trim());
                    cmd.Parameters.AddWithValue("@MotherTongue", ddlMotherTongue.SelectedValue);
                    cmd.Parameters.AddWithValue("@UserID", userID);

                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        // Helper Methods
        private string SaveUploadedFile(int userID, HttpPostedFile file)
        {
            string fileName = Path.GetFileName(file.FileName);
            string extension = Path.GetExtension(fileName).ToLower();

            if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
                throw new Exception("Only JPG, JPEG and PNG files are allowed");

            if (file.ContentLength > 5242880)
                throw new Exception("File size should be less than 5MB");

            string uploadsFolder = Server.MapPath("~/Uploads/");
            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            string userFolder = Path.Combine(uploadsFolder, userID.ToString());
            if (!Directory.Exists(userFolder))
                Directory.CreateDirectory(userFolder);

            string newFileName = $"Photo_{DateTime.Now:yyyyMMddHHmmssfff}{extension}";
            string filePath = Path.Combine(userFolder, newFileName);
            file.SaveAs(filePath);

            return newFileName;
        }

        private bool SavePhotoToDatabase(int userID, string photoPath, string photoType)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO UserPhotos (UserID, PhotoPath, PhotoType, UploadDate, IsActive) 
                               VALUES (@UserID, @PhotoPath, @PhotoType, GETDATE(), 1)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    cmd.Parameters.AddWithValue("@PhotoPath", photoPath);
                    cmd.Parameters.AddWithValue("@PhotoType", photoType);

                    conn.Open();
                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }

        public string GetPhotoUrl(string photoPath)
        {
            if (string.IsNullOrEmpty(photoPath))
                return ResolveUrl("~/Images/default-profile.jpg");

            string physicalPath = Server.MapPath("~/Uploads/" + Session["UserID"] + "/" + photoPath);
            if (File.Exists(physicalPath))
            {
                return ResolveUrl("~/Uploads/" + Session["UserID"] + "/" + photoPath);
            }
            return ResolveUrl("~/Images/default-profile.jpg");
        }

        private string GetSafeString(object value)
        {
            return value == null || value == DBNull.Value ? "Not specified" : value.ToString().Trim();
        }

        private string GetFormattedDate(object value)
        {
            if (value == null || value == DBNull.Value) return "Not specified";
            return Convert.ToDateTime(value).ToString("dd/MM/yyyy");
        }

        private string FormatIncome(object value)
        {
            if (value == null || value == DBNull.Value) return "Not specified";

            decimal income = Convert.ToDecimal(value);
            if (income == 0) return "None";
            if (income < 100000) return "Less than 1 Lakh";
            if (income < 200000) return "1-2 Lakhs";
            if (income < 500000) return "2-5 Lakhs";
            if (income < 1000000) return "5-10 Lakhs";
            if (income < 2000000) return "10-20 Lakhs";
            return "More than 20 Lakhs";
        }

        private string CalculateAgeAndOccupation(SqlDataReader reader)
        {
            int age = CalculateAge(reader);
            string occupation = GetSafeString(reader["Occupation"]);

            if (age > 0 && !string.IsNullOrEmpty(occupation) && occupation != "Not specified")
                return $"{age} Years | {occupation}";
            else if (age > 0)
                return $"{age} Years";
            else if (!string.IsNullOrEmpty(occupation) && occupation != "Not specified")
                return occupation;
            else
                return "Update your profile";
        }

        private int CalculateAge(SqlDataReader reader)
        {
            if (reader["DateOfBirth"] != DBNull.Value)
            {
                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
                int age = DateTime.Now.Year - dob.Year;
                if (DateTime.Now.DayOfYear < dob.DayOfYear)
                    age--;
                return age;
            }
            return 0;
        }

        private string GetLocation(SqlDataReader reader)
        {
            string city = GetSafeString(reader["City"]);
            string state = GetSafeString(reader["State"]);

            if (city != "Not specified" && state != "Not specified")
                return $"{city}, {state}";
            else if (city != "Not specified")
                return city;
            else if (state != "Not specified")
                return state;
            else
                return "Location not set";
        }

        private void CalculateProfileCompleteness(int userID)
        {
            // Simple calculation - you can make this more sophisticated
            int completeness = 75;
            ltCompleteness.Text = completeness + "%";
            completenessFill.Style["width"] = completeness + "%";
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            ltMessage.Text = isSuccess ? "✅ " + message : "❌ " + message;
            pnlMessage.CssClass = isSuccess ? "success-message" : "error-message";
        }

        private void closePhotoModal()
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ClosePhotoModal", "closePhotoModal();", true);
        }
    }

    // Helper classes
    public class InfoItem
    {
        public string Label { get; set; }
        public string Value { get; set; }
    }

    public class PhotoInfo
    {
        public int PhotoID { get; set; }
        public string PhotoPath { get; set; }
        public string PhotoType { get; set; }
    }
}