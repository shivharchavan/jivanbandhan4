using System;
using System.Web.UI;

namespace JivanBandhan4
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string lookingFor = ddlLookingFor.SelectedValue;
            string religion = ddlReligion.SelectedValue;
            string age = ddlAge.SelectedValue;

            string queryString = "?";

            if (!string.IsNullOrEmpty(lookingFor))
                queryString += $"gender={lookingFor}&";

            if (!string.IsNullOrEmpty(religion))
                queryString += $"religion={religion}&";

            if (!string.IsNullOrEmpty(age))
                queryString += $"age={age}&";

            Response.Redirect($"BrowseProfiles.aspx{queryString}");
        }
    }
}