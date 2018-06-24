using Store.Common;
using Store.Domain.Model.Shared;
using Store.Domain.Model.Shipment;
using System.Collections.Generic;

namespace Store.Infrastructure.Repositories.ShipmentRepository
{
    public class TestShipmentRepository : GenericTestRepository<Shipment>, IShipmentRepository
    {
        public TestShipmentRepository() : this(new List<Shipment> {
            new Shipment { Id = 1,
                DeliveryAddress = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345"},
                Status = ShipmentStatus.Ready,
                Type = ShipmentType.Air },
            new Shipment { Id = 2,
                DeliveryAddress = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345"},
                Status = ShipmentStatus.Delivered,
                Type = ShipmentType.Land },
            new Shipment { Id = 3,
                DeliveryAddress = new Address { Country = "test", City = "test", Detail = "test", ZipCode = "12-345"},
                Status = ShipmentStatus.InProgress,
                Type = ShipmentType.Naval },
        }) { }

        private TestShipmentRepository(ICollection<Shipment> shipments) : base(shipments) { }
    }
}
