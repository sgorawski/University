package dbapp.project.tests.service

import com.nhaarman.mockito_kotlin.mock
import com.nhaarman.mockito_kotlin.times
import com.nhaarman.mockito_kotlin.verify
import dbapp.project.application.order.OrderServiceImpl
import dbapp.project.domain.order.Order
import dbapp.project.domain.order.OrderItem
import dbapp.project.domain.order.OrderRepository
import dbapp.project.tests.common.GenericServiceTests
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestInstance

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class OrderServiceTests : GenericServiceTests<Order>(
        mockRepository = mockOrderRepository,
        service = orderService,
        testObject = Order(1, 1, 1, setOf(
                OrderItem(1, 2137, 2)))
) {
    @Test
    fun `findAllOfCustomer calls findAllOfCustomer from repository`() {
        orderService.findAllOfCustomer(1)
        verify(mockOrderRepository, times(1)).findAllOfCustomer(1)
    }

    companion object {
        private val mockOrderRepository: OrderRepository = mock()
        private val orderService = OrderServiceImpl(mockOrderRepository)
    }
}