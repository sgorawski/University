package dbapp.project.common

abstract class GenericService<T>(
        private val repository: Repository<T>
) : Service<T> {

    override fun create(new: T): Boolean = repository.create(new)

    override fun find(id: Int): T? = repository.find(id)

    override fun findAll(): Collection<T> = repository.findAll()

    override fun delete(id: Int): Boolean = repository.delete(id)
}