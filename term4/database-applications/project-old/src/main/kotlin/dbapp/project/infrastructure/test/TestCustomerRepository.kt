package dbapp.project.infrastructure.test

import dbapp.project.common.GenericTestRepository
import dbapp.project.domain.customer.Customer
import dbapp.project.domain.customer.CustomerRepository
import dbapp.project.domain.shared.Address

class TestCustomerRepository : GenericTestRepository<Customer>(
        mutableSetOf(
                Customer(1, "Test1", "Test1", "test1@test.com", null, null),
                Customer(2, "Test2", "Test2", "test2@test.com", "123123123", null),
                Customer(3, "Test3", "Test3", "test3@test.com", null,
                        Address("Test", "Test", "Test 21/37", "12-345"))
        )
), CustomerRepository