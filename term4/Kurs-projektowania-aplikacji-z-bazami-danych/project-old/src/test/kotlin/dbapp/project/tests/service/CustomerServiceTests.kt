package dbapp.project.tests.service

import com.nhaarman.mockito_kotlin.mock
import dbapp.project.application.customer.CustomerServiceImpl
import dbapp.project.domain.customer.Customer
import dbapp.project.domain.customer.CustomerRepository
import dbapp.project.tests.common.GenericServiceTests
import org.junit.jupiter.api.TestInstance

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class CustomerServiceTests : GenericServiceTests<Customer>(
        mockRepository = mockCustomerRepository,
        service = CustomerServiceImpl(mockCustomerRepository),
        testObject = Customer(1, "Test1", "Test1", "test1@test.com", null, null)
) {
    companion object {
        private val mockCustomerRepository: CustomerRepository = mock()
    }
}