using Store.Domain.Model.Product;

namespace Store.ObjectMothers
{
    public static class ProductObjectMother
    {
        public static Product CreateAvailableProduct(int id)
        {
            return new Product
            {
                Id = id,
                Description = "test",
                ImageUrl = "https://test.com",
                Name = "test",
                Price = 2137,
                Quantity = 2137
            };
        }

        public static Product CreateUnavailableProduct(int id)
        {
            return new Product
            {
                Id = id,
                Description = "test",
                ImageUrl = "https://test.com",
                Name = "test",
                Price = 2137,
                Quantity = 0
            };
        }

        public static Product CreateProductWithNoId()
        {
            return new Product
            {
                Description = "test",
                ImageUrl = "https://test.com",
                Name = "test",
                Price = 2137,
                Quantity = 2137
            };
        }
    }
}
