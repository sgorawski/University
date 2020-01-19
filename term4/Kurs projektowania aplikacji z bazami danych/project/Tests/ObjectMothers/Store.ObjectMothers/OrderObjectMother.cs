using System.Collections.Generic;
using Store.Domain.Model.Order;

namespace Store.ObjectMothers
{
    public static class OrderObjectMother
    {
        public static Order CreateEmptyOrder(int id)
        {
            return new Order
            {
                Id = id,
                CustomerId = 1,
                ShipmentId = 1,
                OrderItems = new HashSet<OrderItem>()
            };
        }

        public static Order CreateOrderWithItems(int id)
        {
            return new Order
            {
                Id = id,
                CustomerId = 1,
                ShipmentId = 1,
                OrderItems = new HashSet<OrderItem>
                {
                    new OrderItem { ProductId = 1, ProductPrice = 2137, ProductQuantity = 1 },
                    new OrderItem { ProductId = 2, ProductPrice = 2137, ProductQuantity = 2 }
                }
            };
        }

        public static Order CreateEmptyOrderWithNoId()
        {
            return new Order
            {
                CustomerId = 1,
                ShipmentId = 1,
                OrderItems = new HashSet<OrderItem>()
            };
        }

        public static Order CreateOrderWithItemsWithNoId()
        {
            return new Order
            {
                CustomerId = 1,
                ShipmentId = 1,
                OrderItems = new HashSet<OrderItem>
                {
                    new OrderItem { ProductId = 1, ProductPrice = 2137, ProductQuantity = 1 },
                    new OrderItem { ProductId = 2, ProductPrice = 2137, ProductQuantity = 2 }
                }
            };
        }
    }
}
