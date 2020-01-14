using System.Web.Mvc;

namespace ASPNET_Z7.Controllers
{
    public class ShoppingCartController : Controller
    {
        private readonly ShoppingCart cart = new ShoppingCart();

        public ActionResult Index() => View(cart.GetAllProducts());

        public ActionResult Add(int productID)
        {
            cart.AddProduct(productID);
            return RedirectToAction("Index");
        }
    }
}
