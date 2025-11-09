
using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JivanBandhan4
{
    public partial class Interests : System.Web.UI.Page
    {
        // Direct connection string
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    int userID = Convert.ToInt32(Session["UserID"]);
                    hdnCurrentUserID.Value = userID.ToString();

                    // Load current user gender
                    LoadCurrentUserGender(userID);

                    LoadInterestsData(userID);
                    LoadInterestStats(userID);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadCurrentUserGender(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT Gender FROM Users WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            hdnCurrentUserGender.Value = result.ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadCurrentUserGender error: " + ex.Message);
            }
        }

        private void LoadInterestsData(int userID)
        {
            LoadReceivedInterests(userID);
            LoadSentInterests(userID);
        }

        private void LoadReceivedInterests(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            i.InterestID, i.SentByUserID, i.TargetUserID, i.SentDate, i.ResponseDate, i.Status,
                            u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, u.Education,
                            u.Caste, u.Religion, u.Height, u.MaritalStatus, u.Manglik, u.Gender,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age
                        FROM Interests i
                        INNER JOIN Users u ON i.SentByUserID = u.UserID
                        WHERE i.TargetUserID = @UserID
                        ORDER BY i.SentDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptReceivedInterests.DataSource = dt;
                            rptReceivedInterests.DataBind();
                            pnlNoReceivedInterests.Visible = false;
                            lblReceivedCount.Text = dt.Rows.Count.ToString();
                        }
                        else
                        {
                            rptReceivedInterests.DataSource = null;
                            rptReceivedInterests.DataBind();
                            pnlNoReceivedInterests.Visible = true;
                            lblReceivedCount.Text = "0";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowNotification("मिळालेली आवड लोड करताना त्रुटी: " + ex.Message, "error");
                pnlNoReceivedInterests.Visible = true;
                lblReceivedCount.Text = "0";
            }
        }

        private void LoadSentInterests(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            i.InterestID, i.SentByUserID, i.TargetUserID, i.SentDate, i.ResponseDate, i.Status,
                            u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, u.Education,
                            u.Caste, u.Religion, u.Height, u.MaritalStatus, u.Manglik, u.Gender,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age
                        FROM Interests i
                        INNER JOIN Users u ON i.TargetUserID = u.UserID
                        WHERE i.SentByUserID = @UserID
                        ORDER BY i.SentDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptSentInterests.DataSource = dt;
                            rptSentInterests.DataBind();
                            pnlNoSentInterests.Visible = false;
                            lblSentCount.Text = dt.Rows.Count.ToString();
                        }
                        else
                        {
                            rptSentInterests.DataSource = null;
                            rptSentInterests.DataBind();
                            pnlNoSentInterests.Visible = true;
                            lblSentCount.Text = "0";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowNotification("पाठवलेली आवड लोड करताना त्रुटी: " + ex.Message, "error");
                pnlNoSentInterests.Visible = true;
                lblSentCount.Text = "0";
            }
        }

        private void LoadInterestStats(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Total received interests
                    string receivedQuery = @"SELECT COUNT(*) FROM Interests 
                                           WHERE TargetUserID = @UserID";
                    SqlCommand receivedCmd = new SqlCommand(receivedQuery, conn);
                    receivedCmd.Parameters.AddWithValue("@UserID", userID);
                    lblTotalReceived.Text = receivedCmd.ExecuteScalar().ToString();

                    // Total sent interests
                    string sentQuery = @"SELECT COUNT(*) FROM Interests 
                                       WHERE SentByUserID = @UserID";
                    SqlCommand sentCmd = new SqlCommand(sentQuery, conn);
                    sentCmd.Parameters.AddWithValue("@UserID", userID);
                    lblTotalSent.Text = sentCmd.ExecuteScalar().ToString();

                    // Accepted interests
                    string acceptedQuery = @"SELECT COUNT(*) FROM Interests 
                                           WHERE TargetUserID = @UserID AND Status = 'Accepted'";
                    SqlCommand acceptedCmd = new SqlCommand(acceptedQuery, conn);
                    acceptedCmd.Parameters.AddWithValue("@UserID", userID);
                    lblAccepted.Text = acceptedCmd.ExecuteScalar().ToString();

                    // Pending interests
                    string pendingQuery = @"SELECT COUNT(*) FROM Interests 
                                          WHERE TargetUserID = @UserID AND Status = 'Pending'";
                    SqlCommand pendingCmd = new SqlCommand(pendingQuery, conn);
                    pendingCmd.Parameters.AddWithValue("@UserID", userID);
                    lblPending.Text = pendingCmd.ExecuteScalar().ToString();
                }
            }
            catch (Exception ex)
            {
                ShowNotification("सांख्यिकी लोड करताना त्रुटी: " + ex.Message, "error");
                lblTotalReceived.Text = "0";
                lblTotalSent.Text = "0";
                lblAccepted.Text = "0";
                lblPending.Text = "0";
            }
        }

        // Utility Methods
        public string GetUserPhotoUrl(object userID)
        {
            try
            {
                if (userID == null) return "Images/default-profile.jpg";

                int profileUserID = Convert.ToInt32(userID);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID 
                                   ORDER BY 
                                       CASE WHEN IsProfilePhoto = 1 THEN 1 ELSE 2 END,
                                       UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", profileUserID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            string path = result.ToString().Trim();
                            if (path.StartsWith("http"))
                                return path;
                            else
                                return "Uploads/" + profileUserID + "/" + path;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetUserPhotoUrl error: " + ex.Message);
            }

            return "Images/default-profile.jpg";
        }

        public string CalculateAge(object dob)
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

        public string FormatDate(object date)
        {
            try
            {
                if (date == null || date == DBNull.Value)
                    return "";

                DateTime interestDate = Convert.ToDateTime(date);
                TimeSpan timeDiff = DateTime.Now - interestDate;

                if (timeDiff.TotalDays >= 365)
                {
                    int years = (int)(timeDiff.TotalDays / 365);
                    return years + " वर्षांपूर्वी";
                }
                else if (timeDiff.TotalDays >= 30)
                {
                    int months = (int)(timeDiff.TotalDays / 30);
                    return months + " महिन्यांपूर्वी";
                }
                else if (timeDiff.TotalDays >= 1)
                {
                    return $"{(int)timeDiff.TotalDays} दिवसांपूर्वी";
                }
                else if (timeDiff.TotalHours >= 1)
                {
                    return $"{(int)timeDiff.TotalHours} तासांपूर्वी";
                }
                else if (timeDiff.TotalMinutes >= 1)
                {
                    return $"{(int)timeDiff.TotalMinutes} मिनिटांपूर्वी";
                }
                else
                {
                    return "आत्ताच";
                }
            }
            catch (Exception)
            {
                return "";
            }
        }

        public string GetStatusText(object status)
        {
            if (status == null) return "अज्ञात";

            switch (status.ToString().ToLower())
            {
                case "pending": return "प्रलंबित";
                case "accepted": return "स्वीकारले";
                case "rejected": return "नाकारले";
                default: return status.ToString();
            }
        }

        public string GetStatusClass(object status)
        {
            if (status == null) return "status-pending";

            switch (status.ToString().ToLower())
            {
                case "pending": return "status-pending";
                case "accepted": return "status-accepted";
                case "rejected": return "status-rejected";
                default: return "status-pending";
            }
        }

        // Web Method for tracking profile views
        [WebMethod]
        public static string TrackProfileView(int currentUserID, int viewedUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Check if view already exists today
                    string checkQuery = @"SELECT COUNT(*) FROM ProfileViews 
                                        WHERE UserID = @ViewedUserID 
                                        AND ViewedByUserID = @CurrentUserID 
                                        AND CAST(ViewDate AS DATE) = CAST(GETDATE() AS DATE)";

                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@ViewedUserID", viewedUserID);
                        checkCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                        conn.Open();

                        int existingViews = (int)checkCmd.ExecuteScalar();

                        if (existingViews > 0)
                        {
                            // Update existing view count
                            string updateQuery = @"UPDATE ProfileViews SET ViewCount = ViewCount + 1 
                                                 WHERE UserID = @ViewedUserID 
                                                 AND ViewedByUserID = @CurrentUserID 
                                                 AND CAST(ViewDate AS DATE) = CAST(GETDATE() AS DATE)";
                            using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                            {
                                updateCmd.Parameters.AddWithValue("@ViewedUserID", viewedUserID);
                                updateCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                                updateCmd.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            // Insert new view
                            string insertQuery = @"INSERT INTO ProfileViews (UserID, ViewedByUserID, ViewDate, ViewCount, IPAddress) 
                                                 VALUES (@ViewedUserID, @CurrentUserID, GETDATE(), 1, @IPAddress)";
                            using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                            {
                                insertCmd.Parameters.AddWithValue("@ViewedUserID", viewedUserID);
                                insertCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                                insertCmd.Parameters.AddWithValue("@IPAddress", GetClientIP());
                                insertCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
                return "success";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("TrackProfileView error: " + ex.Message);
                return "error";
            }
        }

        // Helper method to get client IP
        private static string GetClientIP()
        {
            System.Web.HttpContext context = System.Web.HttpContext.Current;
            string ipAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (!string.IsNullOrEmpty(ipAddress))
            {
                string[] addresses = ipAddress.Split(',');
                if (addresses.Length != 0)
                {
                    return addresses[0];
                }
            }

            return context.Request.ServerVariables["REMOTE_ADDR"];
        }

        // Event Handlers
        protected void btnAccept_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int interestID = Convert.ToInt32(btn.CommandArgument);

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Interests SET Status = 'Accepted', ResponseDate = GETDATE() 
                                   WHERE InterestID = @InterestID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@InterestID", interestID);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Reload data
                            int userID = Convert.ToInt32(hdnCurrentUserID.Value);
                            LoadInterestsData(userID);
                            LoadInterestStats(userID);
                            ShowNotification("✅ आवड स्वीकारली आहे!", "success");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowNotification("❌ आवड स्वीकारताना त्रुटी: " + ex.Message, "error");
            }
        }

        protected void btnReject_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int interestID = Convert.ToInt32(btn.CommandArgument);

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Interests SET Status = 'Rejected', ResponseDate = GETDATE() 
                                   WHERE InterestID = @InterestID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@InterestID", interestID);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Reload data
                            int userID = Convert.ToInt32(hdnCurrentUserID.Value);
                            LoadInterestsData(userID);
                            LoadInterestStats(userID);
                            ShowNotification("❌ आवड नाकारली आहे!", "success");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowNotification("❌ आवड नाकारताना त्रुटी: " + ex.Message, "error");
            }
        }

        protected void btnWithdraw_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int interestID = Convert.ToInt32(btn.CommandArgument);

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"DELETE FROM Interests WHERE InterestID = @InterestID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@InterestID", interestID);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Reload data
                            int userID = Convert.ToInt32(hdnCurrentUserID.Value);
                            LoadInterestsData(userID);
                            LoadInterestStats(userID);
                            ShowNotification("🗑️ आवड मागे घेतली आहे!", "success");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowNotification("❌ आवड मागे घेताना त्रुटी: " + ex.Message, "error");
            }
        }

        protected void btnViewProfile_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int userID = Convert.ToInt32(btn.CommandArgument);
            Response.Redirect($"ViewUserProfile.aspx?UserID={userID}&from=interests");
        }

        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int toUserID = Convert.ToInt32(btn.CommandArgument);
            Response.Redirect($"Messages.aspx?ToUserID={toUserID}");
        }

        protected void btnResend_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int toUserID = Convert.ToInt32(btn.CommandArgument);
            int fromUserID = Convert.ToInt32(hdnCurrentUserID.Value);

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Check if interest already exists
                    string checkQuery = @"SELECT COUNT(*) FROM Interests 
                                        WHERE SentByUserID = @SentByUserID AND TargetUserID = @TargetUserID 
                                        AND Status = 'Pending'";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@SentByUserID", fromUserID);
                        checkCmd.Parameters.AddWithValue("@TargetUserID", toUserID);
                        conn.Open();
                        int existingCount = (int)checkCmd.ExecuteScalar();

                        if (existingCount > 0)
                        {
                            ShowNotification("⚠️ तुम्ही आधीच या सदस्याला आवड पाठवली आहे!", "info");
                            return;
                        }
                    }

                    // Insert new interest
                    string insertQuery = @"INSERT INTO Interests (SentByUserID, TargetUserID, SentDate, Status) 
                                         VALUES (@SentByUserID, @TargetUserID, GETDATE(), 'Pending')";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@SentByUserID", fromUserID);
                        insertCmd.Parameters.AddWithValue("@TargetUserID", toUserID);
                        insertCmd.ExecuteNonQuery();
                    }
                }

                // Reload data
                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);
                LoadInterestsData(currentUserID);
                LoadInterestStats(currentUserID);
                ShowNotification("🔄 आवड पुन्हा पाठवली आहे!", "success");
            }
            catch (Exception ex)
            {
                ShowNotification("❌ आवड पुन्हा पाठवताना त्रुटी: " + ex.Message, "error");
            }
        }

        protected void btnFindMatches_Click(object sender, EventArgs e)
        {
            Response.Redirect("Search.aspx");
        }

        protected void btnBackToDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnImproveProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect("MyProfile.aspx?edit=true");
        }

        // Repeater ItemDataBound events
        protected void rptReceivedInterests_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;

                // Set image onerror handler
                Image imgUser = (Image)e.Item.FindControl("imgUser");
                if (imgUser != null)
                {
                    imgUser.Attributes["onerror"] = "this.src='Images/default-profile.jpg'";
                }

                // Update status badge based on actual status
                Label lblStatus = (Label)e.Item.FindControl("lblStatus");
                if (lblStatus != null)
                {
                    string status = row["Status"]?.ToString();
                    lblStatus.Text = GetStatusText(status);

                    // Update CSS class based on status
                    if (lblStatus.Parent != null && lblStatus.Parent is WebControl)
                    {
                        WebControl statusContainer = (WebControl)lblStatus.Parent;
                        statusContainer.CssClass = $"status-badge {GetStatusClass(status)} marathi-font";
                    }
                }
            }
        }

        protected void rptSentInterests_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;

                // Set image onerror handler
                Image imgUser = (Image)e.Item.FindControl("imgUser");
                if (imgUser != null)
                {
                    imgUser.Attributes["onerror"] = "this.src='Images/default-profile.jpg'";
                }
            }
        }

        private void ShowNotification(string message, string type)
        {
            string script = $@"<script>showNotification('{message.Replace("'", "\\'")}', '{type}');</script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowNotification", script, false);
        }
    }
}