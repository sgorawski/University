package dbapp.project.domain.shipment

import dbapp.project.domain.Entity
import dbapp.project.domain.shared.Address

data class Shipment(
        override val id: Int,
        val type: ShipmentType,
        val deliveryAddress: Address,
        var status: ShipmentStatus
) : Entity