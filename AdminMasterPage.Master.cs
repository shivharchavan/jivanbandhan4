using System;
using System.Web.UI;

namespace JivanBandhan4.Admin
{
    public partial class AdminMasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["AdminUserID"] == null)
                {
                    Response.Redirect("AdminLogin.aspx");
                    return;
                }

                // Set admin user info
                lblAdminUserName.Text = Session["AdminName"]?.ToString() ?? "Admin";
                lblAdminRole.Text = Session["AdminRole"]?.ToString() ?? "Super Admin";
                lblHeaderAdminName.Text = Session["AdminName"]?.ToString() ?? "Admin";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear session
            Session.Clear();
            Session.Abandon();

            // Redirect to login page
            Response.Redirect("AdminLogin.aspx");
        }
    }
}