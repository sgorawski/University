package dbapp.project.application.article

import dbapp.project.common.GenericService
import dbapp.project.domain.article.Article
import dbapp.project.domain.article.ArticleRepository

class ArticleServiceImpl(articleRepository: ArticleRepository) :
        GenericService<Article>(articleRepository), ArticleService