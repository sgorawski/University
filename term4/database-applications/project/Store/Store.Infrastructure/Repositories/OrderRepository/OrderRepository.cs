using System.Collections.Generic;
using Store.Domain.Model.Order;

namespace Store.Infrastructure.Repositories.OrderRepository
{
    public class OrderRepository : NHibernateRepository<Order>, IOrderRepository
    {
        public IEnumerable<Order> FindAllOfCustomer(int customerId)
        {
            using (var s = OpenSession())
            {
                return s.QueryOver<Order>().Where(o => o.CustomerId == customerId).List();
            }
        }
    }
}
