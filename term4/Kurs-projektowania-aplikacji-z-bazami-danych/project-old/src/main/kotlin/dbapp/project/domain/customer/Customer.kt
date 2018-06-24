package dbapp.project.domain.customer

import dbapp.project.domain.Entity
import dbapp.project.domain.shared.Address

data class Customer(
        override val id: Int,
        val firstName: String,
        val lastName: String,
        val emailAddress: String,
        val phone: String?,
        val address: Address?
) : Entity