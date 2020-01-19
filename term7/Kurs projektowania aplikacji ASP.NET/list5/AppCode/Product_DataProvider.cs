using System.Collections.Generic;
using System.Linq;

namespace ASPNET_Z5
{
    public class Product_DataProvider
    {
        private readonly StoreDataContext db = new StoreDataContext();

        public IEnumerable<Product> GetAll(int limit, int offset, string orderBy)
        {
            // return MOCK_PRODUCTS.Skip(offset).Take(limit);
            IQueryable<Product> query = db.Products;
            switch (orderBy)
            {
                case "Name":
                    query = query.OrderBy(p => p.Name);
                    break;
                case "Price":
                    query = query.OrderBy(p => p.Price);
                    break;
            }
            return query.Skip(offset).Take(limit);
        }
                   

        public int GetNumber() => db.Products.Count();

        public Product GetByID(int id) => db.Products.FirstOrDefault(p => p.ID == id);

        public void Add(Product product)
        {
            db.Products.InsertOnSubmit(product);
            db.SubmitChanges();
        }

        public void Update(Product product)
        {
            var old = GetByID(product.ID);
            old.Name = product.Name;
            old.Description = product.Description;
            old.Price = product.Price;
            old.ImageURL = product.ImageURL;
            db.SubmitChanges();
        }

        public void Delete(int id)
        {
            var product = GetByID(id);
            db.Products.DeleteOnSubmit(product);
            db.SubmitChanges();
        }
    }
}