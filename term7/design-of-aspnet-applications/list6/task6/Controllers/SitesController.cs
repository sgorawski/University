using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASPNET_Z6_6.Controllers
{
    public class SitesController : Controller
    {
        private readonly CMSDataContext db = new CMSDataContext();

        // GET: Sites
        public ActionResult Index()
        {
            var path = (string) RouteData.Values["path"];
            var siteNames = new List<string>(path.Split('/'));
            if (!siteNames.Last().EndsWith(".html"))
            {
                siteNames.Add("index.html");
            }
            var site = db.Sites.FirstOrDefault(s => s.SuperSiteID == null);
            if (site == null)
            {
                site = new Models.Site { SuperSiteID = null, Name = "", ContentHTML = "" };
                db.Sites.InsertOnSubmit(site);
                db.SubmitChanges();
            }

            foreach (var name in siteNames)
            {
                site = site.GetSub(name);
            }
            return View(site);
        }
    }
}