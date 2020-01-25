package dbapp.project.tests.common

import com.nhaarman.mockito_kotlin.times
import com.nhaarman.mockito_kotlin.verify
import dbapp.project.common.Repository
import dbapp.project.common.Service
import org.junit.jupiter.api.Test

abstract class GenericServiceTests<T>(
        private val mockRepository: Repository<T>,
        private val service: Service<T>,
        private val testObject: T
) {
    @Test
    fun `create calls create from repository`() {
        service.create(testObject)
        verify(mockRepository, times(1)).create(testObject)
    }

    @Test
    fun `find calls find from repository`() {
        service.find(1)
        verify(mockRepository, times(1)).find(1)
    }

    @Test
    fun `findAll calls findAll from repository`() {
        service.findAll()
        verify(mockRepository, times(1)).findAll()
    }

    @Test
    fun `delete calls delete from repository`() {
        service.delete(1)
        verify(mockRepository, times(1)).delete(1)
    }
}