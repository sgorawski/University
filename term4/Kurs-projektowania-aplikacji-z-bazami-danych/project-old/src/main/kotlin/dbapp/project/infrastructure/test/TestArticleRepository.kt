package dbapp.project.infrastructure.test

import dbapp.project.common.GenericTestRepository
import dbapp.project.domain.article.Article
import dbapp.project.domain.article.ArticleRepository

class TestArticleRepository : GenericTestRepository<Article>(
        mutableSetOf(
                Article(1, "Test1", "Test1", "test1.com", 2137, 1),
                Article(2, "Test2", "Test2", "test2.com", 2137, 2),
                Article(3, "Test3", "Test3", "test3.com", 2137, 3)
        )
), ArticleRepository