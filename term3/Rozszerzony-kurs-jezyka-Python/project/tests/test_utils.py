from unittest import TestCase

from mdb.parser import parse_md


class MDParserTests(TestCase):
    """docstring"""

    def test_parse_clean_markdown(self):
        text = """**bold**_italics_
        """
        html = parse_md(text)
        self.assertIn("<strong>", html)
        self.assertIn("<em>", html)

    def test_parse_markdown_with_html(self):
        text = """<em>test</em>"""
        html = parse_md(text)
        self.assertIn(text, html)

    def test_parse_markdown_middle_word_emphasis(self):
        text = """middle_word_emphasis"""
        html = parse_md(text)
        self.assertNotIn("<em>", html)
