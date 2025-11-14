







using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JivanBandhan4
{
    public partial class Membership : System.Web.UI.Page
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
                    LoadCurrentMembershipStatus();
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

        private void LoadCurrentMembershipStatus()
        {
            try
            {
                int userID = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT MembershipType, ExpiryDate 
                                   FROM UserMemberships 
                                   WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
                                   ORDER BY ExpiryDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            string membershipType = reader["MembershipType"].ToString();
                            DateTime expiryDate = Convert.ToDateTime(reader["ExpiryDate"]);

                            lblCurrentPlan.Text = membershipType;
                            pnlCurrentPlan.Visible = true;

                            // Disable button for current plan
                            switch (membershipType.ToLower())
                            {
                                case "free":
                                    btnCurrentFree.Enabled = false;
                                    btnCurrentFree.Text = "🔒 सध्याची योजना";
                                    break;
                                case "silver":
                                    btnSelectSilver.Enabled = false;
                                    btnSelectSilver.Text = "🔒 सध्याची योजना";
                                    break;
                                case "gold":
                                    btnSelectGold.Enabled = false;
                                    btnSelectGold.Text = "🔒 सध्याची योजना";
                                    break;
                                case "platinum":
                                    btnSelectPlatinum.Enabled = false;
                                    btnSelectPlatinum.Text = "🔒 सध्याची योजना";
                                    break;
                            }
                        }
                        else
                        {
                            lblCurrentPlan.Text = "Free";
                            pnlCurrentPlan.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadCurrentMembershipStatus error: " + ex.Message);
                lblCurrentPlan.Text = "Free";
                pnlCurrentPlan.Visible = true;
            }
        }

        protected void btnSelectSilver_Click(object sender, EventArgs e)
        {
            PreparePayment("Silver", 999, "3 महिने");
        }

        protected void btnSelectGold_Click(object sender, EventArgs e)
        {
            PreparePayment("Gold", 1999, "6 महिने");
        }

        protected void btnSelectPlatinum_Click(object sender, EventArgs e)
        {
            PreparePayment("Platinum", 2999, "12 महिने");
        }

        private void PreparePayment(string planName, decimal amount, string duration)
        {
            // Store selected plan in session for payment processing
            Session["SelectedPlan"] = planName;
            Session["PlanAmount"] = amount;
            Session["PlanDuration"] = duration;

            // Show payment modal using JavaScript
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPaymentModal",
                $"showPaymentModal('{planName}', {amount}, '{duration}');", true);
        }

        protected void btnProcessPayment_Click(object sender, EventArgs e)
        {
            if (!chkTerms.Checked)
            {
                ShowErrorMessage("कृपया सेवा अटींशी सहमती दर्शवा");
                return;
            }

            if (string.IsNullOrEmpty(txtCardNumber.Text) || string.IsNullOrEmpty(txtExpiryDate.Text) || string.IsNullOrEmpty(txtCVV.Text))
            {
                ShowErrorMessage("कृपया सर्व पेमेंट तपशील भरा");
                return;
            }

            ProcessMembershipPayment();
        }

        private void ProcessMembershipPayment()
        {
            try
            {
                int userID = Convert.ToInt32(Session["UserID"]);
                string planName = Session["SelectedPlan"]?.ToString();
                decimal amount = Convert.ToDecimal(Session["PlanAmount"]);
                string paymentMethod = ddlPaymentMethod.SelectedValue;

                // Calculate expiry date based on plan
                DateTime expiryDate = DateTime.Now;
                switch (planName)
                {
                    case "Silver":
                        expiryDate = expiryDate.AddMonths(3);
                        break;
                    case "Gold":
                        expiryDate = expiryDate.AddMonths(6);
                        break;
                    case "Platinum":
                        expiryDate = expiryDate.AddMonths(12);
                        break;
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Start transaction
                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            // Update user membership
                            string updateQuery = @"
                                IF EXISTS (SELECT 1 FROM UserMemberships WHERE UserID = @UserID)
                                BEGIN
                                    UPDATE UserMemberships 
                                    SET MembershipType = @MembershipType, 
                                        ExpiryDate = @ExpiryDate,
                                        UpdatedDate = GETDATE()
                                    WHERE UserID = @UserID
                                END
                                ELSE
                                BEGIN
                                    INSERT INTO UserMemberships (UserID, MembershipType, ExpiryDate, CreatedDate)
                                    VALUES (@UserID, @MembershipType, @ExpiryDate, GETDATE())
                                END";

                            using (SqlCommand cmd = new SqlCommand(updateQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userID);
                                cmd.Parameters.AddWithValue("@MembershipType", planName);
                                cmd.Parameters.AddWithValue("@ExpiryDate", expiryDate);
                                cmd.ExecuteNonQuery();
                            }

                            // Record payment
                            string paymentQuery = @"
                                INSERT INTO Payments (UserID, Amount, PaymentMethod, PlanType, TransactionDate, Status)
                                VALUES (@UserID, @Amount, @PaymentMethod, @PlanType, GETDATE(), 'Completed')";

                            using (SqlCommand cmd = new SqlCommand(paymentQuery, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@UserID", userID);
                                cmd.Parameters.AddWithValue("@Amount", amount);
                                cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                                cmd.Parameters.AddWithValue("@PlanType", planName);
                                cmd.ExecuteNonQuery();
                            }

                            // Commit transaction
                            transaction.Commit();

                            // Show success message
                            ShowSuccessMessage($"✅ {planName} योजना यशस्वीरीत्या सक्रिय केली!");

                            // Redirect to dashboard after delay
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "RedirectToDashboard",
                                "setTimeout(function() { window.location.href = 'Dashboard.aspx'; }, 2000);", true);

                            // Hide modal
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal",
                                "$('#paymentModal').modal('hide');", true);
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            System.Diagnostics.Debug.WriteLine("Payment processing error: " + ex.Message);
                            ShowErrorMessage("पेमेंट प्रक्रिया करताना त्रुटी आली. कृपया पुन्हा प्रयत्न करा.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("ProcessMembershipPayment error: " + ex.Message);
                ShowErrorMessage("पेमेंट प्रक्रिया करताना त्रुटी आली. कृपया पुन्हा प्रयत्न करा.");
            }
        }

        protected void btnBackToDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        private void ShowSuccessMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowSuccess",
                $"showSuccess('{message}');", true);
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError",
                $"showError('{message}');", true);
        }

        // नवीन method: Check if user can send message based on membership
        public static bool CanUserSendMessage(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Get user's membership type
                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
                                             FROM UserMemberships 
                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

                    string membershipType = "Free";
                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            membershipType = result.ToString();
                        }
                    }

                    // Check daily message count based on membership
                    string dailyMessagesQuery = @"SELECT COUNT(*) FROM Messages 
                                                WHERE FromUserID = @UserID 
                                                AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)
                                                AND IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(dailyMessagesQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        int messageCount = (int)cmd.ExecuteScalar();

                        // Check limits based on membership type
                        switch (membershipType.ToLower())
                        {
                            case "free":
                                return messageCount < 5; // 5 messages per day
                            case "silver":
                                return messageCount < 10; // 10 messages per day
                            case "gold":
                                return messageCount < 100; // 100 messages per day
                            case "platinum":
                                return true; // Unlimited messages
                            default:
                                return messageCount < 5; // Default to free limit
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CanUserSendMessage error: " + ex.Message);
                return false;
            }
        }

        // नवीन method: Check if user can send interest based on membership
        public static bool CanUserSendInterest(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Get user's membership type
                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
                                             FROM UserMemberships 
                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

                    string membershipType = "Free";
                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            membershipType = result.ToString();
                        }
                    }

                    // Check daily interest count based on membership
                    string dailyInterestsQuery = @"SELECT COUNT(*) FROM Interests 
                                                  WHERE SentByUserID = @UserID 
                                                  AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)";

                    using (SqlCommand cmd = new SqlCommand(dailyInterestsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        int interestCount = (int)cmd.ExecuteScalar();

                        // Check limits based on membership type
                        switch (membershipType.ToLower())
                        {
                            case "free":
                                return interestCount < 2; // 2 interests per day
                            case "silver":
                                return interestCount < 10; // 10 interests per day
                            case "gold":
                                return interestCount < 50; // 50 interests per day
                            case "platinum":
                                return true; // Unlimited interests
                            default:
                                return interestCount < 2; // Default to free limit
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CanUserSendInterest error: " + ex.Message);
                return false;
            }
        }

        // नवीन method: Check if user can view contact number - ONLY FOR PLATINUM
        public static bool CanUserViewContactNumber(int viewerUserID, int profileUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Get viewer's membership type
                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
                                             FROM UserMemberships 
                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

                    string membershipType = "Free";
                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", viewerUserID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            membershipType = result.ToString();
                        }
                    }

                    // ONLY Platinum members can view contact numbers
                    return membershipType.ToLower() == "platinum";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CanUserViewContactNumber error: " + ex.Message);
                return false;
            }
        }

        // नवीन method: Get user's remaining message count
        public static int GetRemainingMessageCount(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Get user's membership type
                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
                                             FROM UserMemberships 
                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

                    string membershipType = "Free";
                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            membershipType = result.ToString();
                        }
                    }

                    // Get daily message count
                    string dailyMessagesQuery = @"SELECT COUNT(*) FROM Messages 
                                                WHERE FromUserID = @UserID 
                                                AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)
                                                AND IsActive = 1";

                    using (SqlCommand cmd = new SqlCommand(dailyMessagesQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        int messageCount = (int)cmd.ExecuteScalar();

                        // Calculate remaining based on membership type
                        switch (membershipType.ToLower())
                        {
                            case "free":
                                return Math.Max(0, 5 - messageCount);
                            case "silver":
                                return Math.Max(0, 10 - messageCount);
                            case "gold":
                                return Math.Max(0, 100 - messageCount);
                            case "platinum":
                                return int.MaxValue; // Unlimited
                            default:
                                return Math.Max(0, 5 - messageCount);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetRemainingMessageCount error: " + ex.Message);
                return 0;
            }
        }

        // नवीन method: Get user's remaining interest count
        public static int GetRemainingInterestCount(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Get user's membership type
                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
                                             FROM UserMemberships 
                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

                    string membershipType = "Free";
                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            membershipType = result.ToString();
                        }
                    }

                    // Get daily interest count
                    string dailyInterestsQuery = @"SELECT COUNT(*) FROM Interests 
                                                  WHERE SentByUserID = @UserID 
                                                  AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)";

                    using (SqlCommand cmd = new SqlCommand(dailyInterestsQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        int interestCount = (int)cmd.ExecuteScalar();

                        // Calculate remaining based on membership type
                        switch (membershipType.ToLower())
                        {
                            case "free":
                                return Math.Max(0, 2 - interestCount);
                            case "silver":
                                return Math.Max(0, 10 - interestCount);
                            case "gold":
                                return Math.Max(0, 50 - interestCount);
                            case "platinum":
                                return int.MaxValue; // Unlimited
                            default:
                                return Math.Max(0, 2 - interestCount);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetRemainingInterestCount error: " + ex.Message);
                return 0;
            }
        }
    }
}















//using System;
//using System.Data;
//using System.Data.SqlClient;
//using System.Web.UI;
//using System.Web.UI.WebControls;

//namespace JivanBandhan4
//{
//    public partial class Membership : System.Web.UI.Page
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
//                    LoadCurrentMembershipStatus();
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


//        private void LoadCurrentMembershipStatus()
//        {
//            try
//            {
//                int userID = Convert.ToInt32(Session["UserID"]);

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    string query = @"SELECT MembershipType, ExpiryDate 
//                                   FROM UserMemberships 
//                                   WHERE UserID = @UserID AND ExpiryDate > GETDATE() 
//                                   ORDER BY ExpiryDate DESC";

//                    using (SqlCommand cmd = new SqlCommand(query, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        SqlDataReader reader = cmd.ExecuteReader();

//                        if (reader.Read())
//                        {
//                            string membershipType = reader["MembershipType"].ToString();
//                            DateTime expiryDate = Convert.ToDateTime(reader["ExpiryDate"]);

//                            lblCurrentPlan.Text = membershipType;
//                            pnlCurrentPlan.Visible = true;

//                            // Disable button for current plan
//                            switch (membershipType.ToLower())
//                            {
//                                case "free":
//                                    btnCurrentFree.Enabled = false;
//                                    btnCurrentFree.Text = "🔒 सध्याची योजना";
//                                    break;
//                                case "silver":
//                                    btnSelectSilver.Enabled = false;
//                                    btnSelectSilver.Text = "🔒 सध्याची योजना";
//                                    break;
//                                case "gold":
//                                    btnSelectGold.Enabled = false;
//                                    btnSelectGold.Text = "🔒 सध्याची योजना";
//                                    break;
//                                case "platinum":
//                                    btnSelectPlatinum.Enabled = false;
//                                    btnSelectPlatinum.Text = "🔒 सध्याची योजना";
//                                    break;
//                            }
//                        }
//                        else
//                        {
//                            lblCurrentPlan.Text = "Free";
//                            pnlCurrentPlan.Visible = true;
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("LoadCurrentMembershipStatus error: " + ex.Message);
//                lblCurrentPlan.Text = "Free";
//                pnlCurrentPlan.Visible = true;
//            }
//        }

//        protected void btnSelectSilver_Click(object sender, EventArgs e)
//        {
//            PreparePayment("Silver", 999, "3 महिने");
//        }

//        protected void btnSelectGold_Click(object sender, EventArgs e)
//        {
//            PreparePayment("Gold", 1999, "6 महिने");
//        }

//        protected void btnSelectPlatinum_Click(object sender, EventArgs e)
//        {
//            PreparePayment("Platinum", 2999, "12 महिने");
//        }

//        private void PreparePayment(string planName, decimal amount, string duration)
//        {
//            // Store selected plan in session for payment processing
//            Session["SelectedPlan"] = planName;
//            Session["PlanAmount"] = amount;
//            Session["PlanDuration"] = duration;

//            // Show payment modal using JavaScript
//            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPaymentModal",
//                $"showPaymentModal('{planName}', {amount}, '{duration}');", true);
//        }

//        protected void btnProcessPayment_Click(object sender, EventArgs e)
//        {
//            if (!chkTerms.Checked)
//            {
//                ShowErrorMessage("कृपया सेवा अटींशी सहमती दर्शवा");
//                return;
//            }

//            if (string.IsNullOrEmpty(txtCardNumber.Text) || string.IsNullOrEmpty(txtExpiryDate.Text) || string.IsNullOrEmpty(txtCVV.Text))
//            {
//                ShowErrorMessage("कृपया सर्व पेमेंट तपशील भरा");
//                return;
//            }

//            ProcessMembershipPayment();
//        }

//        private void ProcessMembershipPayment()
//        {
//            try
//            {
//                int userID = Convert.ToInt32(Session["UserID"]);
//                string planName = Session["SelectedPlan"]?.ToString();
//                decimal amount = Convert.ToDecimal(Session["PlanAmount"]);
//                string paymentMethod = ddlPaymentMethod.SelectedValue;

//                // Calculate expiry date based on plan
//                DateTime expiryDate = DateTime.Now;
//                switch (planName)
//                {
//                    case "Silver":
//                        expiryDate = expiryDate.AddMonths(3);
//                        break;
//                    case "Gold":
//                        expiryDate = expiryDate.AddMonths(6);
//                        break;
//                    case "Platinum":
//                        expiryDate = expiryDate.AddMonths(12);
//                        break;
//                }

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    conn.Open();

//                    // Start transaction
//                    using (SqlTransaction transaction = conn.BeginTransaction())
//                    {
//                        try
//                        {
//                            // Update user membership
//                            string updateQuery = @"
//                                IF EXISTS (SELECT 1 FROM UserMemberships WHERE UserID = @UserID)
//                                BEGIN
//                                    UPDATE UserMemberships 
//                                    SET MembershipType = @MembershipType, 
//                                        ExpiryDate = @ExpiryDate,
//                                        UpdatedDate = GETDATE()
//                                    WHERE UserID = @UserID
//                                END
//                                ELSE
//                                BEGIN
//                                    INSERT INTO UserMemberships (UserID, MembershipType, ExpiryDate, CreatedDate)
//                                    VALUES (@UserID, @MembershipType, @ExpiryDate, GETDATE())
//                                END";

//                            using (SqlCommand cmd = new SqlCommand(updateQuery, conn, transaction))
//                            {
//                                cmd.Parameters.AddWithValue("@UserID", userID);
//                                cmd.Parameters.AddWithValue("@MembershipType", planName);
//                                cmd.Parameters.AddWithValue("@ExpiryDate", expiryDate);
//                                cmd.ExecuteNonQuery();
//                            }

//                            // Record payment
//                            string paymentQuery = @"
//                                INSERT INTO Payments (UserID, Amount, PaymentMethod, PlanType, TransactionDate, Status)
//                                VALUES (@UserID, @Amount, @PaymentMethod, @PlanType, GETDATE(), 'Completed')";

//                            using (SqlCommand cmd = new SqlCommand(paymentQuery, conn, transaction))
//                            {
//                                cmd.Parameters.AddWithValue("@UserID", userID);
//                                cmd.Parameters.AddWithValue("@Amount", amount);
//                                cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
//                                cmd.Parameters.AddWithValue("@PlanType", planName);
//                                cmd.ExecuteNonQuery();
//                            }

//                            // Commit transaction
//                            transaction.Commit();

//                            // Show success message
//                            ShowSuccessMessage($"✅ {planName} योजना यशस्वीरीत्या सक्रिय केली!");

//                            // Redirect to dashboard after delay
//                            ScriptManager.RegisterStartupScript(this, this.GetType(), "RedirectToDashboard",
//                                "setTimeout(function() { window.location.href = 'Dashboard.aspx'; }, 2000);", true);

//                            // Hide modal
//                            ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal",
//                                "$('#paymentModal').modal('hide');", true);
//                        }
//                        catch (Exception ex)
//                        {
//                            transaction.Rollback();
//                            System.Diagnostics.Debug.WriteLine("Payment processing error: " + ex.Message);
//                            ShowErrorMessage("पेमेंट प्रक्रिया करताना त्रुटी आली. कृपया पुन्हा प्रयत्न करा.");
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("ProcessMembershipPayment error: " + ex.Message);
//                ShowErrorMessage("पेमेंट प्रक्रिया करताना त्रुटी आली. कृपया पुन्हा प्रयत्न करा.");
//            }
//        }

//        protected void btnBackToDashboard_Click(object sender, EventArgs e)
//        {
//            Response.Redirect("Dashboard.aspx");
//        }

//        private void ShowSuccessMessage(string message)
//        {
//            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowSuccess",
//                $"showSuccess('{message}');", true);
//        }

//        private void ShowErrorMessage(string message)
//        {
//            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowError",
//                $"showError('{message}');", true);
//        }

//        // नवीन method: Check if user can send message based on membership
//        public static bool CanUserSendMessage(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Get user's membership type
//                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
//                                             FROM UserMemberships 
//                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

//                    string membershipType = "Free";
//                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();
//                        if (result != null)
//                        {
//                            membershipType = result.ToString();
//                        }
//                    }

//                    // Check daily message count based on membership
//                    string dailyMessagesQuery = @"SELECT COUNT(*) FROM Messages 
//                                                WHERE FromUserID = @UserID 
//                                                AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)
//                                                AND IsActive = 1";

//                    using (SqlCommand cmd = new SqlCommand(dailyMessagesQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        int messageCount = (int)cmd.ExecuteScalar();

//                        // Check limits based on membership type
//                        switch (membershipType.ToLower())
//                        {
//                            case "free":
//                                return messageCount < 5; // 5 messages per day
//                            case "silver":
//                                return messageCount < 10; // 10 messages per day
//                            case "gold":
//                                return messageCount < 100; // 100 messages per day
//                            case "platinum":
//                                return true; // Unlimited messages
//                            default:
//                                return messageCount < 5; // Default to free limit
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CanUserSendMessage error: " + ex.Message);
//                return false;
//            }
//        }

//        // नवीन method: Check if user can send interest based on membership
//        public static bool CanUserSendInterest(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Get user's membership type
//                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
//                                             FROM UserMemberships 
//                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

//                    string membershipType = "Free";
//                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();
//                        if (result != null)
//                        {
//                            membershipType = result.ToString();
//                        }
//                    }

//                    // Check daily interest count based on membership
//                    string dailyInterestsQuery = @"SELECT COUNT(*) FROM Interests 
//                                                  WHERE SentByUserID = @UserID 
//                                                  AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)";

//                    using (SqlCommand cmd = new SqlCommand(dailyInterestsQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        int interestCount = (int)cmd.ExecuteScalar();

//                        // Check limits based on membership type
//                        switch (membershipType.ToLower())
//                        {
//                            case "free":
//                                return interestCount < 2; // 2 interests per day
//                            case "silver":
//                                return interestCount < 10; // 10 interests per day
//                            case "gold":
//                                return interestCount < 50; // 50 interests per day
//                            case "platinum":
//                                return true; // Unlimited interests
//                            default:
//                                return interestCount < 2; // Default to free limit
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CanUserSendInterest error: " + ex.Message);
//                return false;
//            }
//        }

//        // नवीन method: Check if user can view contact number
//        public static bool CanUserViewContactNumber(int viewerUserID, int profileUserID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Get viewer's membership type
//                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
//                                             FROM UserMemberships 
//                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

//                    string membershipType = "Free";
//                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", viewerUserID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();
//                        if (result != null)
//                        {
//                            membershipType = result.ToString();
//                        }
//                    }

//                    // Only Silver, Gold, and Platinum members can view contact numbers
//                    return membershipType.ToLower() == "silver" ||
//                           membershipType.ToLower() == "gold" ||
//                           membershipType.ToLower() == "platinum";
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("CanUserViewContactNumber error: " + ex.Message);
//                return false;
//            }
//        }

//        // नवीन method: Get user's remaining message count
//        public static int GetRemainingMessageCount(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Get user's membership type
//                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
//                                             FROM UserMemberships 
//                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

//                    string membershipType = "Free";
//                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();
//                        if (result != null)
//                        {
//                            membershipType = result.ToString();
//                        }
//                    }

//                    // Get daily message count
//                    string dailyMessagesQuery = @"SELECT COUNT(*) FROM Messages 
//                                                WHERE FromUserID = @UserID 
//                                                AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)
//                                                AND IsActive = 1";

//                    using (SqlCommand cmd = new SqlCommand(dailyMessagesQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        int messageCount = (int)cmd.ExecuteScalar();

//                        // Calculate remaining based on membership type
//                        switch (membershipType.ToLower())
//                        {
//                            case "free":
//                                return Math.Max(0, 5 - messageCount);
//                            case "silver":
//                                return Math.Max(0, 10 - messageCount);
//                            case "gold":
//                                return Math.Max(0, 100 - messageCount);
//                            case "platinum":
//                                return int.MaxValue; // Unlimited
//                            default:
//                                return Math.Max(0, 5 - messageCount);
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("GetRemainingMessageCount error: " + ex.Message);
//                return 0;
//            }
//        }

//        // नवीन method: Get user's remaining interest count
//        public static int GetRemainingInterestCount(int userID)
//        {
//            try
//            {
//                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

//                using (SqlConnection conn = new SqlConnection(connectionString))
//                {
//                    // Get user's membership type
//                    string membershipQuery = @"SELECT ISNULL(MembershipType, 'Free') as MembershipType 
//                                             FROM UserMemberships 
//                                             WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

//                    string membershipType = "Free";
//                    using (SqlCommand cmd = new SqlCommand(membershipQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        conn.Open();
//                        object result = cmd.ExecuteScalar();
//                        if (result != null)
//                        {
//                            membershipType = result.ToString();
//                        }
//                    }

//                    // Get daily interest count
//                    string dailyInterestsQuery = @"SELECT COUNT(*) FROM Interests 
//                                                  WHERE SentByUserID = @UserID 
//                                                  AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)";

//                    using (SqlCommand cmd = new SqlCommand(dailyInterestsQuery, conn))
//                    {
//                        cmd.Parameters.AddWithValue("@UserID", userID);
//                        int interestCount = (int)cmd.ExecuteScalar();

//                        // Calculate remaining based on membership type
//                        switch (membershipType.ToLower())
//                        {
//                            case "free":
//                                return Math.Max(0, 2 - interestCount);
//                            case "silver":
//                                return Math.Max(0, 10 - interestCount);
//                            case "gold":
//                                return Math.Max(0, 50 - interestCount);
//                            case "platinum":
//                                return int.MaxValue; // Unlimited
//                            default:
//                                return Math.Max(0, 2 - interestCount);
//                        }
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("GetRemainingInterestCount error: " + ex.Message);
//                return 0;
//            }
//        }
//    }
//}
