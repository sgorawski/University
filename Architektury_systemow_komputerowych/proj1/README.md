# Projekt 1: Asembler dla architektury MIPS
Autor: Sławomir Górawski

Wymagania: **Python 3.6**
_(program nie jest kompatybilny z Pythonem 3.5 i wcześniejszymi ani 2.x)_

Sposób uruchomienia:
```
python3 mipsasm.py tests/<nazwa_testu>
```
Wynik zostanie wypisany na standardowe wyjście.

Jest możliwe również uruchomienie programu bez podania ściezki do testu
(`python3 mipsasm.py`),
wtedy należy wpisywać instrukcje na standardowe wejście -
będą one na bieżąco tłumaczone na kod maszynowy.

Nazwa instrukcji, operandy i ew. komentarz powinny być oddzielone tabami.
Program dopuszcza pewną elastyczność, jeśli chodzi o inne białe znaki, tj. spacje i nowe linie.
```
instrukcja \t op1,op2,op3
instrukcja \t op1,op2,op3 \t # komentarz
```
