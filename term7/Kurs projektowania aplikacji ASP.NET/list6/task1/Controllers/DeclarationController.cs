using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASPNET_Z6.Controllers
{
    public class DeclarationController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            return View(new Models.Declaration());
        }

        [HttpPost]
        public ActionResult Index(Models.Declaration declaration)
        {
            if (ModelState.IsValid)
            {
                return View("Render", declaration);
            }
            return View();
        }
    }
}