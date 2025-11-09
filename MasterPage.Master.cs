using System;
using System.Web;
using System.Web.UI;

namespace JivanBandhan4
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CheckUserLoginStatus();
                SetLanguageText();
            }
        }

        private void CheckUserLoginStatus()
        {
            if (Session["UserID"] != null)
            {
                pnlLoggedIn.Visible = true;
                pnlLoggedOut.Visible = false;
                lblUserName.Text = Session["UserName"] != null ? Session["UserName"].ToString() : "User";
            }
            else
            {
                pnlLoggedIn.Visible = false;
                pnlLoggedOut.Visible = true;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }

        protected void btnLanguage_Click(object sender, EventArgs e)
        {
            // Toggle between Marathi and English
            if (Session["CurrentLanguage"] == null || Session["CurrentLanguage"].ToString() == "en")
            {
                Session["CurrentLanguage"] = "mr"; // Marathi
            }
            else
            {
                Session["CurrentLanguage"] = "en"; // English
            }

            // Refresh the current page to apply language changes
            Response.Redirect(Request.Url.AbsoluteUri);
        }

        private void SetLanguageText()
        {
            string currentLanguage = Session["CurrentLanguage"] != null ? Session["CurrentLanguage"].ToString() : "en";

            if (currentLanguage == "mr")
            {
                // Marathi Text
                btnLanguage.Text = "English";
                litBrandName.Text = "जीवनबंधन मॅट्रिमनी";
                litHome.Text = "मुख्यपृष्ठ";
                litBrowseProfiles.Text = "प्रोफाइल ब्राउझ करा";
                litMembership.Text = "सदस्यत्व";
                litContact.Text = "संपर्क";
                litDashboard.Text = "डॅशबोर्ड";
                litMyProfile.Text = "माझे प्रोफाइल";
                litSettings.Text = "सेटिंग्ज";
                litLogout.Text = "लॉगआउट";
                litLogin.Text = "लॉगिन";
                litRegister.Text = "नोंदणी";
                litFooterBrand.Text = "जीवनबंधन मॅट्रिमनी";
                litFooterTagline.Text = "विश्वास आणि समर्पणासह तुमचा आदर्श जोडीदार शोधा";
                litQuickLinks.Text = "द्रुत लिंक";
                litAboutUs.Text = "आमच्याबद्दल";
                litSuccessStories.Text = "यशस्त्री";
                litPrivacy.Text = "गोपनीयता धोरण";
                litTerms.Text = "वापराच्या अटी";
                litContactFooter.Text = "संपर्क";
                litAddress.Text = "पुणे, महाराष्ट्र";
                litCopyright.Text = "जीवनबंधन मॅट्रिमनी. सर्व हक्क राखीव.";

                // JavaScript वापरून font class add करा
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AddMarathiFont",
                    "document.body.className += ' marathi-font';", true);
            }
            else
            {
                // English Text
                btnLanguage.Text = "मराठी";
                litBrandName.Text = "JivanBandhan Matrimony";
                litHome.Text = "Home";
                litBrowseProfiles.Text = "Browse Profiles";
                litMembership.Text = "Membership";
                litContact.Text = "Contact";
                litDashboard.Text = "Dashboard";
                litMyProfile.Text = "My Profile";
                litSettings.Text = "Settings";
                litLogout.Text = "Logout";
                litLogin.Text = "Login";
                litRegister.Text = "Register";
                litFooterBrand.Text = "JivanBandhan Matrimony";
                litFooterTagline.Text = "Find your ideal partner with trust and dedication";
                litQuickLinks.Text = "Quick Links";
                litAboutUs.Text = "About Us";
                litSuccessStories.Text = "Success Stories";
                litPrivacy.Text = "Privacy Policy";
                litTerms.Text = "Terms of Use";
                litContactFooter.Text = "Contact";
                litAddress.Text = "Pune, Maharashtra";
                litCopyright.Text = "JivanBandhan Matrimony. All rights reserved.";

                // JavaScript वापरून font class remove करा
                ScriptManager.RegisterStartupScript(this, this.GetType(), "RemoveMarathiFont",
                    "document.body.className = document.body.className.replace('marathi-font', '').trim();", true);
            }
        }
    }
}























//using System;
//using System.Web.UI;

//namespace JivanBandhan4
//{
//    public partial class MasterPage : System.Web.UI.MasterPage
//    {
//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (!IsPostBack)
//            {
//                CheckUserLoginStatus();
//            }
//        }

//        private void CheckUserLoginStatus()
//        {
//            if (Session["UserID"] != null)
//            {
//                pnlLoggedIn.Visible = true;
//                pnlLoggedOut.Visible = false;
//                lblUserName.Text = Session["UserName"] != null ? Session["UserName"].ToString() : "User";
//            }
//            else
//            {
//                pnlLoggedIn.Visible = false;
//                pnlLoggedOut.Visible = true;
//            }
//        }

//        protected void btnLogout_Click(object sender, EventArgs e)
//        {
//            Session.Clear();
//            Session.Abandon();
//            Response.Redirect("Default.aspx");
//        }
//    }
//}
















