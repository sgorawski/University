package dbapp.project.application.order

import dbapp.project.common.Service
import dbapp.project.domain.order.Order

interface OrderService : Service<Order> {
    fun findAllOfCustomer(customerID: Int): Collection<Order>
}