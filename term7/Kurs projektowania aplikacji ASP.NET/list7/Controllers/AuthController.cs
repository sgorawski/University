using System.Web.Mvc;
using System.Web.Security;

namespace ASPNET_Z7.Controllers
{
    public class AuthController : Controller
    {
        public ActionResult Login() => View();

        [HttpPost]
        public ActionResult Login(string Username, string Password)
        {
            if (Membership.ValidateUser(Username, Password))
            {
                FormsAuthentication.RedirectFromLoginPage(Username, false);
            }
            return View();
        }

        public ActionResult Register() => View();

        [HttpPost]
        public ActionResult Register(string Username, string Email, string Password)
        {
            try
            {
                Membership.CreateUser(Username, Password, Email);
                FormsAuthentication.RedirectToLoginPage();
            }
            catch (MembershipCreateUserException)
            {
                // TODO
            }
            return View();
        }

        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", controllerName: "Products");
        }
    }
}
