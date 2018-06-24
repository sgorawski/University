using Store.Common;
using Store.Domain.Model.Order;
using System.Collections.Generic;
using System.Linq;

namespace Store.Infrastructure.Repositories.OrderRepository
{
    public class TestOrderRepository : GenericTestRepository<Order>, IOrderRepository
    {
        private ICollection<Order> Orders { get; }

        public TestOrderRepository() : this(new List<Order> {
            new Order { Id = 1, CustomerId = 1, ShipmentId = 1, OrderItems = new HashSet<OrderItem>() },
            new Order { Id = 2, CustomerId = 2, ShipmentId = 2, OrderItems = new HashSet<OrderItem>() },
            new Order { Id = 3, CustomerId = 3, ShipmentId = 3, OrderItems = new HashSet<OrderItem>() }
        }) { }

        private TestOrderRepository(ICollection<Order> orders) : base(orders)
        {
            Orders = orders;
        }

        public IEnumerable<Order> FindAllOfCustomer(int customerId)
        {
            return Orders.Where(o => o.CustomerId == customerId);
        }
    }
}
