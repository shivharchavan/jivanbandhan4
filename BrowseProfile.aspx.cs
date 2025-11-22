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
    public partial class BrowseProfile : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    int userID = Convert.ToInt32(Session["UserID"]);
                    LoadCurrentUserInfo(userID);
                    BindFilterDropdowns();
                    LoadProfilesWithFilters();
                    LoadMembershipInfo(userID);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadCurrentUserInfo(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT UserID, Gender FROM Users WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            hdnCurrentUserID.Value = userID.ToString();
                            string currentGender = reader["Gender"].ToString();
                            hdnCurrentUserGender.Value = currentGender;

                            // Set search info label
                            string oppositeGender = currentGender == "Male" ? "Female" : "Male";
                            lblGenderSearch.Text = oppositeGender;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadCurrentUserInfo error: " + ex.Message);
            }
        }

        private void LoadMembershipInfo(int userID)
        {
            try
            {
                string membershipType = "Free";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 MembershipType FROM UserMemberships 
                                   WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
                                   ORDER BY ExpiryDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null)
                        {
                            membershipType = result.ToString();
                        }
                    }
                }

                hdnCurrentUserMembership.Value = membershipType;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadMembershipInfo error: " + ex.Message);
            }
        }

        private void BindFilterDropdowns()
        {
            BindCityDropdown();
            BindEducationDropdown();
            BindOccupationDropdown();
            BindReligionDropdown();
            BindMaritalStatusDropdown();
        }

        private void BindCityDropdown()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT DISTINCT City FROM Users 
                                   WHERE City IS NOT NULL AND City <> '' 
                                   AND State = 'Maharashtra'
                                   ORDER BY City";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlCity.Items.Clear();
                        ddlCity.Items.Add(new ListItem("All Cities", ""));

                        while (reader.Read())
                        {
                            string city = reader["City"].ToString();
                            if (!string.IsNullOrEmpty(city))
                            {
                                ddlCity.Items.Add(new ListItem(city, city));
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
                    string query = @"SELECT DISTINCT Education FROM Users 
                                   WHERE Education IS NOT NULL AND Education <> '' 
                                   ORDER BY Education";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlEducation.Items.Clear();
                        ddlEducation.Items.Add(new ListItem("All Education", ""));

                        while (reader.Read())
                        {
                            string education = reader["Education"].ToString();
                            if (!string.IsNullOrEmpty(education))
                            {
                                ddlEducation.Items.Add(new ListItem(education, education));
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

        private void BindOccupationDropdown()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT DISTINCT Occupation FROM Users 
                                   WHERE Occupation IS NOT NULL AND Occupation <> '' 
                                   ORDER BY Occupation";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlOccupation.Items.Clear();
                        ddlOccupation.Items.Add(new ListItem("All Occupations", ""));

                        while (reader.Read())
                        {
                            string occupation = reader["Occupation"].ToString();
                            if (!string.IsNullOrEmpty(occupation))
                            {
                                ddlOccupation.Items.Add(new ListItem(occupation, occupation));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("BindOccupationDropdown error: " + ex.Message);
            }
        }

        private void BindReligionDropdown()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT DISTINCT Religion FROM Users 
                                   WHERE Religion IS NOT NULL AND Religion <> '' 
                                   ORDER BY Religion";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlReligion.Items.Clear();
                        ddlReligion.Items.Add(new ListItem("All Religions", ""));

                        while (reader.Read())
                        {
                            string religion = reader["Religion"].ToString();
                            if (!string.IsNullOrEmpty(religion))
                            {
                                ddlReligion.Items.Add(new ListItem(religion, religion));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("BindReligionDropdown error: " + ex.Message);
            }
        }

        private void BindMaritalStatusDropdown()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT DISTINCT MaritalStatus FROM Users 
                                   WHERE MaritalStatus IS NOT NULL AND MaritalStatus <> '' 
                                   ORDER BY MaritalStatus";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlMaritalStatus.Items.Clear();
                        ddlMaritalStatus.Items.Add(new ListItem("All Marital Status", ""));

                        while (reader.Read())
                        {
                            string maritalStatus = reader["MaritalStatus"].ToString();
                            if (!string.IsNullOrEmpty(maritalStatus))
                            {
                                ddlMaritalStatus.Items.Add(new ListItem(maritalStatus, maritalStatus));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("BindMaritalStatusDropdown error: " + ex.Message);
            }
        }

        private void LoadProfilesWithFilters()
        {
            try
            {
                string currentUserGender = hdnCurrentUserGender.Value;
                if (string.IsNullOrEmpty(currentUserGender))
                {
                    ShowNoResults();
                    return;
                }

                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    StringBuilder query = new StringBuilder(@"
                        SELECT 
                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
                            u.Education, u.Religion, u.Gender, u.Phone, u.AnnualIncome, u.MaritalStatus,
                            u.Height, u.PhysicalStatus, u.MotherTongue, u.Caste, u.SubCaste,
                            u.WorkingLocation, u.Company, u.FamilyType, u.FamilyStatus,
                            u.AboutMe, u.Hobbies, u.PartnerExpectations,
                            u.IsPremium,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age
                        FROM Users u
                        WHERE u.Gender = @Gender 
                        AND u.UserID != @CurrentUserID
                        AND u.IsActive = 1
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

                    // Religion Filter
                    if (!string.IsNullOrEmpty(ddlReligion.SelectedValue))
                    {
                        query.Append(" AND u.Religion = @Religion");
                        parameters.Add(new SqlParameter("@Religion", ddlReligion.SelectedValue));
                    }

                    // Income Filter
                    if (!string.IsNullOrEmpty(ddlIncome.SelectedValue))
                    {
                        string incomeFilter = ddlIncome.SelectedValue;
                        if (incomeFilter == "0-200000")
                        {
                            query.Append(" AND (u.AnnualIncome IS NULL OR u.AnnualIncome < 200000)");
                        }
                        else if (incomeFilter == "200000-500000")
                        {
                            query.Append(" AND u.AnnualIncome >= 200000 AND u.AnnualIncome < 500000");
                        }
                        else if (incomeFilter == "500000-1000000")
                        {
                            query.Append(" AND u.AnnualIncome >= 500000 AND u.AnnualIncome < 1000000");
                        }
                        else if (incomeFilter == "1000000-2000000")
                        {
                            query.Append(" AND u.AnnualIncome >= 1000000 AND u.AnnualIncome < 2000000");
                        }
                        else if (incomeFilter == "2000000-5000000")
                        {
                            query.Append(" AND u.AnnualIncome >= 2000000 AND u.AnnualIncome < 5000000");
                        }
                        else if (incomeFilter == "5000000+")
                        {
                            query.Append(" AND u.AnnualIncome >= 5000000");
                        }
                    }

                    // Marital Status Filter
                    if (!string.IsNullOrEmpty(ddlMaritalStatus.SelectedValue))
                    {
                        query.Append(" AND u.MaritalStatus = @MaritalStatus");
                        parameters.Add(new SqlParameter("@MaritalStatus", ddlMaritalStatus.SelectedValue));
                    }

                    // Education Filter
                    if (!string.IsNullOrEmpty(ddlEducation.SelectedValue))
                    {
                        query.Append(" AND u.Education = @Education");
                        parameters.Add(new SqlParameter("@Education", ddlEducation.SelectedValue));
                    }

                    // Occupation Filter
                    if (!string.IsNullOrEmpty(ddlOccupation.SelectedValue))
                    {
                        query.Append(" AND u.Occupation = @Occupation");
                        parameters.Add(new SqlParameter("@Occupation", ddlOccupation.SelectedValue));
                    }

                    // City Filter
                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
                    {
                        query.Append(" AND u.City = @City");
                        parameters.Add(new SqlParameter("@City", ddlCity.SelectedValue));
                    }

                    query.Append(" ORDER BY u.CreatedDate DESC");

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

                            // Update results count
                            int resultCount = dt.Rows.Count;
                            lblResultsCount.Text = $"Found {resultCount} profile(s) matching your criteria";
                            pnlNoProfiles.Visible = false;
                        }
                        else
                        {
                            ShowNoResults();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowNoResults();
                System.Diagnostics.Debug.WriteLine("LoadProfilesWithFilters error: " + ex.Message);
            }
        }

        private void ShowNoResults()
        {
            rptProfiles.DataSource = null;
            rptProfiles.DataBind();
            pnlNoProfiles.Visible = true;
            lblResultsCount.Text = "No profiles found matching your criteria";
        }

        protected void rptProfiles_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
                HtmlGenericControl profileHeaderBackground = (HtmlGenericControl)e.Item.FindControl("profileHeaderBackground");
                HtmlGenericControl contactNumberDisplay = (HtmlGenericControl)e.Item.FindControl("contactNumberDisplay");
                HtmlGenericControl contactLocked = (HtmlGenericControl)e.Item.FindControl("contactLocked");
                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
                Literal ltIncome = (Literal)e.Item.FindControl("ltIncome");
                Literal ltHeight = (Literal)e.Item.FindControl("ltHeight");
                Literal ltCaste = (Literal)e.Item.FindControl("ltCaste");
                Literal ltMotherTongue = (Literal)e.Item.FindControl("ltMotherTongue");
                Literal ltCompany = (Literal)e.Item.FindControl("ltCompany");
                HtmlGenericControl premiumBadge = (HtmlGenericControl)e.Item.FindControl("premiumBadge");

                if (imgProfile != null && profileHeaderBackground != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    int profileUserID = Convert.ToInt32(row["UserID"]);

                    // Load profile photo from UserPhotos table
                    string photoUrl = LoadProfilePhoto(profileUserID, imgProfile);

                    // Set background image for profile header
                    if (!string.IsNullOrEmpty(photoUrl) && photoUrl != ResolveUrl("~/Images/default-profile.jpg"))
                    {
                        profileHeaderBackground.Style.Add("background-image", $"url('{photoUrl}')");
                        profileHeaderBackground.Style.Add("position", "relative");
                        profileHeaderBackground.Style.Add("background-size", "cover");
                        profileHeaderBackground.Style.Add("background-position", "center");
                        profileHeaderBackground.Style.Add("background-blend-mode", "overlay");
                        profileHeaderBackground.Style.Add("background-color", "rgba(0,0,0,0.3)");
                    }

                    imgProfile.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
                }

                // Handle contact number display based on current user's membership
                if (contactNumberDisplay != null && contactLocked != null)
                {
                    string currentUserMembership = hdnCurrentUserMembership.Value;

                    // ONLY Platinum members can view contact numbers
                    bool canViewContact = currentUserMembership == "Platinum";

                    if (canViewContact)
                    {
                        // User has Platinum membership - show contact number
                        contactNumberDisplay.Style["display"] = "none"; // Hide initially, will show on button click
                        contactLocked.Style["display"] = "none";

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
                    }
                }

                // Set age
                if (ltAge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltAge.Text = CalculateAgeInline(row["DateOfBirth"]);
                }

                // Set income
                if (ltIncome != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltIncome.Text = FormatIncome(row["AnnualIncome"]);
                }

                // Set height
                if (ltHeight != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltHeight.Text = FormatHeight(row["Height"]);
                }

                // Set caste
                if (ltCaste != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltCaste.Text = FormatCaste(row["Caste"], row["SubCaste"]);
                }

                // Set mother tongue
                if (ltMotherTongue != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltMotherTongue.Text = FormatMotherTongue(row["MotherTongue"]);
                }

                // Set company
                if (ltCompany != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltCompany.Text = FormatCompany(row["Company"], row["WorkingLocation"]);
                }

                // Set premium badge
                if (premiumBadge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    bool isPremium = row["IsPremium"] != DBNull.Value && Convert.ToBoolean(row["IsPremium"]);
                    premiumBadge.Visible = isPremium;
                }
            }
        }

        // Helper method to get profile photo URL
        public string GetProfilePhotoUrl(object dataItem)
        {
            if (dataItem == null) return ResolveUrl("~/Images/default-profile.jpg");

            DataRowView row = (DataRowView)dataItem;
            int userID = Convert.ToInt32(row["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsActive = 1 
                                   AND (IsProfilePhoto = 1 OR PhotoType = 'Profile')
                                   ORDER BY IsProfilePhoto DESC, UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            string photoPath = result.ToString();
                            if (photoPath.StartsWith("http") || photoPath.Contains("://"))
                            {
                                return photoPath;
                            }
                            else
                            {
                                return ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetProfilePhotoUrl error: " + ex.Message);
            }

            return ResolveUrl("~/Images/default-profile.jpg");
        }

        private string LoadProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // First try to get profile photo from UserPhotos table where IsProfilePhoto = 1
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsActive = 1 
                                   AND (IsProfilePhoto = 1 OR PhotoType = 'Profile')
                                   ORDER BY IsProfilePhoto DESC, UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            string photoPath = result.ToString();
                            // Check if the path is already a full URL or just filename
                            if (photoPath.StartsWith("http") || photoPath.Contains("://"))
                            {
                                imgControl.ImageUrl = photoPath;
                                return photoPath;
                            }
                            else
                            {
                                string resolvedPath = ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
                                imgControl.ImageUrl = resolvedPath;
                                return resolvedPath;
                            }
                        }
                        else
                        {
                            // If no photo in UserPhotos, use default
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

        public string FormatIncome(object income)
        {
            try
            {
                if (income == null || income == DBNull.Value || string.IsNullOrEmpty(income.ToString()))
                    return "Not specified";

                decimal incomeValue = Convert.ToDecimal(income);

                if (incomeValue >= 10000000) // 1 crore
                    return (incomeValue / 10000000).ToString("0.0") + " Cr+";
                else if (incomeValue >= 100000) // 1 lakh
                    return (incomeValue / 100000).ToString("0.0") + " Lakhs+";
                else
                    return "₹" + incomeValue.ToString("N0");
            }
            catch (Exception)
            {
                return "Not specified";
            }
        }

        public string FormatHeight(object height)
        {
            try
            {
                if (height == null || height == DBNull.Value || string.IsNullOrEmpty(height.ToString()))
                    return "Not specified";

                decimal heightValue = Convert.ToDecimal(height);
                return $"{heightValue} cm";
            }
            catch (Exception)
            {
                return "Not specified";
            }
        }

        public string FormatCaste(object caste, object subCaste)
        {
            try
            {
                string casteStr = caste != DBNull.Value ? caste.ToString() : "";
                string subCasteStr = subCaste != DBNull.Value ? subCaste.ToString() : "";

                if (!string.IsNullOrEmpty(casteStr) && !string.IsNullOrEmpty(subCasteStr))
                {
                    return $"{casteStr} - {subCasteStr}";
                }
                else if (!string.IsNullOrEmpty(casteStr))
                {
                    return casteStr;
                }
                else
                {
                    return "Not specified";
                }
            }
            catch (Exception)
            {
                return "Not specified";
            }
        }

        public string FormatMotherTongue(object motherTongue)
        {
            try
            {
                if (motherTongue == null || motherTongue == DBNull.Value || string.IsNullOrEmpty(motherTongue.ToString()))
                    return "Not specified";

                return motherTongue.ToString();
            }
            catch (Exception)
            {
                return "Not specified";
            }
        }

        public string FormatCompany(object company, object workingLocation)
        {
            try
            {
                string companyStr = company != DBNull.Value ? company.ToString() : "";
                string workingLocationStr = workingLocation != DBNull.Value ? workingLocation.ToString() : "";

                if (!string.IsNullOrEmpty(companyStr) && !string.IsNullOrEmpty(workingLocationStr))
                {
                    return $"{companyStr}, {workingLocationStr}";
                }
                else if (!string.IsNullOrEmpty(companyStr))
                {
                    return companyStr;
                }
                else if (!string.IsNullOrEmpty(workingLocationStr))
                {
                    return workingLocationStr;
                }
                else
                {
                    return "Not specified";
                }
            }
            catch (Exception)
            {
                return "Not specified";
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProfilesWithFilters();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            // Reset all filters
            txtAgeFrom.Text = "";
            txtAgeTo.Text = "";
            ddlReligion.SelectedIndex = 0;
            ddlIncome.SelectedIndex = 0;
            ddlMaritalStatus.SelectedIndex = 0;
            ddlEducation.SelectedIndex = 0;
            ddlOccupation.SelectedIndex = 0;
            ddlCity.SelectedIndex = 0;

            // Reload profiles without filters
            LoadProfilesWithFilters();
        }

        // Web Methods for AJAX calls
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
    }
}