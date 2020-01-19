using System.Collections.Generic;
using Store.Common;

namespace Store.Domain.Model.Product
{
    public interface IProductRepository : IRepository<Product>
    {
        IEnumerable<Product> FindAllAvailable();
    }
}
