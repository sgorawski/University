package dbapp.project.application.shipment

import dbapp.project.common.GenericService
import dbapp.project.domain.shipment.Shipment
import dbapp.project.domain.shipment.ShipmentRepository

class ShipmentServiceImpl(shipmentRepository: ShipmentRepository) :
        GenericService<Shipment>(shipmentRepository), ShipmentService