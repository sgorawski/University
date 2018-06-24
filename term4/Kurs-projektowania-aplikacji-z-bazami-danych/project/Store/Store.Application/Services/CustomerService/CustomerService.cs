using System.Collections.Generic;
using Store.Domain.Model.Customer;
using Store.Infrastructure.Repositories.CustomerRepository;

namespace Store.Application.Services.CustomerService
{
    public class CustomerService : ICustomerService
    {
        private ICustomerRepository CustomerRepository { get; }

        public CustomerService()
        {
            CustomerRepository = new CustomerRepository();
        }

        public CustomerService(ICustomerRepository customerRepository)
        {
            CustomerRepository = customerRepository;
        }

        public void Add(Customer customer)
        {
            var id = CustomerRepository.Add(customer);
            customer.Id = id;
        }

        public Customer Find(int id)
        {
            return CustomerRepository.Find(id);
        }

        public IEnumerable<Customer> FindAll()
        {
            return CustomerRepository.FindAll();
        }

        public IEnumerable<Customer> GetPage(int page, int pageSize)
        {
            return CustomerRepository.GetOrderedPage(page, pageSize, x => x.Name);
        }

        public void Update(Customer customer)
        {
            CustomerRepository.Update(customer);
        }

        public void Delete(int id)
        {
            CustomerRepository.Delete(id);
        }
    }
}
