using Store.Common;
using Store.Domain.Model.Customer;
using Store.Domain.Model.Shared;
using System.Collections.Generic;

namespace Store.Infrastructure.Repositories.CustomerRepository
{
    public class TestCustomerRepository : GenericTestRepository<Customer>, ICustomerRepository
    {
        public TestCustomerRepository() : this(new List<Customer> {
            new Customer { Id = 1, Name = "test", Email = "test@test.com",
                Address = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345"}  },
            new Customer { Id = 2, Name = "test", Email = "test@test.com",
                Address = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345"}  },
            new Customer { Id = 3, Name = "test", Email = "test@test.com",
                Address = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345"}  },
        }) { }

        private TestCustomerRepository(ICollection<Customer> customers) : base(customers) { }
    }
}
