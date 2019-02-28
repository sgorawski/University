package dbapp.project.domain.order

import dbapp.project.common.Repository

interface OrderRepository : Repository<Order> {
    fun findAllOfCustomer(customerID: Int): Collection<Order>
}