from browser import Browser
from search import get_sentences_with_python, proof_of_visit


root = "http://www.python.rk.edu.pl/"


browser = Browser(root)
for action_result in browser.browse('', get_sentences_with_python, 1):
    print(action_result)
