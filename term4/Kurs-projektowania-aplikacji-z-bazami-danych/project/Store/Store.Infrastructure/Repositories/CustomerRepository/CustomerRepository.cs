using Store.Domain.Model.Customer;

namespace Store.Infrastructure.Repositories.CustomerRepository
{
    public class CustomerRepository : NHibernateRepository<Customer>, ICustomerRepository { }
}
