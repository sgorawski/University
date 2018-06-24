package dbapp.project.infrastructure.test

import dbapp.project.common.GenericTestRepository
import dbapp.project.domain.shared.Address
import dbapp.project.domain.shipment.Shipment
import dbapp.project.domain.shipment.ShipmentRepository
import dbapp.project.domain.shipment.ShipmentStatus
import dbapp.project.domain.shipment.ShipmentType

class TestShipmentRepository : GenericTestRepository<Shipment>(
        mutableSetOf(
                Shipment(1,
                        ShipmentType("naval"),
                        Address("Test", "Test", "Test 21/37", "12-345"),
                        ShipmentStatus("in progress")),
                Shipment(2,
                        ShipmentType("air"),
                        Address("Test", "Test", "Test 21/37", "12-345"),
                        ShipmentStatus("in progress")),
                Shipment(3,
                        ShipmentType("air"),
                        Address("Test", "Test", "Test 21/37", "12-345"),
                        ShipmentStatus("delivered"))
        )
), ShipmentRepository
