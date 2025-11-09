using System;
using System.Web.UI;

public partial class Home : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Page initialization code if needed
        }
    }

    protected void btnFreeRegister_Click(object sender, EventArgs e)
    {
        Response.Redirect("Register.aspx");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Response.Redirect("Search.aspx");
    }

    protected void btnQuickSearch_Click(object sender, EventArgs e)
    {
        // Simple redirect for now - you can add search parameters later
        Response.Redirect("Search.aspx");
    }

    protected void btnJoinNow_Click(object sender, EventArgs e)
    {
        Response.Redirect("Register.aspx");
    }

    protected void btnContact_Click(object sender, EventArgs e)
    {
        Response.Redirect("Contact.aspx");
    }
}