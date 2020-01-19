using Store.Domain.Model.Customer;
using Store.Domain.Model.Shared;

namespace Store.ObjectMothers
{
    public static class CustomerObjectMother
    {
        public static Customer CreateCustomer(int id)
        {
            return new Customer
            {
                Id = id,
                Name = "test",
                Email = "test@test.com",
                Address = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345" }
            };
        }

        public static Customer CreateCustomerWithNoId()
        {
            return new Customer
            {
                Name = "test",
                Email = "test@test.com",
                Address = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345" }
            };
        }
    }
}
