"""
Utility module containing markdown parser,
implemented using the markdown library from PyPI.
"""

from markdown import markdown


def parse_md(text):
    """Method returning HTML5-formatted text
    given a Markdown input.
    """
    return markdown(text, output_format="html5")
