using System.Collections.Generic;
using System.Linq;

namespace ASPNET_Z7
{
    public class Product_DataProvider
    {
        private readonly StoreDataContext db = new StoreDataContext();

        public IEnumerable<Models.Product> GetAll(string search, string sort, string sortdir)
        {
            IQueryable<Models.Product> query = db.Products;
            if (search != null)
            {
                query = query.Where(p => p.Name.Contains(search));
            }

            var asc = sortdir == "ASC";
            switch (sort)
            {
                case "Name":
                    query = asc ? query.OrderBy(p => p.Name) : query.OrderByDescending(p => p.Name);
                    break;
                case "Price":
                    query = asc ? query.OrderBy(p => p.Price) : query.OrderByDescending(p => p.Price);
                    break;
            }

            return query;
        }


        public int GetNumber() => db.Products.Count();

        public Models.Product GetByID(int id) => db.Products.FirstOrDefault(p => p.ID == id);

        public void Add(Models.Product product)
        {
            db.Products.InsertOnSubmit(product);
            db.SubmitChanges();
        }

        public void Update(Models.Product product)
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
