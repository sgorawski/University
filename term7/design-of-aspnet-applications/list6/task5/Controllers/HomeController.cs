using System;
using System.Web.Mvc;

namespace ASPNET_Z6_5.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            return View("Login_Model");
        }

        [HttpPost]
        public ActionResult Index(Models.User user)
        {
            throw new NotImplementedException();
        }
    }
}