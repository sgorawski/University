using System;
using System.Web.Security;

namespace ASPNET_Z5
{
    public partial class LoginPage : System.Web.UI.Page
    {
        protected void Login_Click(object sender, EventArgs e)
        {
            if (Membership.ValidateUser(Username.Text, Password.Text))
            {
                FormsAuthentication.RedirectFromLoginPage(Username.Text, Persist.Checked);
            }
            else
            {
                Msg.Text = "Invalid credentials. Please try again.";
            }
        }
    }
}
