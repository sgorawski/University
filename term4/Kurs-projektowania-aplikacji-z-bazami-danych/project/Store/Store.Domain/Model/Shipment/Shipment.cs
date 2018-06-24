using Store.Common;
using Store.Domain.Model.Shared;

namespace Store.Domain.Model.Shipment
{
    public class Shipment : IEntity
    {
        public virtual int Id { get; set; }
        public virtual Address DeliveryAddress { get; set; }
        public virtual ShipmentType Type { get; set; }
        public virtual ShipmentStatus Status { get; set; }
    }
}
