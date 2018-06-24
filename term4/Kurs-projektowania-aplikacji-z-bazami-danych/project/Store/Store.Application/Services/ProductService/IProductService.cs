using System.Collections.Generic;
using Store.Common;
using Store.Domain.Model.Product;

namespace Store.Application.Services.ProductService
{
    public interface IProductService : IService<Product>
    {
        IEnumerable<Product> FindAllAvailable();

        IEnumerable<Product> GetPageOrderedByPriceAsc(int page, int pageSize);

        IEnumerable<Product> GetPageOrderedByPriceDesc(int page, int pageSize);
    }
}
