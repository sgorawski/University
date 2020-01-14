using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASPNET_Z7
{
    public class ShoppingCart
    {
        private const char SEP = ',';
        private readonly Product_DataProvider dataSource = new Product_DataProvider();

        public IEnumerable<Models.Product> GetAllProducts()
        {
            var idsStr = GetAllProductIdsStr().Split(new[] { SEP }, StringSplitOptions.RemoveEmptyEntries);
            return idsStr.Select(idStr => Convert.ToInt32(idStr))
                .Select(id => dataSource.GetByID(id));
        }

        public void AddProduct(int productID)
        {
            var existing = GetAllProductIdsStr();
            if (existing != "")
            {
                existing += SEP;
            }
            HttpContext.Current.Session["products"] = existing + productID.ToString();
        }

        private string GetAllProductIdsStr()
        {
            var products = HttpContext.Current.Session["products"];
            if (products == null)
            {
                return "";
            }
            return (string)products;
        }
    }
}
