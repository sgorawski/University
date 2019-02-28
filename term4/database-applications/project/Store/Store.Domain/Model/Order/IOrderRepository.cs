using Store.Common;
using System.Collections.Generic;

namespace Store.Domain.Model.Order
{
    public interface IOrderRepository : IRepository<Order>
    {
        IEnumerable<Order> FindAllOfCustomer(int customerId);
    }
}
