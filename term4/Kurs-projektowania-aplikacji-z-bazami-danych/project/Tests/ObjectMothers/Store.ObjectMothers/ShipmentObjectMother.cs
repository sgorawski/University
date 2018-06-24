using Store.Domain.Model.Shared;
using Store.Domain.Model.Shipment;

namespace Store.ObjectMothers
{
    public static class ShipmentObjectMother
    {
        public static Shipment CreateShipment(int id)
        {
            return new Shipment
            {
                Id = id,
                DeliveryAddress = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345" },
                Status = ShipmentStatus.Ready,
                Type = ShipmentType.Air
            };
        }

        public static Shipment CreateShipmentWithNoId()
        {
            return new Shipment
            {
                DeliveryAddress = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345" },
                Status = ShipmentStatus.Ready,
                Type = ShipmentType.Air
            };
        }
    }
}
