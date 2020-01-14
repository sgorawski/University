using System;
using System.Web.Security;

namespace ASPNET_Z5
{
    public partial class RegisterPage : System.Web.UI.Page
    {
        protected void Register_Click(object sender, EventArgs e)
        {
            try
            {
                Membership.CreateUser(Username.Text, Password.Text, Email.Text);
                FormsAuthentication.RedirectToLoginPage();
            }
            catch (MembershipCreateUserException exc)
            {
                Msg.Text = "Error: " + exc.Message;
            }
        }
    }
}