using System.Collections.Generic;
using Store.Domain.Model.Shipment;
using Store.Infrastructure.Repositories.ShipmentRepository;

namespace Store.Application.Services.ShipmentService
{
    public class ShipmentService : IShipmentService
    {
        private IShipmentRepository ShipmentRepository { get; }

        public ShipmentService()
        {
            ShipmentRepository = new ShipmentRepository();
        }

        public ShipmentService(IShipmentRepository shipmentRepository)
        {
            ShipmentRepository = shipmentRepository;
        }

        public void Add(Shipment shipment)
        {
            var id = ShipmentRepository.Add(shipment);
            shipment.Id = id;
        }

        public Shipment Find(int id)
        {
            return ShipmentRepository.Find(id);
        }

        public IEnumerable<Shipment> FindAll()
        {
            return ShipmentRepository.FindAll();
        }

        public IEnumerable<Shipment> GetPage(int page, int pageSize)
        {
            return ShipmentRepository.GetOrderedPage(page, pageSize, x => x.Id);
        }

        public void Update(Shipment shipment)
        {
            ShipmentRepository.Update(shipment);
        }

        public void Delete(int id)
        {
            ShipmentRepository.Delete(id);
        }
    }
}
