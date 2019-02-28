package dbapp.project.domain.order

import dbapp.project.domain.Entity

data class Order(
        override val id: Int,
        val customerID: Int,
        val shipmentID: Int,
        val orderItems: Set<OrderItem>
) : Entity