using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JivanBandhan4
{
    public partial class Messages : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    int userID = Convert.ToInt32(Session["UserID"]);
                    hdnCurrentUserID.Value = userID.ToString();
                    LoadConversations(userID);

                    // Check if ToUserID is passed in query string
                    if (!string.IsNullOrEmpty(Request.QueryString["ToUserID"]))
                    {
                        int toUserID = Convert.ToInt32(Request.QueryString["ToUserID"]);
                        hdnActiveUserID.Value = toUserID.ToString();
                        LoadActiveChat(userID, toUserID);
                    }
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }

            // Handle AJAX calls - ONLY for specific events
            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (!string.IsNullOrEmpty(eventTarget) && eventTarget == "loadMessages")
            {
                int userID = Convert.ToInt32(hdnCurrentUserID.Value);
                int activeUserID = Convert.ToInt32(eventArgument);
                hdnActiveUserID.Value = activeUserID.ToString();
                LoadActiveChat(userID, activeUserID);
            }
        }

        private void LoadConversations(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        WITH LastMessages AS (
                            SELECT 
                                CASE 
                                    WHEN FromUserID = @UserID THEN ToUserID 
                                    ELSE FromUserID 
                                END AS OtherUserID,
                                MAX(SentDate) AS LastMessageDate
                            FROM Messages 
                            WHERE (FromUserID = @UserID OR ToUserID = @UserID) AND IsActive = 1
                            GROUP BY 
                                CASE 
                                    WHEN FromUserID = @UserID THEN ToUserID 
                                    ELSE FromUserID 
                                END
                        ),
                        UnreadCounts AS (
                            SELECT 
                                FromUserID AS OtherUserID,
                                COUNT(*) AS UnreadCount
                            FROM Messages 
                            WHERE ToUserID = @UserID AND IsRead = 0 AND IsActive = 1
                            GROUP BY FromUserID
                        )
                        SELECT 
                            u.UserID AS OtherUserID,
                            u.FullName,
                            u.City,
                            u.State,
                            u.Occupation,
                            lm.LastMessageDate,
                            (SELECT TOP 1 MessageText FROM Messages 
                             WHERE ((FromUserID = @UserID AND ToUserID = u.UserID) OR 
                                    (FromUserID = u.UserID AND ToUserID = @UserID)) AND IsActive = 1
                             ORDER BY SentDate DESC) AS LastMessage,
                            ISNULL(uc.UnreadCount, 0) AS UnreadCount
                        FROM LastMessages lm
                        INNER JOIN Users u ON lm.OtherUserID = u.UserID
                        LEFT JOIN UnreadCounts uc ON u.UserID = uc.OtherUserID
                        ORDER BY lm.LastMessageDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptConversations.DataSource = dt;
                            rptConversations.DataBind();
                            pnlNoConversations.Visible = false;
                        }
                        else
                        {
                            rptConversations.DataSource = null;
                            rptConversations.DataBind();
                            pnlNoConversations.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadConversations error: " + ex.Message);
                pnlNoConversations.Visible = true;
            }
        }

        private void LoadActiveChat(int currentUserID, int otherUserID)
        {
            try
            {
                // Load user info
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string userQuery = @"
                        SELECT FullName, DateOfBirth, Occupation, City, State 
                        FROM Users WHERE UserID = @UserID";

                    using (SqlCommand userCmd = new SqlCommand(userQuery, conn))
                    {
                        userCmd.Parameters.AddWithValue("@UserID", otherUserID);
                        conn.Open();
                        SqlDataReader userReader = userCmd.ExecuteReader();

                        if (userReader.Read())
                        {
                            lblActiveUserName.Text = userReader["FullName"].ToString();

                            // Age calculation
                            if (userReader["DateOfBirth"] != DBNull.Value)
                            {
                                DateTime dob = Convert.ToDateTime(userReader["DateOfBirth"]);
                                int age = DateTime.Now.Year - dob.Year;
                                if (DateTime.Now.DayOfYear < dob.DayOfYear)
                                    age--;

                                lblActiveUserDetails.Text = $"{age} Years | {userReader["Occupation"]} | {userReader["City"]}, {userReader["State"]}";
                            }
                            else
                            {
                                lblActiveUserDetails.Text = $"{userReader["Occupation"]} | {userReader["City"]}, {userReader["State"]}";
                            }

                            // Load user photo
                            LoadUserPhoto(otherUserID, imgActiveUser);
                        }
                        userReader.Close();

                        // Load messages
                        string messagesQuery = @"
                            SELECT MessageID, FromUserID, ToUserID, MessageText, SentDate, IsRead
                            FROM Messages 
                            WHERE ((FromUserID = @CurrentUserID AND ToUserID = @OtherUserID) OR 
                                   (FromUserID = @OtherUserID AND ToUserID = @CurrentUserID)) 
                                  AND IsActive = 1
                            ORDER BY SentDate ASC";

                        using (SqlCommand messagesCmd = new SqlCommand(messagesQuery, conn))
                        {
                            messagesCmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                            messagesCmd.Parameters.AddWithValue("@OtherUserID", otherUserID);

                            SqlDataReader messagesReader = messagesCmd.ExecuteReader();

                            if (messagesReader.HasRows)
                            {
                                DataTable dt = new DataTable();
                                dt.Load(messagesReader);
                                rptMessages.DataSource = dt;
                                rptMessages.DataBind();
                                pnlNoMessages.Visible = false;

                                // Mark messages as read
                                MarkMessagesAsRead(currentUserID, otherUserID);
                            }
                            else
                            {
                                rptMessages.DataSource = null;
                                rptMessages.DataBind();
                                pnlNoMessages.Visible = true;
                            }
                        }
                    }
                }

                pnlActiveChat.Visible = true;
                pnlNoChatSelected.Visible = false;

                // Set focus to message input
                ScriptManager.RegisterStartupScript(this, this.GetType(), "SetFocus",
                    "setTimeout(function() { document.getElementById('" + txtMessage.ClientID + "').focus(); }, 100);", true);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadActiveChat error: " + ex.Message);
                pnlActiveChat.Visible = false;
                pnlNoChatSelected.Visible = true;
            }
        }

        private void MarkMessagesAsRead(int currentUserID, int otherUserID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Messages 
                        SET IsRead = 1 
                        WHERE FromUserID = @OtherUserID AND ToUserID = @CurrentUserID AND IsRead = 0";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);
                        cmd.Parameters.AddWithValue("@OtherUserID", otherUserID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("MarkMessagesAsRead error: " + ex.Message);
            }
        }

        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtMessage.Text.Trim()))
            {
                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);
                int otherUserID = Convert.ToInt32(hdnActiveUserID.Value);

                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        string query = @"
                            INSERT INTO Messages (FromUserID, ToUserID, MessageText, SentDate, IsRead, IsActive)
                            VALUES (@FromUserID, @ToUserID, @MessageText, GETDATE(), 0, 1)";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@FromUserID", currentUserID);
                            cmd.Parameters.AddWithValue("@ToUserID", otherUserID);
                            cmd.Parameters.AddWithValue("@MessageText", txtMessage.Text.Trim());
                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    // Clear message input
                    txtMessage.Text = "";

                    // Reload messages WITHOUT full page refresh
                    LoadActiveChat(currentUserID, otherUserID);

                    // Reload conversations to update last message (but don't cause full refresh)
                    LoadConversations(currentUserID);

                    ShowNotification("Message sent! Use the above link to view profile.", "success");

                    // Set focus back to message input
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "SetFocusAfterSend",
                        "setTimeout(function() { document.getElementById('" + txtMessage.ClientID + "').focus(); }, 100);", true);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("btnSendMessage_Click error: " + ex.Message);
                    ShowNotification("Error sending message!", "error");
                }
            }
        }

        // Utility Methods
        public string GetUserPhotoUrl(object userID)
        {
            try
            {
                if (userID == null) return ResolveUrl("~/Images/default-profile.jpg");

                int profileUserID = Convert.ToInt32(userID);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID 
                                   ORDER BY 
                                       CASE WHEN PhotoType = 'Profile' THEN 1 ELSE 2 END,
                                       UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", profileUserID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            string path = result.ToString().Trim();
                            return ResolveUrl("~/Uploads/" + profileUserID + "/" + path);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetUserPhotoUrl error: " + ex.Message);
            }

            return ResolveUrl("~/Images/default-profile.jpg");
        }

        private void LoadUserPhoto(int userID, System.Web.UI.WebControls.Image imgControl)
        {
            try
            {
                string photoUrl = GetUserPhotoUrl(userID);
                imgControl.ImageUrl = photoUrl;
                imgControl.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUserPhoto error: " + ex.Message);
                imgControl.ImageUrl = ResolveUrl("~/Images/default-profile.jpg");
            }
        }

        public string FormatTime(object date)
        {
            try
            {
                if (date == null || date == DBNull.Value)
                    return "";

                DateTime messageDate = Convert.ToDateTime(date);
                TimeSpan timeDiff = DateTime.Now - messageDate;

                if (timeDiff.TotalDays >= 1)
                {
                    return messageDate.ToString("dd/MM/yy HH:mm");
                }
                else if (timeDiff.TotalHours >= 1)
                {
                    return $"{(int)timeDiff.TotalHours} hours ago";
                }
                else if (timeDiff.TotalMinutes >= 1)
                {
                    return $"{(int)timeDiff.TotalMinutes} minutes ago";
                }
                else
                {
                    return "Just now";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("FormatTime error: " + ex.Message);
                return "";
            }
        }

        public bool IsSentMessage(int fromUserID)
        {
            int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);
            return fromUserID == currentUserID;
        }

        // Event Handlers
        protected void btnBackToDashboard_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnNewMessage_Click(object sender, EventArgs e)
        {
            Response.Redirect("Search.aspx?message=true");
        }

        // Repeater ItemDataBound events
        protected void rptConversations_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Image imgUser = (Image)e.Item.FindControl("imgUser");
                if (imgUser != null)
                {
                    imgUser.Attributes["onerror"] = "this.src='" + ResolveUrl("~/Images/default-profile.jpg") + "'";
                }
            }
        }

        protected void rptMessages_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // Additional message formatting if needed
        }

        private void ShowNotification(string message, string type)
        {
            string script = $@"<script>showNotification('{message}', '{type}');</script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowNotification", script, false);
        }
    }
}