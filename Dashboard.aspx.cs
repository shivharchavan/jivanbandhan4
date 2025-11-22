
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
    public partial class Dashboard : System.Web.UI.Page
    {
        string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    int userID = Convert.ToInt32(Session["UserID"]);
                    LoadCurrentUserProfile(userID);
                    LoadOppositeGenderProfiles();
                    LoadRealTimeStats(userID);
                    BindFilterDropdowns();
                    LoadMembershipInfo(userID);
                    LoadNotificationCounts(userID);
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadCurrentUserProfile(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT UserID, Email, FullName, Gender, DateOfBirth, Occupation, 
                                   City, State, Education, Religion, CreatedDate, Phone,
                                   DATEDIFF(YEAR, DateOfBirth, GETDATE()) as Age
                                   FROM Users 
                                   WHERE UserID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            lblUserName.Text = reader["FullName"].ToString();
                            lblUserFullName.Text = reader["FullName"].ToString();

                            if (reader["DateOfBirth"] != DBNull.Value)
                            {
                                DateTime dob = Convert.ToDateTime(reader["DateOfBirth"]);
                                int age = DateTime.Now.Year - dob.Year;
                                string occupation = reader["Occupation"] != DBNull.Value ? reader["Occupation"].ToString() : "Not specified";
                                lblUserAgeOccupation.Text = $"{age} Years | {occupation}";
                            }

                            string city = reader["City"] != DBNull.Value ? reader["City"].ToString() : "";
                            string state = reader["State"] != DBNull.Value ? reader["State"].ToString() : "";
                            lblUserLocation.Text = $"{city}, {state}";

                            if (reader["CreatedDate"] != DBNull.Value)
                            {
                                DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
                                lblMemberSince.Text = createdDate.ToString("MMM yyyy");
                            }

                            hdnCurrentUserID.Value = userID.ToString();
                            hdnCurrentUserGender.Value = reader["Gender"].ToString();

                            LoadUserProfilePhoto(userID, imgUserPhoto);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadCurrentUserProfile error: " + ex.Message);
            }
        }

        private void LoadRealTimeStats(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // 1. Total Profile Views - ProfileViews table मधून
                    string totalViewsQuery = @"SELECT COUNT(DISTINCT ViewedByUserID) 
                                              FROM ProfileViews 
                                              WHERE UserID = @UserID";
                    using (SqlCommand totalViewsCmd = new SqlCommand(totalViewsQuery, conn))
                    {
                        totalViewsCmd.Parameters.AddWithValue("@UserID", userID);
                        int totalViews = (int)totalViewsCmd.ExecuteScalar();
                        lblTotalViews.Text = totalViews.ToString();
                        lblProfileViews.Text = totalViews.ToString();
                    }

                    // 2. Total Interests Received - Interests table मधून
                    string totalInterestsQuery = @"SELECT COUNT(*) 
                                                  FROM Interests 
                                                  WHERE TargetUserID = @UserID AND Status = 'Pending'";
                    using (SqlCommand totalInterestsCmd = new SqlCommand(totalInterestsQuery, conn))
                    {
                        totalInterestsCmd.Parameters.AddWithValue("@UserID", userID);
                        int totalInterests = (int)totalInterestsCmd.ExecuteScalar();
                        lblTotalInterests.Text = totalInterests.ToString();
                        lblInterestsReceived.Text = totalInterests.ToString();
                    }

                    // 3. Today's Matches - mutual interests for today
                    string todayMatchesQuery = @"SELECT COUNT(DISTINCT i.SentByUserID) 
                                                FROM Interests i
                                                INNER JOIN Interests i2 ON i.SentByUserID = i2.TargetUserID 
                                                                        AND i.TargetUserID = i2.SentByUserID
                                                WHERE i.TargetUserID = @UserID 
                                                AND CAST(i.SentDate AS DATE) = CAST(GETDATE() AS DATE)";
                    using (SqlCommand todayMatchesCmd = new SqlCommand(todayMatchesQuery, conn))
                    {
                        todayMatchesCmd.Parameters.AddWithValue("@UserID", userID);
                        int todayMatches = (int)todayMatchesCmd.ExecuteScalar();
                        lblTodayMatches.Text = todayMatches.ToString();
                    }

                    // 4. New Messages - unread messages from Messages table
                    string newMessagesQuery = @"SELECT COUNT(*) 
                                              FROM Messages 
                                              WHERE ToUserID = @UserID AND IsRead = 0 AND IsActive = 1";
                    using (SqlCommand newMessagesCmd = new SqlCommand(newMessagesQuery, conn))
                    {
                        newMessagesCmd.Parameters.AddWithValue("@UserID", userID);
                        int newMessages = (int)newMessagesCmd.ExecuteScalar();
                        lblNewMessages.Text = newMessages.ToString();
                    }

                    // 5. Interests Sent - तुम्ही किती interests पाठवले
                    string interestsSentQuery = @"SELECT COUNT(*) 
                                                 FROM Interests 
                                                 WHERE SentByUserID = @UserID";
                    using (SqlCommand interestsSentCmd = new SqlCommand(interestsSentQuery, conn))
                    {
                        interestsSentCmd.Parameters.AddWithValue("@UserID", userID);
                        int interestsSent = (int)interestsSentCmd.ExecuteScalar();
                        lblInterestsSent.Text = interestsSent.ToString();
                    }

                    // 6. Total Messages - सर्व messages sent and received
                    string totalMessagesQuery = @"SELECT COUNT(*) 
                                                FROM Messages 
                                                WHERE (FromUserID = @UserID OR ToUserID = @UserID) 
                                                AND IsActive = 1";
                    using (SqlCommand totalMessagesCmd = new SqlCommand(totalMessagesQuery, conn))
                    {
                        totalMessagesCmd.Parameters.AddWithValue("@UserID", userID);
                        int totalMessages = (int)totalMessagesCmd.ExecuteScalar();
                        lblMessages.Text = totalMessages.ToString();
                    }

                    // 7. Total Profile Clicks (नवीन)
                    string totalClicksQuery = @"SELECT COUNT(*) 
                                              FROM ProfileViews 
                                              WHERE UserID = @UserID";
                    using (SqlCommand totalClicksCmd = new SqlCommand(totalClicksQuery, conn))
                    {
                        totalClicksCmd.Parameters.AddWithValue("@UserID", userID);
                        int totalClicks = (int)totalClicksCmd.ExecuteScalar();
                        // You can display this in a new label if needed
                    }
                }
            }
            catch (Exception ex)
            {
                // Set default values in case of error
                lblTotalViews.Text = "0";
                lblTotalInterests.Text = "0";
                lblTodayMatches.Text = "0";
                lblNewMessages.Text = "0";
                lblProfileViews.Text = "0";
                lblInterestsReceived.Text = "0";
                lblInterestsSent.Text = "0";
                lblMessages.Text = "0";
                System.Diagnostics.Debug.WriteLine("LoadRealTimeStats error: " + ex.Message);
            }
        }

        private void LoadNotificationCounts(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Unread Interests Count - Notifications table मधून
                    string unreadInterestsQuery = @"SELECT COUNT(*) 
                                                   FROM Notifications 
                                                   WHERE UserID = @UserID 
                                                   AND NotificationType = 'Interest'
                                                   AND IsRead = 0";
                    using (SqlCommand unreadInterestsCmd = new SqlCommand(unreadInterestsQuery, conn))
                    {
                        unreadInterestsCmd.Parameters.AddWithValue("@UserID", userID);
                        int unreadInterests = (int)unreadInterestsCmd.ExecuteScalar();

                        HtmlGenericControl interestNotification = (HtmlGenericControl)FindControl("interestNotification");
                        if (interestNotification != null)
                        {
                            if (unreadInterests > 0)
                            {
                                interestNotification.InnerText = unreadInterests.ToString();
                                interestNotification.Style["display"] = "block";
                            }
                            else
                            {
                                interestNotification.Style["display"] = "none";
                            }
                        }
                    }

                    // Unread Messages Count - Notifications table मधून
                    string unreadMessagesQuery = @"SELECT COUNT(*) 
                                                  FROM Notifications 
                                                  WHERE UserID = @UserID 
                                                  AND NotificationType = 'Message'
                                                  AND IsRead = 0";
                    using (SqlCommand unreadMessagesCmd = new SqlCommand(unreadMessagesQuery, conn))
                    {
                        unreadMessagesCmd.Parameters.AddWithValue("@UserID", userID);
                        int unreadMessages = (int)unreadMessagesCmd.ExecuteScalar();

                        HtmlGenericControl messageNotification = (HtmlGenericControl)FindControl("messageNotification");
                        if (messageNotification != null)
                        {
                            if (unreadMessages > 0)
                            {
                                messageNotification.InnerText = unreadMessages.ToString();
                                messageNotification.Style["display"] = "block";
                            }
                            else
                            {
                                messageNotification.Style["display"] = "none";
                            }
                        }
                    }

                    // Total Unread Notifications (for bell icon)
                    string totalUnreadQuery = @"SELECT COUNT(*) FROM Notifications 
                                               WHERE UserID = @UserID AND IsRead = 0";
                    using (SqlCommand totalUnreadCmd = new SqlCommand(totalUnreadQuery, conn))
                    {
                        totalUnreadCmd.Parameters.AddWithValue("@UserID", userID);
                        int totalUnread = (int)totalUnreadCmd.ExecuteScalar();

                        HtmlGenericControl totalNotificationBadge = (HtmlGenericControl)FindControl("totalNotificationBadge");
                        if (totalNotificationBadge != null)
                        {
                            if (totalUnread > 0)
                            {
                                totalNotificationBadge.InnerText = totalUnread.ToString();
                                totalNotificationBadge.Style["display"] = "block";
                            }
                            else
                            {
                                totalNotificationBadge.Style["display"] = "none";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadNotificationCounts error: " + ex.Message);
            }
        }

        private void LoadMembershipInfo(int userID)
        {
            try
            {
                string membershipType = "Free";
                DateTime? expiryDate = null;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 MembershipType, ExpiryDate 
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
                            membershipType = reader["MembershipType"].ToString();
                            expiryDate = Convert.ToDateTime(reader["ExpiryDate"]);
                        }
                    }
                }

                lblMembershipStatus.Text = membershipType;
                hdnCurrentUserMembership.Value = membershipType;

                HtmlGenericControl membershipBadge = (HtmlGenericControl)FindControl("membershipBadge");
                if (membershipBadge != null)
                {
                    membershipBadge.InnerText = membershipType;
                    membershipBadge.Attributes["class"] = $"membership-status membership-{membershipType.ToLower()}";
                }

                HtmlGenericControl userMembershipTag = (HtmlGenericControl)FindControl("userMembershipTag");
                if (userMembershipTag != null)
                {
                    userMembershipTag.InnerText = membershipType;
                    userMembershipTag.Attributes["class"] = $"membership-tag tag-{membershipType.ToLower()}";
                }

                pnlUpgradePrompt.Visible = (membershipType == "Free");

                int remainingMessagesCount = GetRemainingMessageCount(userID);
                int remainingInterestsCount = GetRemainingInterestCount(userID);

                Label remainingMessagesControl = (Label)pnlMembershipInfo.FindControl("remainingMessages");
                Label remainingInterestsControl = (Label)pnlMembershipInfo.FindControl("remainingInterests");

                if (remainingMessagesControl != null)
                    remainingMessagesControl.Text = remainingMessagesCount.ToString();

                if (remainingInterestsControl != null)
                    remainingInterestsControl.Text = remainingInterestsCount.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadMembershipInfo error: " + ex.Message);
            }
        }

        public static int GetRemainingMessageCount(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
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
                            return 999;
                        }
                    }

                    string limitQuery = @"SELECT ISNULL(MAX(DailyMessageLimit), 10) FROM UserMemberships 
                                        WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

                    using (SqlCommand limitCmd = new SqlCommand(limitQuery, conn))
                    {
                        limitCmd.Parameters.AddWithValue("@UserID", userID);
                        int dailyLimit = (int)limitCmd.ExecuteScalar();

                        string todayCountQuery = @"SELECT COUNT(*) FROM Messages 
                                                 WHERE FromUserID = @UserID 
                                                 AND CAST(SentDate AS DATE) = CAST(GETDATE() AS DATE)
                                                 AND IsActive = 1";

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
                return 5;
            }
        }

        public static int GetRemainingInterestCount(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
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
                            return 999;
                        }
                    }

                    string limitQuery = @"SELECT ISNULL(MAX(DailyInterestLimit), 5) FROM UserMemberships 
                                        WHERE UserID = @UserID AND ExpiryDate > GETDATE()";

                    using (SqlCommand limitCmd = new SqlCommand(limitQuery, conn))
                    {
                        limitCmd.Parameters.AddWithValue("@UserID", userID);
                        int dailyLimit = (int)limitCmd.ExecuteScalar();

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
                return 2;
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

        private void LoadUserProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsActive = 1
                                   ORDER BY IsProfilePhoto DESC, UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            string photoPath = result.ToString();
                            imgControl.ImageUrl = "~/Uploads/" + userID + "/" + photoPath;
                        }
                        else
                        {
                            imgControl.ImageUrl = "~/Images/default-profile.jpg";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                imgControl.ImageUrl = "~/Images/default-profile.jpg";
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

        public string GetMembershipTagClass(object membershipType)
        {
            if (membershipType == null || membershipType == DBNull.Value)
                return "tag-free";

            string type = membershipType.ToString().ToLower();
            return $"tag-{type}";
        }

        private void LoadOppositeGenderProfiles()
        {
            try
            {
                string currentUserGender = hdnCurrentUserGender.Value;
                if (string.IsNullOrEmpty(currentUserGender))
                {
                    pnlNoProfiles.Visible = true;
                    return;
                }

                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT TOP 12 
                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
                            u.Education, u.Caste, u.Religion, u.Gender, u.Phone,
                            ISNULL(um.MembershipType, 'Free') as MembershipType,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
                                 THEN 1 ELSE 0 END as IsPremium
                        FROM Users u
                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
                        WHERE u.Gender = @Gender 
                        AND u.UserID != @CurrentUserID
                        AND u.IsActive = 1
                        AND u.UserID NOT IN (
                            SELECT BlockedUserID FROM BlockedUsers WHERE BlockedByUserID = @CurrentUserID
                            UNION
                            SELECT BlockedByUserID FROM BlockedUsers WHERE BlockedUserID = @CurrentUserID
                        )
                        ORDER BY NEWID()";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Gender", oppositeGender);
                        cmd.Parameters.AddWithValue("@CurrentUserID", currentUserID);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            rptProfiles.DataSource = dt;
                            rptProfiles.DataBind();
                            pnlNoProfiles.Visible = false;
                        }
                        else
                        {
                            rptProfiles.DataSource = null;
                            rptProfiles.DataBind();
                            pnlNoProfiles.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlNoProfiles.Visible = true;
            }
        }

        protected void rptProfiles_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == System.Web.UI.WebControls.ListItemType.Item ||
                e.Item.ItemType == System.Web.UI.WebControls.ListItemType.AlternatingItem)
            {
                System.Web.UI.WebControls.Image imgProfile = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgProfile");
                HtmlGenericControl profileHeaderBackground = (HtmlGenericControl)e.Item.FindControl("profileHeaderBackground");
                HtmlGenericControl profileMembershipTag = (HtmlGenericControl)e.Item.FindControl("profileMembershipTag");
                HtmlGenericControl contactNumberDisplay = (HtmlGenericControl)e.Item.FindControl("contactNumberDisplay");
                HtmlGenericControl contactLocked = (HtmlGenericControl)e.Item.FindControl("contactLocked");
                HtmlButton btnViewContact = (HtmlButton)e.Item.FindControl("btnViewContact");

                if (imgProfile != null && profileHeaderBackground != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    int profileUserID = Convert.ToInt32(row["UserID"]);

                    string photoUrl = LoadProfilePhoto(profileUserID, imgProfile);

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

                if (profileMembershipTag != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    string membershipType = row["MembershipType"].ToString();
                    profileMembershipTag.InnerText = membershipType;
                    profileMembershipTag.Attributes["class"] = $"membership-tag tag-{membershipType.ToLower()}";
                }

                if (contactNumberDisplay != null && contactLocked != null && btnViewContact != null)
                {
                    string currentUserMembership = hdnCurrentUserMembership.Value;
                    bool canViewContact = currentUserMembership == "Silver" || currentUserMembership == "Gold" || currentUserMembership == "Platinum";

                    if (canViewContact)
                    {
                        contactNumberDisplay.Style["display"] = "none";
                        contactLocked.Style["display"] = "none";
                        btnViewContact.Style["display"] = "block";

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
                        contactNumberDisplay.Style["display"] = "none";
                        contactLocked.Style["display"] = "block";
                        btnViewContact.Style["display"] = "block";
                    }
                }

                Literal ltAge = (Literal)e.Item.FindControl("ltAge");
                if (ltAge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ltAge.Text = CalculateAgeInline(row["DateOfBirth"]);
                }

                HtmlGenericControl premiumBadge = (HtmlGenericControl)e.Item.FindControl("premiumBadge");
                if (premiumBadge != null)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    bool isPremium = Convert.ToBoolean(row["IsPremium"]);
                    premiumBadge.Visible = isPremium;
                }
            }
        }

        private string LoadProfilePhoto(int userID, System.Web.UI.WebControls.Image imgControl)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT TOP 1 PhotoPath FROM UserPhotos 
                                   WHERE UserID = @UserID AND IsActive = 1
                                   ORDER BY IsProfilePhoto DESC, UploadDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value && !string.IsNullOrEmpty(result.ToString()))
                        {
                            string photoPath = result.ToString();
                            string resolvedPath = ResolveUrl("~/Uploads/" + userID + "/" + photoPath);
                            imgControl.ImageUrl = resolvedPath;
                            return resolvedPath;
                        }
                        else
                        {
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

        private void BindFilterDropdowns()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Bind Cities
                    string cityQuery = @"SELECT DISTINCT City FROM Users 
                                       WHERE City IS NOT NULL AND City <> '' 
                                       ORDER BY City";
                    using (SqlCommand cityCmd = new SqlCommand(cityQuery, conn))
                    {
                        SqlDataReader cityReader = cityCmd.ExecuteReader();
                        ddlCity.Items.Clear();
                        ddlCity.Items.Add(new ListItem("All Cities", ""));
                        while (cityReader.Read())
                        {
                            ddlCity.Items.Add(new ListItem(cityReader["City"].ToString(), cityReader["City"].ToString()));
                        }
                        cityReader.Close();
                    }

                    // Bind Education
                    string educationQuery = @"SELECT DISTINCT Education FROM Users 
                                            WHERE Education IS NOT NULL AND Education <> '' 
                                            ORDER BY Education";
                    using (SqlCommand educationCmd = new SqlCommand(educationQuery, conn))
                    {
                        SqlDataReader educationReader = educationCmd.ExecuteReader();
                        ddlEducation.Items.Clear();
                        ddlEducation.Items.Add(new ListItem("All Education", ""));
                        while (educationReader.Read())
                        {
                            ddlEducation.Items.Add(new ListItem(educationReader["Education"].ToString(), educationReader["Education"].ToString()));
                        }
                        educationReader.Close();
                    }

                    // Bind Occupation
                    string occupationQuery = @"SELECT DISTINCT Occupation FROM Users 
                                             WHERE Occupation IS NOT NULL AND Occupation <> '' 
                                             ORDER BY Occupation";
                    using (SqlCommand occupationCmd = new SqlCommand(occupationQuery, conn))
                    {
                        SqlDataReader occupationReader = occupationCmd.ExecuteReader();
                        ddlOccupation.Items.Clear();
                        ddlOccupation.Items.Add(new ListItem("All Occupation", ""));
                        while (occupationReader.Read())
                        {
                            ddlOccupation.Items.Add(new ListItem(occupationReader["Occupation"].ToString(), occupationReader["Occupation"].ToString()));
                        }
                        occupationReader.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("BindFilterDropdowns error: " + ex.Message);
            }
        }

        [WebMethod]
        public static string SendInterest(int sentByUserID, int targetUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                if (!CanUserSendInterest(sentByUserID))
                {
                    return "limit_reached";
                }

                if (IsBlocked(sentByUserID, targetUserID))
                {
                    return "blocked";
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string checkQuery = "SELECT COUNT(*) FROM Interests WHERE SentByUserID = @SentByUserID AND TargetUserID = @TargetUserID";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@SentByUserID", sentByUserID);
                        checkCmd.Parameters.AddWithValue("@TargetUserID", targetUserID);
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
                            // Create notification for the target user
                            CreateNotification(targetUserID, sentByUserID, "Interest", "ने तुमच्यावर रस दाखवला आहे");
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

                if (!CanUserSendMessage(fromUserID))
                {
                    return "limit_reached";
                }

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
                            // Create notification for the recipient
                            CreateNotification(toUserID, fromUserID, "Message", "ने तुम्हाला एक संदेश पाठवला आहे");
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
                            // Create notification for the shortlisted user
                            CreateNotification(shortlistedUserID, userID, "Shortlist", "ने तुम्हाला शॉर्टलिस्ट केले आहे");
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
        public static string BlockUser(int blockedByUserID, int blockedUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
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
                            // Create notification for profile view
                            CreateNotification(profileUserID, viewerUserID, "ProfileView", "ने तुमचे प्रोफाइल पाहिले");
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
        public static string TrackProfileClick(int viewerUserID, int profileUserID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO ProfileViews (UserID, ViewedByUserID, ViewedDate) 
                                   VALUES (@UserID, @ViewedByUserID, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", profileUserID);
                        cmd.Parameters.AddWithValue("@ViewedByUserID", viewerUserID);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Create notification for profile view
                            CreateNotification(profileUserID, viewerUserID, "ProfileView", "ने तुमचे प्रोफाइल पाहिले");
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

        // Helper method to create notifications
        private static void CreateNotification(int userID, int fromUserID, string notificationType, string messageSuffix)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // Get the from user's name
                    string userNameQuery = "SELECT FullName FROM Users WHERE UserID = @FromUserID";
                    string fromUserName = "";

                    using (SqlCommand userNameCmd = new SqlCommand(userNameQuery, conn))
                    {
                        userNameCmd.Parameters.AddWithValue("@FromUserID", fromUserID);
                        conn.Open();
                        object result = userNameCmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            fromUserName = result.ToString();
                        }
                        else
                        {
                            fromUserName = "एक वापरकर्ता";
                        }
                    }

                    string message = fromUserName + " " + messageSuffix;

                    string insertQuery = @"INSERT INTO Notifications (UserID, FromUserID, NotificationType, Message, IsRead, CreatedDate)
                                         VALUES (@UserID, @FromUserID, @NotificationType, @Message, 0, GETDATE())";

                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@UserID", userID);
                        insertCmd.Parameters.AddWithValue("@FromUserID", fromUserID);
                        insertCmd.Parameters.AddWithValue("@NotificationType", notificationType);
                        insertCmd.Parameters.AddWithValue("@Message", message);
                        insertCmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error but don't break the main functionality
                System.Diagnostics.Debug.WriteLine("CreateNotification error: " + ex.Message);
            }
        }

        [WebMethod]
        public static string GetNotifications(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";
                List<NotificationItem> notifications = new List<NotificationItem>();

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            n.NotificationID,
                            n.NotificationType,
                            n.Message,
                            n.CreatedDate,
                            n.IsRead,
                            n.FromUserID,
                            u.FullName as FromUserName
                        FROM Notifications n
                        LEFT JOIN Users u ON n.FromUserID = u.UserID
                        WHERE n.UserID = @UserID
                        ORDER BY n.CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                notifications.Add(new NotificationItem
                                {
                                    NotificationID = reader.GetInt32(0),
                                    Type = reader.GetString(1),
                                    Message = reader.GetString(2),
                                    TimeAgo = GetTimeAgo(reader.GetDateTime(3)),
                                    IsRead = reader.GetBoolean(4),
                                    RelatedUserID = reader.GetInt32(5),
                                    FromUserName = reader["FromUserName"] != DBNull.Value ? reader["FromUserName"].ToString() : "एक वापरकर्ता"
                                });
                            }
                        }
                    }
                }

                var result = new
                {
                    Notifications = notifications,
                    UnreadInterests = notifications.Count(n => !n.IsRead && n.Type == "Interest"),
                    UnreadMessages = notifications.Count(n => !n.IsRead && n.Type == "Message"),
                    TotalUnread = notifications.Count(n => !n.IsRead)
                };

                return JsonConvert.SerializeObject(result);
            }
            catch (Exception ex)
            {
                var errorResult = new
                {
                    Notifications = new List<NotificationItem>(),
                    UnreadInterests = 0,
                    UnreadMessages = 0,
                    TotalUnread = 0
                };
                return JsonConvert.SerializeObject(errorResult);
            }
        }

        [WebMethod]
        public static string MarkNotificationAsRead(int notificationID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Notifications SET IsRead = 1 WHERE NotificationID = @NotificationID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@NotificationID", notificationID);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        return "success";
                    }
                }
            }
            catch (Exception ex)
            {
                return "error";
            }
        }

        [WebMethod]
        public static string MarkAllNotificationsAsRead(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Notifications SET IsRead = 1 WHERE UserID = @UserID AND IsRead = 0";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        return "success";
                    }
                }
            }
            catch (Exception ex)
            {
                return "error";
            }
        }

        [WebMethod]
        public static string RefreshNotificationCounts(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    int unreadInterests = 0;
                    int unreadMessages = 0;
                    int totalUnread = 0;

                    // Unread Interests Count
                    string unreadInterestsQuery = @"SELECT COUNT(*) 
                                                   FROM Notifications 
                                                   WHERE UserID = @UserID 
                                                   AND NotificationType = 'Interest'
                                                   AND IsRead = 0";
                    using (SqlCommand unreadInterestsCmd = new SqlCommand(unreadInterestsQuery, conn))
                    {
                        unreadInterestsCmd.Parameters.AddWithValue("@UserID", userID);
                        unreadInterests = (int)unreadInterestsCmd.ExecuteScalar();
                    }

                    // Unread Messages Count
                    string unreadMessagesQuery = @"SELECT COUNT(*) 
                                                  FROM Notifications 
                                                  WHERE UserID = @UserID 
                                                  AND NotificationType = 'Message'
                                                  AND IsRead = 0";
                    using (SqlCommand unreadMessagesCmd = new SqlCommand(unreadMessagesQuery, conn))
                    {
                        unreadMessagesCmd.Parameters.AddWithValue("@UserID", userID);
                        unreadMessages = (int)unreadMessagesCmd.ExecuteScalar();
                    }

                    // Total Unread
                    string totalUnreadQuery = @"SELECT COUNT(*) FROM Notifications 
                                               WHERE UserID = @UserID AND IsRead = 0";
                    using (SqlCommand totalUnreadCmd = new SqlCommand(totalUnreadQuery, conn))
                    {
                        totalUnreadCmd.Parameters.AddWithValue("@UserID", userID);
                        totalUnread = (int)totalUnreadCmd.ExecuteScalar();
                    }

                    var result = new
                    {
                        UnreadInterests = unreadInterests,
                        UnreadMessages = unreadMessages,
                        TotalUnread = totalUnread
                    };

                    return JsonConvert.SerializeObject(result);
                }
            }
            catch (Exception ex)
            {
                var errorResult = new
                {
                    UnreadInterests = 0,
                    UnreadMessages = 0,
                    TotalUnread = 0
                };
                return JsonConvert.SerializeObject(errorResult);
            }
        }

        [WebMethod]
        public static string MarkInterestsAsRead(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Notifications SET IsRead = 1 
                                   WHERE UserID = @UserID 
                                   AND NotificationType = 'Interest'
                                   AND IsRead = 0";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        return "success";
                    }
                }
            }
            catch (Exception ex)
            {
                return "error";
            }
        }

        [WebMethod]
        public static string MarkMessagesAsRead(int userID)
        {
            try
            {
                string connectionString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=jivanbandhan;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Notifications SET IsRead = 1 
                                   WHERE UserID = @UserID 
                                   AND NotificationType = 'Message'
                                   AND IsRead = 0";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        return "success";
                    }
                }
            }
            catch (Exception ex)
            {
                return "error";
            }
        }

        private static string GetTimeAgo(DateTime date)
        {
            TimeSpan timeSince = DateTime.Now - date;
            if (timeSince.TotalMinutes < 1)
                return "आत्ताच";
            if (timeSince.TotalMinutes < 60)
                return $"{(int)timeSince.TotalMinutes} मिनिटांपूर्वी";
            if (timeSince.TotalHours < 24)
                return $"{(int)timeSince.TotalHours} तासांपूर्वी";
            return $"{(int)timeSince.TotalDays} दिवसांपूर्वी";
        }

        public class NotificationItem
        {
            public int NotificationID { get; set; }
            public string Type { get; set; }
            public string Message { get; set; }
            public string TimeAgo { get; set; }
            public bool IsRead { get; set; }
            public int RelatedUserID { get; set; }
            public string FromUserName { get; set; }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadOppositeGenderProfilesWithFilters();
        }

        private void LoadOppositeGenderProfilesWithFilters()
        {
            try
            {
                string currentUserGender = hdnCurrentUserGender.Value;
                if (string.IsNullOrEmpty(currentUserGender))
                {
                    pnlNoProfiles.Visible = true;
                    return;
                }

                string oppositeGender = currentUserGender == "Male" ? "Female" : "Male";
                int currentUserID = Convert.ToInt32(hdnCurrentUserID.Value);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    StringBuilder query = new StringBuilder(@"
                        SELECT 
                            u.UserID, u.FullName, u.DateOfBirth, u.Occupation, u.City, u.State, 
                            u.Education, u.Caste, u.Religion, u.Gender, u.Phone,
                            ISNULL(um.MembershipType, 'Free') as MembershipType,
                            DATEDIFF(YEAR, u.DateOfBirth, GETDATE()) as Age,
                            CASE WHEN um.MembershipType IS NOT NULL AND um.ExpiryDate > GETDATE() 
                                 THEN 1 ELSE 0 END as IsPremium
                        FROM Users u
                        LEFT JOIN UserMemberships um ON u.UserID = um.UserID AND um.ExpiryDate > GETDATE()
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

                    // City Filter
                    if (!string.IsNullOrEmpty(ddlCity.SelectedValue))
                    {
                        query.Append(" AND u.City = @City");
                        parameters.Add(new SqlParameter("@City", ddlCity.SelectedValue));
                    }

                    // Education Filter
                    if (!string.IsNullOrEmpty(ddlEducation.SelectedValue))
                    {
                        query.Append(" AND u.Education = @Education");
                        parameters.Add(new SqlParameter("@Education", ddlEducation.SelectedValue));
                    }

                    // Religion Filter
                    if (!string.IsNullOrEmpty(ddlReligion.SelectedValue))
                    {
                        query.Append(" AND u.Religion = @Religion");
                        parameters.Add(new SqlParameter("@Religion", ddlReligion.SelectedValue));
                    }

                    // Occupation Filter
                    if (!string.IsNullOrEmpty(ddlOccupation.SelectedValue))
                    {
                        query.Append(" AND u.Occupation = @Occupation");
                        parameters.Add(new SqlParameter("@Occupation", ddlOccupation.SelectedValue));
                    }

                    query.Append(" ORDER BY NEWID()");

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
                            pnlNoProfiles.Visible = false;
                        }
                        else
                        {
                            rptProfiles.DataSource = null;
                            rptProfiles.DataBind();
                            pnlNoProfiles.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlNoProfiles.Visible = true;
                System.Diagnostics.Debug.WriteLine("LoadOppositeGenderProfilesWithFilters error: " + ex.Message);
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtAgeFrom.Text = "";
            txtAgeTo.Text = "";
            ddlCity.SelectedIndex = 0;
            ddlEducation.SelectedIndex = 0;
            ddlReligion.SelectedIndex = 0;
            ddlOccupation.SelectedIndex = 0;
            LoadOppositeGenderProfiles();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}

