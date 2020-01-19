package dbapp.project.infrastructure.test

import dbapp.project.common.GenericTestRepository
import dbapp.project.domain.order.Order
import dbapp.project.domain.order.OrderItem
import dbapp.project.domain.order.OrderRepository

class TestOrderRepository : GenericTestRepository<Order>(
        mutableSetOf(
            Order(1, 1, 1, setOf(
                    OrderItem(1, 2137, 2))),
            Order(2, 2, 2, setOf(
                    OrderItem(1, 2137, 2),
                    OrderItem(2, 2137, 5)))
    )
), OrderRepository {

    override fun findAllOfCustomer(customerID: Int) = objects.filter { it.customerID == customerID }
}