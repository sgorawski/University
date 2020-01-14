using PagedList;
using System.Web.Mvc;

namespace ASPNET_Z7.Controllers
{
    public class ProductsController : Controller
    {
        private readonly Product_DataProvider products = new Product_DataProvider();
        private const int PAGE_SIZE = 10;

        public ActionResult Index(int? page, string sort, string sortdir, string search)
        {
            ViewBag.sort = sort;
            ViewBag.sortOrder = sortdir;
            ViewBag.searchClause = search;

            var pageNumber = page ?? 1;
            var items = products.GetAll(search, sort, sortdir).ToPagedList(pageNumber, PAGE_SIZE);

            return View(items);
        }

        [Authorize]
        public ActionResult Add() => View("Edit");

        [HttpPost]
        [Authorize]
        public ActionResult Add(Models.Product product)
        {
            products.Add(product);
            return RedirectToAction("Index");
        }

        [Authorize]
        public ActionResult Edit(int id) => View(products.GetByID(id));

        [HttpPost]
        [Authorize]
        public ActionResult Edit(Models.Product product)
        {
            products.Update(product);
            return RedirectToAction("Index");
        }

        [Authorize]
        public ActionResult Delete(int id)
        {
            products.Delete(id);
            return RedirectToAction("Index");
        }
    }
}
