using System.Collections.Generic;
using System.Linq;
using Store.Common;
using Store.Domain.Model.Product;

namespace Store.Infrastructure.Repositories.ProductRepository
{
    public class TestProductRepository : GenericTestRepository<Product>, IProductRepository
    {
        private ICollection<Product> Products { get; }

        public TestProductRepository() : this(new List<Product> {
            new Product { Id = 1, Description = "test", ImageUrl = "https://test.com", Name = "test", Price = 2137, Quantity = 0},
            new Product { Id = 2, Description = "test", ImageUrl = "https://test.com", Name = "test", Price = 2137, Quantity = 1},
            new Product { Id = 3, Description = "test", ImageUrl = "https://test.com", Name = "test", Price = 2137, Quantity = 2},
        }) { }

        private TestProductRepository(ICollection<Product> products) : base(products)
        {
            Products = products;
        }

        public IEnumerable<Product> FindAllAvailable()
        {
            return Products.Where(p => p.IsAvailable());
        }
    }
}
