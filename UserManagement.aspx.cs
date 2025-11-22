using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JivanBandhan4.Admin
{
    public partial class UserManagement : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["AdminUserID"] == null)
                {
                    Response.Redirect("AdminLogin.aspx");
                    return;
                }

                LoadStats();
                BindCities();
                BindUsers();
            }
        }

        private void LoadStats()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Total Users
                    string totalUsersQuery = "SELECT COUNT(*) FROM Users";
                    using (SqlCommand cmd = new SqlCommand(totalUsersQuery, conn))
                    {
                        lblTotalUsers.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Active Users
                    string activeUsersQuery = "SELECT COUNT(*) FROM Users WHERE IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(activeUsersQuery, conn))
                    {
                        lblActiveUsers.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Verified Users
                    string verifiedUsersQuery = "SELECT COUNT(*) FROM Users WHERE IsVerified = 1 AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(verifiedUsersQuery, conn))
                    {
                        lblVerifiedUsers.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Premium Users
                    string premiumUsersQuery = @"SELECT COUNT(DISTINCT u.UserID) 
                                               FROM Users u 
                                               INNER JOIN UserMemberships um ON u.UserID = um.UserID 
                                               WHERE um.ExpiryDate > GETDATE() 
                                               AND um.MembershipType IN ('Silver', 'Gold', 'Platinum')";
                    using (SqlCommand cmd = new SqlCommand(premiumUsersQuery, conn))
                    {
                        lblPremiumUsers.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Blocked Users
                    string blockedUsersQuery = "SELECT COUNT(*) FROM Users WHERE IsActive = 0";
                    using (SqlCommand cmd = new SqlCommand(blockedUsersQuery, conn))
                    {
                        lblBlockedUsers.Text = cmd.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception)
            {
                ShowMessage("Error loading statistics", "error");
            }
        }

        private void BindCities()
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
                        ddlCity.Items.Add(new ListItem("All Cities", ""));
                        while (reader.Read())
                        {
                            ddlCity.Items.Add(new ListItem(reader["City"].ToString(), reader["City"].ToString()));
                        }
                        reader.Close();
                    }
                }
            }
            catch (Exception)
            {
                ShowMessage("Error loading cities", "error");
            }
        }

        private void BindUsers()
        {
            try
            {
                string whereClause = BuildWhereClause();
                string sortExpression = "CreatedDate DESC";
                int pageSize = Convert.ToInt32(ddlPageSize.SelectedValue);
                int startRowIndex = (gvUsers.PageIndex * pageSize);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = $@"
                        SELECT 
                            UserID, Email, FullName, Gender, DateOfBirth, 
                            Occupation, Education, City, State, Religion,
                            IsActive, IsVerified, CreatedDate, Phone
                        FROM Users 
                        {whereClause}
                        ORDER BY {sortExpression}
                        OFFSET {startRowIndex} ROWS FETCH NEXT {pageSize} ROWS ONLY";

                    string countQuery = $@"
                        SELECT COUNT(*) FROM Users {whereClause}";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        AddParameters(cmd);
                        conn.Open();
                        DataTable dt = new DataTable();
                        dt.Load(cmd.ExecuteReader());
                        gvUsers.DataSource = dt;
                        gvUsers.DataBind();
                    }

                    // Get total records count
                    using (SqlCommand countCmd = new SqlCommand(countQuery, conn))
                    {
                        AddParameters(countCmd);
                        int totalRecords = Convert.ToInt32(countCmd.ExecuteScalar());
                        UpdatePaginationInfo(totalRecords);
                    }
                }
            }
            catch (Exception)
            {
                ShowMessage("Error loading users", "error");
            }
        }

        private string BuildWhereClause()
        {
            List<string> conditions = new List<string>();

            // Search by name/email
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                conditions.Add("(FullName LIKE '%' + @Search + '%' OR Email LIKE '%' + @Search + '%')");
            }

            // Gender filter
            if (!string.IsNullOrEmpty(ddlGender.SelectedValue))
            {
                conditions.Add("Gender = @Gender");
            }

            // Status filter
            if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
            {
                switch (ddlStatus.SelectedValue)
                {
                    case "Active":
                        conditions.Add("IsActive = 1");
                        break;
                    case "Blocked":
                        conditions.Add("IsActive = 0");
                        break;
                    case "Unverified":
                        conditions.Add("IsVerified = 0 AND IsActive = 1");
                        break;
                }
            }

            // City filter
            if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
            {
                conditions.Add("City = @City");
            }

            // Date range filter
            if (!string.IsNullOrEmpty(txtFromDate.Text))
            {
                conditions.Add("CAST(CreatedDate AS DATE) >= @FromDate");
            }
            if (!string.IsNullOrEmpty(txtToDate.Text))
            {
                conditions.Add("CAST(CreatedDate AS DATE) <= @ToDate");
            }

            return conditions.Count > 0 ? "WHERE " + string.Join(" AND ", conditions) : "";
        }

        private void AddParameters(SqlCommand cmd)
        {
            if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
            {
                cmd.Parameters.AddWithValue("@Search", txtSearch.Text.Trim());
            }

            if (!string.IsNullOrEmpty(ddlGender.SelectedValue))
            {
                cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue);
            }

            if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
            {
                cmd.Parameters.AddWithValue("@City", ddlCity.SelectedValue);
            }

            if (!string.IsNullOrEmpty(txtFromDate.Text))
            {
                cmd.Parameters.AddWithValue("@FromDate", txtFromDate.Text);
            }

            if (!string.IsNullOrEmpty(txtToDate.Text))
            {
                cmd.Parameters.AddWithValue("@ToDate", txtToDate.Text);
            }
        }

        private void UpdatePaginationInfo(int totalRecords)
        {
            int pageSize = Convert.ToInt32(ddlPageSize.SelectedValue);
            int currentPage = gvUsers.PageIndex + 1;
            int startRecord = (gvUsers.PageIndex * pageSize) + 1;
            int endRecord = Math.Min((gvUsers.PageIndex + 1) * pageSize, totalRecords);

            lblStartRecord.Text = startRecord.ToString();
            lblEndRecord.Text = endRecord.ToString();
            lblTotalRecords.Text = totalRecords.ToString();
        }

        // FIXED: GetUserPhoto method
        public string GetUserPhoto(object userID)
        {
            if (userID == null) return "../../Images/default-profile.jpg";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsActive = 1
                                   ORDER BY IsProfilePhoto DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            return "../../Uploads/" + userID + "/" + result.ToString();
                        }
                    }
                }
            }
            catch (Exception)
            {
                // Handle error silently
            }

            return "../../Images/default-profile.jpg";
        }

        // FIXED: CalculateAge method
        public string CalculateAge(object dob)
        {
            if (dob == null || dob == DBNull.Value) return "N/A";

            try
            {
                DateTime birthDate = Convert.ToDateTime(dob);
                int age = DateTime.Now.Year - birthDate.Year;
                if (DateTime.Now.DayOfYear < birthDate.DayOfYear)
                    age--;

                return age.ToString();
            }
            catch
            {
                return "N/A";
            }
        }

        // FIXED: GetMembershipStatus method
        public string GetMembershipStatus(object userID)
        {
            if (userID == null) return "Free";

            try
            {
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

                        return result != null ? result.ToString() : "Free";
                    }
                }
            }
            catch (Exception)
            {
                return "Free";
            }
        }

        // FIXED: GetMembershipBadgeClass method (C# 7.3 compatible)
        public string GetMembershipBadgeClass(object userID)
        {
            string membership = GetMembershipStatus(userID);

            if (membership == "Silver")
                return "badge-secondary";
            else if (membership == "Gold")
                return "badge-warning";
            else if (membership == "Platinum")
                return "badge-primary";
            else
                return "badge-info";
        }

        // FIXED: GetStatusBadgeClass method
        public string GetStatusBadgeClass(object isActive, object isVerified)
        {
            if (isActive == null || isVerified == null) return "badge-danger";

            bool active = Convert.ToBoolean(isActive);
            bool verified = Convert.ToBoolean(isVerified);

            if (!active) return "badge-danger";
            if (!verified) return "badge-warning";
            return "badge-success";
        }

        // FIXED: GetStatusText method
        public string GetStatusText(object isActive, object isVerified)
        {
            if (isActive == null || isVerified == null) return "Unknown";

            bool active = Convert.ToBoolean(isActive);
            bool verified = Convert.ToBoolean(isVerified);

            if (!active) return "Blocked";
            if (!verified) return "Pending";
            return "Verified";
        }

        // Event Handlers
        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userID = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "View":
                    ViewUserProfile(userID);
                    break;
                case "Edit":
                    EditUserProfile(userID);
                    break;
                case "Verify":
                    ToggleVerification(userID);
                    break;
                case "Block":
                    ToggleBlockStatus(userID);
                    break;
                case "Delete":
                    DeleteUser(userID);
                    break;
            }
        }

        protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsers.PageIndex = e.NewPageIndex;
            BindUsers();
        }

        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // You can add additional row binding logic here if needed
            }
        }

        // Filter Event Handlers
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            gvUsers.PageIndex = 0;
            BindUsers();
        }

        protected void ddlGender_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvUsers.PageIndex = 0;
            BindUsers();
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvUsers.PageIndex = 0;
            BindUsers();
        }

        protected void ddlCity_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvUsers.PageIndex = 0;
            BindUsers();
        }

        protected void btnApplyFilters_Click(object sender, EventArgs e)
        {
            gvUsers.PageIndex = 0;
            BindUsers();
        }

        protected void btnResetFilters_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlGender.SelectedIndex = 0;
            ddlStatus.SelectedIndex = 0;
            ddlCity.SelectedIndex = 0;
            txtFromDate.Text = "";
            txtToDate.Text = "";
            ddlPageSize.SelectedValue = "25";

            gvUsers.PageIndex = 0;
            BindUsers();
        }

        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvUsers.PageIndex = 0;
            BindUsers();
        }

        // Action Methods
        private void ViewUserProfile(int userID)
        {
            Response.Redirect($"ViewUserProfile.aspx?UserID={userID}");
        }

        private void EditUserProfile(int userID)
        {
            Response.Redirect($"EditUser.aspx?UserID={userID}");
        }

        private void ToggleVerification(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Users SET IsVerified = CASE WHEN IsVerified = 1 THEN 0 ELSE 1 END 
                                   WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                BindUsers();
                LoadStats();
                ShowMessage("User verification status updated successfully.", "success");
            }
            catch (Exception)
            {
                ShowMessage("Error updating verification status", "error");
            }
        }

        private void ToggleBlockStatus(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Users SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END 
                                   WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                BindUsers();
                LoadStats();
                ShowMessage("User block status updated successfully.", "success");
            }
            catch (Exception)
            {
                ShowMessage("Error updating block status", "error");
            }
        }

        private void DeleteUser(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // First, delete related records to maintain referential integrity
                    string[] relatedTables = {
                        "UserPhotos", "UserMemberships", "Interests", "Messages",
                        "Shortlists", "BlockedUsers", "ReportedUsers", "ProfileViews"
                    };

                    foreach (string table in relatedTables)
                    {
                        string deleteQuery = $"DELETE FROM {table} WHERE UserID = @UserID";
                        using (SqlCommand cmd = new SqlCommand(deleteQuery, conn))
                        {
                            if (conn.State != ConnectionState.Open)
                                conn.Open();
                            cmd.Parameters.AddWithValue("@UserID", userID);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    // Finally delete the user
                    string userQuery = "DELETE FROM Users WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(userQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        cmd.ExecuteNonQuery();
                    }
                }
                BindUsers();
                LoadStats();
                ShowMessage("User deleted successfully.", "success");
            }
            catch (Exception)
            {
                ShowMessage("Error deleting user", "error");
            }
        }

        // Export Methods
        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            ExportToExcel();
        }

        protected void btnExportSelected_Click(object sender, EventArgs e)
        {
            ExportSelectedToExcel();
        }

        protected void btnExportAll_Click(object sender, EventArgs e)
        {
            ExportAllToExcel();
        }

        private void ExportToExcel()
        {
            try
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=Users_" + DateTime.Now.ToString("yyyyMMdd") + ".xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-excel";

                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);

                // Create a temporary GridView for export
                GridView gvExport = new GridView();
                gvExport.DataSource = GetExportData();
                gvExport.DataBind();

                // Apply styling
                gvExport.HeaderStyle.BackColor = System.Drawing.Color.LightGray;
                gvExport.HeaderStyle.Font.Bold = true;

                gvExport.RenderControl(hw);

                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
            catch (Exception)
            {
                ShowMessage("Error exporting to Excel", "error");
            }
        }

        private DataTable GetExportData()
        {
            string whereClause = BuildWhereClause();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = $@"
                    SELECT 
                        UserID, Email, FullName, Gender, 
                        DATEDIFF(YEAR, DateOfBirth, GETDATE()) as Age,
                        Occupation, Education, City, State, Religion,
                        CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Blocked' END as Status,
                        CASE WHEN IsVerified = 1 THEN 'Verified' ELSE 'Unverified' END as Verification,
                        CreatedDate
                    FROM Users 
                    {whereClause}
                    ORDER BY CreatedDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    AddParameters(cmd);
                    conn.Open();
                    DataTable dt = new DataTable();
                    dt.Load(cmd.ExecuteReader());
                    return dt;
                }
            }
        }

        private void ExportSelectedToExcel()
        {
            // Implement export for selected users
            ShowMessage("Export selected feature coming soon!", "info");
        }

        private void ExportAllToExcel()
        {
            // Implement export for all users
            ExportToExcel();
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddUser.aspx");
        }

        // Utility Methods
        private void ShowMessage(string message, string type)
        {
            string script = $@"<script>showNotification('{message}', '{type}');</script>";
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowMessage", script, false);
        }
    }
}