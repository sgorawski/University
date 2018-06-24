using Store.Common;
using System.Collections.Generic;

namespace Store.Domain.Model.Order
{
    public class Order : IEntity
    {
        public virtual int Id { get; set; }
        public virtual int CustomerId { get; set; }
        public virtual int ShipmentId { get; set; }
        public virtual ISet<OrderItem> OrderItems { get; set; }
    }
}
