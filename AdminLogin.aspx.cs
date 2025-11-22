using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace JivanBandhan4.Admin
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if already logged in
                if (Session["AdminUserID"] != null)
                {
                    Response.Redirect("AdminDashboard.aspx");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both username and password";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT AdminUserID, Username, FullName, Role 
                                   FROM AdminUsers 
                                   WHERE Username = @Username AND Password = @Password AND IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", password); // In production, use hashed passwords

                        conn.Open();
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Login successful
                                Session["AdminUserID"] = reader["AdminUserID"];
                                Session["AdminName"] = reader["FullName"];
                                Session["AdminRole"] = reader["Role"];
                                Session["AdminUsername"] = reader["Username"];

                                // Update last login
                                UpdateLastLogin(Convert.ToInt32(reader["AdminUserID"]));

                                // Redirect to dashboard
                                Response.Redirect("AdminDashboard.aspx");
                            }
                            else
                            {
                                lblMessage.Text = "Invalid username or password";
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                lblMessage.Text = "An error occurred. Please try again.";
            }
        }

        private void UpdateLastLogin(int adminUserID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE AdminUsers SET LastLogin = GETDATE() WHERE AdminUserID = @AdminUserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AdminUserID", adminUserID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception)
            {
                // Silently handle error
            }
        }
    }
}