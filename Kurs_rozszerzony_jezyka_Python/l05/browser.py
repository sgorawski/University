from html.parser import HTMLParser
from urllib.request import urlopen
from urllib.parse import urlparse


class Browser:
    def __init__(self, root):
        self.root = root
        self.visited = []

    def browse(self, page, action, max_depth):
        self.visited.append(page)
        yield action(self.root + page)
        # DFS
        if max_depth > 0:
            for new_page in self.get_urls(page):
                yield from self.browse(new_page, action, max_depth - 1)

    def get_urls(self, page):
        url_parser = self.__URLParser()
        with urlopen(self.root + page) as data:
            url_parser.feed(data.read().decode('utf-8'))
            urls = url_parser.urls
            url_parser.close()
        urls = map(self.__correct, urls)
        return filter(
            lambda url: url not in self.visited and self.__is_valid(url),
            urls,
        )

    def __is_valid(self, url):
        if urlparse(url).netloc:
            return False
        try:
            with urlopen(self.root + url) as response:
                return "html" in response.info().get('Content-Type')
        except Exception:
            return False

    def __correct(self, url):
        if url.startswith(self.root):
            url = url[len(self.root):]
        return url

    class __URLParser(HTMLParser):
        urls = []

        def handle_starttag(self, tag, attrs):
            if tag == 'a':
                for (attr, val) in attrs:
                    if attr == 'href':
                        self.urls.append(val.split('#')[0])
