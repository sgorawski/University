package dbapp.project.application.order

import dbapp.project.common.GenericService
import dbapp.project.domain.order.Order
import dbapp.project.domain.order.OrderRepository

class OrderServiceImpl(
        private val orderRepository: OrderRepository
) : GenericService<Order>(orderRepository), OrderService {

    override fun findAllOfCustomer(customerID: Int): Collection<Order> =
            orderRepository.findAllOfCustomer(customerID)
}