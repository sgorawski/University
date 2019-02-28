package dbapp.project.common

import dbapp.project.domain.Entity

abstract class GenericTestRepository<T : Entity>(
        protected val objects: MutableCollection<T>
) : Repository<T> {

    override fun create(new: T): Boolean = objects.add(new)

    override fun find(id: Int): T? = objects.find { it.id == id }

    override fun findAll(): Collection<T> = objects

    override fun delete(id: Int): Boolean = objects.removeIf { it.id == id }
}