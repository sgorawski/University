package dbapp.project.tests.service

import com.nhaarman.mockito_kotlin.mock
import dbapp.project.application.shipment.ShipmentServiceImpl
import dbapp.project.domain.shared.Address
import dbapp.project.domain.shipment.Shipment
import dbapp.project.domain.shipment.ShipmentRepository
import dbapp.project.domain.shipment.ShipmentStatus
import dbapp.project.domain.shipment.ShipmentType
import dbapp.project.tests.common.GenericServiceTests
import org.junit.jupiter.api.TestInstance

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class ShipmentServiceTests : GenericServiceTests<Shipment>(
        mockRepository = mockShipmentRepository,
        service = ShipmentServiceImpl(mockShipmentRepository),
        testObject = Shipment(1,
                ShipmentType("naval"),
                Address("Test", "Test", "Test 21/37", "12-345"),
                ShipmentStatus("in progress"))
) {
    companion object {
        private val mockShipmentRepository: ShipmentRepository = mock()
    }
}