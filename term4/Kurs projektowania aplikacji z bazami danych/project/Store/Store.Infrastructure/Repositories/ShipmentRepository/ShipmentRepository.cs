using Store.Domain.Model.Shipment;

namespace Store.Infrastructure.Repositories.ShipmentRepository
{
    public class ShipmentRepository : NHibernateRepository<Shipment>, IShipmentRepository { }
}
