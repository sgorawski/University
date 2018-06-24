using System.Collections.Generic;
using Store.Domain.Model.Product;

namespace Store.Infrastructure.Repositories.ProductRepository
{
    public class ProductRepository : NHibernateRepository<Product>, IProductRepository
    {
        public IEnumerable<Product> FindAllAvailable()
        {
            using (var s = OpenSession())
            {
                return s.QueryOver<Product>().Where(p => p.IsAvailable()).List();
            }
        }
    }
}
