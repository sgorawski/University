using Store.Common;
using Store.Domain.Model.Order;
using System.Collections.Generic;

namespace Store.Application.Services.OrderService
{
    public interface IOrderService : IService<Order>
    {
        IEnumerable<Order> FindAllOfCustomer(int customerId);
    }
}
