using System;
using System.Web.Security;

namespace ASPNET_Z4_2
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        void Page_Load(object sender, EventArgs e)
        {
            Welcome.Text = "Hello, " + Context.User.Identity.Name;
        }

        protected void Signout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Response.Redirect("LoginPage.aspx");
        }
    }
}