package dbapp.project.application.customer

import dbapp.project.common.GenericService
import dbapp.project.domain.customer.Customer
import dbapp.project.domain.customer.CustomerRepository

class CustomerServiceImpl(customerRepository: CustomerRepository) :
        GenericService<Customer>(customerRepository), CustomerService