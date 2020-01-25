using Store.Domain.Model.Order;
using System.Collections.Generic;
using Store.Infrastructure.Repositories.OrderRepository;

namespace Store.Application.Services.OrderService
{
    public class OrderService : IOrderService
    {
        private IOrderRepository OrderRepository { get; }

        public OrderService()
        {
            OrderRepository = new OrderRepository();
        }

        public OrderService(IOrderRepository orderRepository)
        {
            OrderRepository = orderRepository;
        }

        public void Add(Order order)
        {
            var id = OrderRepository.Add(order);
            order.Id = id;
        }

        public Order Find(int id)
        {
            return OrderRepository.Find(id);
        }

        public IEnumerable<Order> FindAll()
        {
            return OrderRepository.FindAll();
        }

        public IEnumerable<Order> GetPage(int page, int pageSize)
        {
            return OrderRepository.GetOrderedPage(page, pageSize, x => x.Id);
        }

        public void Update(Order order)
        {
            OrderRepository.Update(order);
        }

        public void Delete(int id)
        {
            OrderRepository.Delete(id);
        }

        public IEnumerable<Order> FindAllOfCustomer(int customerId)
        {
            return OrderRepository.FindAllOfCustomer(customerId);
        }
    }
}
