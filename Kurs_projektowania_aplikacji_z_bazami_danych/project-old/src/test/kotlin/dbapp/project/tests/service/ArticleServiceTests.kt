package dbapp.project.tests.service

import com.nhaarman.mockito_kotlin.mock
import dbapp.project.application.article.ArticleServiceImpl
import dbapp.project.domain.article.Article
import dbapp.project.domain.article.ArticleRepository
import dbapp.project.tests.common.GenericServiceTests
import org.junit.jupiter.api.TestInstance

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class ArticleServiceTests : GenericServiceTests<Article>(
        mockRepository = mockArticleRepository,
        service = ArticleServiceImpl(mockArticleRepository),
        testObject = Article(1, "Test1", "Test1", "test1.com", 2137, 1)
) {
    companion object {
        private val mockArticleRepository: ArticleRepository = mock()
    }
}