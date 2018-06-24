package dbapp.project.domain.article

import dbapp.project.domain.Entity

data class Article(
        override val id: Int,
        val name: String,
        val description: String,
        val imageUrl: String,
        val price: Int,
        var quantity: Int
) : Entity