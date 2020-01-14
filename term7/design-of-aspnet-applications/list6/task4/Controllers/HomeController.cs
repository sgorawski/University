using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace ASPNET_Z6_4.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            if (!HttpContext.User.Identity.IsAuthenticated)
            {
                return View("IndexNoAuth");
            }
            if (HttpContext.User.IsInRole("admin"))
            {
                return View("IndexAdmin", HttpContext.User);
            }
            return View("IndexAuth", HttpContext.User);
        }

        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(string Username, string Password)
        {
            if (Membership.ValidateUser(Username, Password))
            {
                FormsAuthentication.RedirectFromLoginPage(Username, false);
            }
            return View();
        }

        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Index");
        }
    }
}