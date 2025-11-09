using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace JivanBandhan4
{
    public partial class Login : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is already logged in
                if (Session["UserEmail"] != null || User.Identity.IsAuthenticated)
                {
                    Response.Redirect("Dashboard.aspx");
                }

                // Check for logout
                if (Request.QueryString["logout"] == "true")
                {
                    ShowSuccess("You have been successfully logged out.");
                }

                // Check for registration success
                if (Request.QueryString["registered"] == "true")
                {
                    ShowSuccess("Registration successful! Please login to continue.");
                }

                // Set focus to email field
                ScriptManager.RegisterStartupScript(this, this.GetType(), "SetFocus",
                    $"document.getElementById('{txtEmail.ClientID}').focus();", true);
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            // Basic validation
            if (string.IsNullOrEmpty(email))
            {
                ShowError("Please enter your email address");
                txtEmail.Focus();
                return;
            }

            if (string.IsNullOrEmpty(password))
            {
                ShowError("Please enter your password");
                txtPassword.Focus();
                return;
            }

            if (!IsValidEmail(email))
            {
                ShowError("Please enter a valid email address");
                txtEmail.Focus();
                return;
            }

            // Authenticate user
            if (AuthenticateUser(email, password))
            {
                // Create authentication ticket
                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                    1, // version
                    email, // user name
                    DateTime.Now, // issue date
                    DateTime.Now.AddMinutes(1440), // expiration (24 hours)
                    chkRemember.Checked, // persistent
                    GetUserID(email).ToString(), // user data
                    FormsAuthentication.FormsCookiePath);

                // Encrypt the ticket
                string encryptedTicket = FormsAuthentication.Encrypt(ticket);

                // Create cookie
                HttpCookie authCookie = new HttpCookie(
                    FormsAuthentication.FormsCookieName,
                    encryptedTicket);

                if (chkRemember.Checked)
                    authCookie.Expires = ticket.Expiration;

                // Add cookie to response
                Response.Cookies.Add(authCookie);

                // SET SESSION VARIABLES
                Session["UserEmail"] = email;
                Session["UserID"] = GetUserID(email);
                Session["UserName"] = GetUserName(email);
                Session["LastActivity"] = DateTime.Now;

                // Update last active time in database
                UpdateLastActive(email);

                // Log login activity
                LogLoginActivity(email);

                // Redirect to dashboard
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                ShowError("Invalid email or password. Please try again.");
                // Clear password field on error
                txtPassword.Text = "";
                txtPassword.Focus();

                // Log failed login attempt
                LogFailedLoginAttempt(email);
            }
        }

        private bool AuthenticateUser(string email, string password)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // SECURITY IMPROVEMENT: Consider using password hashing in production
                    string query = "SELECT UserID, Password, FullName, IsActive FROM Users WHERE Email = @Email";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            // Check if account is active
                            bool isActive = Convert.ToBoolean(reader["IsActive"]);
                            if (!isActive)
                            {
                                ShowError("Your account has been deactivated. Please contact support.");
                                return false;
                            }

                            string storedPassword = reader["Password"].ToString();
                            // Direct string comparison - SIMPLE PASSWORD CHECK
                            // SECURITY NOTE: In production, use proper password hashing
                            bool passwordMatch = password == storedPassword;

                            if (passwordMatch)
                            {
                                // Store user name in session for later use
                                Session["UserFullName"] = reader["FullName"].ToString();
                            }

                            return passwordMatch;
                        }
                        else
                        {
                            // User not found
                            return false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Debug.WriteLine($"Login error: {ex.Message}");
                ShowError("Login process error. Please try again.");
                return false;
            }
        }

        private int GetUserID(string email)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT UserID FROM Users WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }

        private string GetUserName(string email)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT FullName FROM Users WHERE Email = @Email";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return result != null ? result.ToString() : string.Empty;
                }
            }
        }

        private void UpdateLastActive(string email)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string updateQuery = "UPDATE Users SET LastActive = GETDATE() WHERE Email = @Email";
                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                    {
                        updateCmd.Parameters.AddWithValue("@Email", email);
                        conn.Open();
                        updateCmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't break login
                System.Diagnostics.Debug.WriteLine($"UpdateLastActive error: {ex.Message}");
            }
        }

        private void LogLoginActivity(string email)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO LoginLogs (UserEmail, LoginTime, IPAddress, UserAgent) 
                                   VALUES (@UserEmail, GETDATE(), @IPAddress, @UserAgent)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserEmail", email);
                        cmd.Parameters.AddWithValue("@IPAddress", GetClientIPAddress());
                        cmd.Parameters.AddWithValue("@UserAgent", Request.UserAgent ?? string.Empty);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't break login
                System.Diagnostics.Debug.WriteLine($"LogLoginActivity error: {ex.Message}");
            }
        }

        private void LogFailedLoginAttempt(string email)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO FailedLoginAttempts (Email, AttemptTime, IPAddress) 
                                   VALUES (@Email, GETDATE(), @IPAddress)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@IPAddress", GetClientIPAddress());

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"LogFailedLoginAttempt error: {ex.Message}");
            }
        }

        private string GetClientIPAddress()
        {
            string ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (string.IsNullOrEmpty(ipAddress))
            {
                ipAddress = Request.ServerVariables["REMOTE_ADDR"];
            }

            return ipAddress ?? "Unknown";
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            lblError.Text = message;
            pnlSuccess.Visible = false;

            // Auto hide after 5 seconds
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideError",
                $"setTimeout(function() {{ document.getElementById('{pnlError.ClientID}').style.display = 'none'; }}, 5000);", true);
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            lblSuccess.Text = message;
            pnlError.Visible = false;

            // Auto hide after 5 seconds
            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideSuccess",
                $"setTimeout(function() {{ document.getElementById('{pnlSuccess.ClientID}').style.display = 'none'; }}, 5000);", true);
        }

        // Session timeout check
        protected void CheckSessionTimeout()
        {
            if (Session["LastActivity"] != null)
            {
                DateTime lastActivity = (DateTime)Session["LastActivity"];
                if (DateTime.Now.Subtract(lastActivity).Minutes > 20) // 20 minutes timeout
                {
                    Session.Abandon();
                    FormsAuthentication.SignOut();
                    Response.Redirect("Login.aspx?timeout=true");
                }
            }
            Session["LastActivity"] = DateTime.Now;
        }
    }
}






















//using System;
//using System.Data;
//using System.Data.SqlClient;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;

//namespace JivanBandhan4
//{
//    public partial class Login : System.Web.UI.Page
//    {
//        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                // Check if user is already logged in
//                if (Session["UserEmail"] != null || User.Identity.IsAuthenticated)
//                {
//                    Response.Redirect("Dashboard.aspx");
//                }

//                // Check for logout
//                if (Request.QueryString["logout"] == "true")
//                {
//                    ShowSuccess("You have been successfully logged out.");
//                }

//                // Check for registration success
//                if (Request.QueryString["registered"] == "true")
//                {
//                    ShowSuccess("Registration successful! Please login to continue.");
//                }

//                // Set focus to email field
//                ScriptManager.RegisterStartupScript(this, this.GetType(), "SetFocus",
//                    $"document.getElementById('{txtEmail.ClientID}').focus();", true);
//            }
//        }

//        protected void btnLogin_Click(object sender, EventArgs e)
//        {
//            string email = txtEmail.Text.Trim();
//            string password = txtPassword.Text;

//            // Basic validation
//            if (string.IsNullOrEmpty(email))
//            {
//                ShowError("Please enter your email address");
//                txtEmail.Focus();
//                return;
//            }

//            if (string.IsNullOrEmpty(password))
//            {
//                ShowError("Please enter your password");
//                txtPassword.Focus();
//                return;
//            }

//            if (!IsValidEmail(email))
//            {
//                ShowError("Please enter a valid email address");
//                txtEmail.Focus();
//                return;
//            }

//            // Authenticate user
//            if (AuthenticateUser(email, password))
//            {
//                // Create authentication ticket
//                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
//                    1, // version
//                    email, // user name
//                    DateTime.Now, // issue date
//                    DateTime.Now.AddMinutes(1440), // expiration (24 hours)
//                    chkRemember.Checked, // persistent
//                    GetUserID(email).ToString(), // user data
//                    FormsAuthentication.FormsCookiePath);

//                // Encrypt the ticket
//                string encryptedTicket = FormsAuthentication.Encrypt(ticket);

//                // Create cookie
//                HttpCookie authCookie = new HttpCookie(
//                    FormsAuthentication.FormsCookieName,
//                    encryptedTicket);

//                if (chkRemember.Checked)
//                    authCookie.Expires = ticket.Expiration;

//                // Add cookie to response
//                Response.Cookies.Add(authCookie);

//                // SET SESSION VARIABLES
//                Session["UserEmail"] = email;
//                Session["UserID"] = GetUserID(email);
//                Session["UserName"] = GetUserName(email);
//                Session["LastActivity"] = DateTime.Now;

//                // Update last active time in database
//                UpdateLastActive(email);

//                // Log login activity
//                LogLoginActivity(email);

//                // Redirect to dashboard
//                Response.Redirect("Dashboard.aspx");
//            }
//            else
//            {
//                ShowError("Invalid email or password. Please try again.");
//                // Clear password field on error
//                txtPassword.Text = "";
//                txtPassword.Focus();

//                // Log failed login attempt
//                LogFailedLoginAttempt(email);
//            }
//        }

//        private bool AuthenticateUser(string email, string password)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // SECURITY IMPROVEMENT: Consider using password hashing in production
//                    string query = "SELECT UserID, Password, FullName, IsActive FROM Users WHERE Email = @Email";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@Email", email);

//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            // Check if account is active
//                            bool isActive = Convert.ToBoolean(reader["IsActive"]);
//                            if (!isActive)
//                            {
//                                ShowError("Your account has been deactivated. Please contact support.");
//                                return false;
//                            }

//                            string storedPassword = reader["Password"].ToString();
//                            // Direct string comparison - SIMPLE PASSWORD CHECK
//                            // SECURITY NOTE: In production, use proper password hashing
//                            bool passwordMatch = password == storedPassword;

//                            if (passwordMatch)
//                            {
//                                // Store user name in session for later use
//                                Session["UserFullName"] = reader["FullName"].ToString();
//                            }

//                            return passwordMatch;
//                        }
//                        else
//                        {
//                            // User not found
//                            return false;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log the error
//                System.Diagnostics.Debug.WriteLine($"Login error: {ex.Message}");
//                ShowError("Login process error. Please try again.");
//                return false;
//            }
//        }

//        private int GetUserID(string email)
//        {
//            using (SqlConnection conn = new SqlConnection(connectionString))
//            {
//                string query = "SELECT UserID FROM Users WHERE Email = @Email";

//                using (SqlCommand cmd = new SqlCommand(query, conn))
//                {
//                    cmd.Parameters.AddWithValue("@Email", email);

//                    conn.Open();
//                    object result = cmd.ExecuteScalar();
//                    return result != null ? Convert.ToInt32(result) : 0;
//                }
//            }
//        }

//        private string GetUserName(string email)
//        {
//            using (SqlConnection conn = new SqlConnection(connectionString))
//            {
//                string query = "SELECT FullName FROM Users WHERE Email = @Email";

//                using (SqlCommand cmd = new SqlCommand(query, conn))
//                {
//                    cmd.Parameters.AddWithValue("@Email", email);

//                    conn.Open();
//                    object result = cmd.ExecuteScalar();
//                    return result != null ? result.ToString() : string.Empty;
//                }
//            }
//        }

//        private void UpdateLastActive(string email)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string updateQuery = "UPDATE Users SET LastActive = GETDATE() WHERE Email = @Email";
//                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
//                    {
//                        updateCmd.Parameters.AddWithValue("@Email", email);
//                        conn.Open();
//                        updateCmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error but don't break login
//                System.Diagnostics.Debug.WriteLine($"UpdateLastActive error: {ex.Message}");
//            }
//        }

//        private void LogLoginActivity(string email)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"INSERT INTO LoginLogs (UserEmail, LoginTime, IPAddress, UserAgent) 
//                                   VALUES (@UserEmail, GETDATE(), @IPAddress, @UserAgent)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserEmail", email);
//                        cmd.Parameters.AddWithValue("@IPAddress", GetClientIPAddress());
//                        cmd.Parameters.AddWithValue("@UserAgent", Request.UserAgent ?? string.Empty);

//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Log error but don't break login
//                System.Diagnostics.Debug.WriteLine($"LogLoginActivity error: {ex.Message}");
//            }
//        }

//        private void LogFailedLoginAttempt(string email)
//        {
//            try
//            {
//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"INSERT INTO FailedLoginAttempts (Email, AttemptTime, IPAddress) 
//                                   VALUES (@Email, GETDATE(), @IPAddress)";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@Email", email);
//                        cmd.Parameters.AddWithValue("@IPAddress", GetClientIPAddress());

//                        conn.Open();
//                        cmd.ExecuteNonQuery();
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine($"LogFailedLoginAttempt error: {ex.Message}");
//            }
//        }

//        private string GetClientIPAddress()
//        {
//            string ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

//            if (string.IsNullOrEmpty(ipAddress))
//            {
//                ipAddress = Request.ServerVariables["REMOTE_ADDR"];
//            }

//            return ipAddress ?? "Unknown";
//        }

//        private bool IsValidEmail(string email)
//        {
//            try
//            {
//                var addr = new System.Net.Mail.MailAddress(email);
//                return addr.Address == email;
//            }
//            catch
//            {
//                return false;
//            }
//        }

//        private void ShowError(string message)
//        {
//            pnlError.Visible = true;
//            lblError.Text = message;
//            pnlSuccess.Visible = false;

//            // Auto hide after 5 seconds
//            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideError",
//                $"setTimeout(function() {{ document.getElementById('{pnlError.ClientID}').style.display = 'none'; }}, 5000);", true);
//        }

//        private void ShowSuccess(string message)
//        {
//            pnlSuccess.Visible = true;
//            lblSuccess.Text = message;
//            pnlError.Visible = false;

//            // Auto hide after 5 seconds
//            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideSuccess",
//                $"setTimeout(function() {{ document.getElementById('{pnlSuccess.ClientID}').style.display = 'none'; }}, 5000);", true);
//        }

//        // Auto-login for demo accounts (optional feature)
//        protected void AutoLoginDemoAccount(string email, string password)
//        {
//            txtEmail.Text = email;
//            txtPassword.Text = password;
//            btnLogin_Click(null, null);
//        }

//        // Session timeout check
//        protected void CheckSessionTimeout()
//        {
//            if (Session["LastActivity"] != null)
//            {
//                DateTime lastActivity = (DateTime)Session["LastActivity"];
//                if (DateTime.Now.Subtract(lastActivity).Minutes > 20) // 20 minutes timeout
//                {
//                    Session.Abandon();
//                    FormsAuthentication.SignOut();
//                    Response.Redirect("Login.aspx?timeout=true");
//                }
//            }
//            Session["LastActivity"] = DateTime.Now;
//        }
//    }
//}