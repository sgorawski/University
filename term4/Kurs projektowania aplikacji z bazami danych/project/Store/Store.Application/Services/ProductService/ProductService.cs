using System.Collections.Generic;
using Store.Domain.Model.Product;
using Store.Infrastructure.Repositories.ProductRepository;

namespace Store.Application.Services.ProductService
{
    public class ProductService :  IProductService
    {
        private IProductRepository ProductRepository { get; }

        public ProductService()
        {
            ProductRepository = new ProductRepository();
        }

        public ProductService(IProductRepository productRepository)
        {
            ProductRepository = productRepository;
        }

        public void Add(Product product)
        {
            var id = ProductRepository.Add(product);
            product.Id = id;
        }

        public Product Find(int id)
        {
            return ProductRepository.Find(id);
        }

        public IEnumerable<Product> FindAll()
        {
            return ProductRepository.FindAll();
        }

        public IEnumerable<Product> GetPage(int page, int pageSize)
        {
            return ProductRepository.GetOrderedPage(page, pageSize, x => x.Name);
        }

        public void Update(Product product)
        {
            ProductRepository.Update(product);
        }

        public void Delete(int id)
        {
            ProductRepository.Delete(id);
        }

        public IEnumerable<Product> FindAllAvailable()
        {
            return ProductRepository.FindAllAvailable();
        }

        public IEnumerable<Product> GetPageOrderedByPriceAsc(int page, int pageSize)
        {
            return ProductRepository.GetOrderedPage(page, pageSize, x => x.Price);
        }

        public IEnumerable<Product> GetPageOrderedByPriceDesc(int page, int pageSize)
        {
            return ProductRepository.GetOrderedPage(page, pageSize, x => x.Price, false);
        }
    }
}
