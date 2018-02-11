-- Wymagamy  by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający testy.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko}Tests gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module SlawomirGorawskiTests(tests) where

-- Importujemy moduł zawierający typy danych potrzebne w zadaniu
import DataTypes

-- Lista testów do zadania
-- Należy uzupełnić jej definicję swoimi testami
tests :: [Test]
tests =
  [ Test "inc"      (SrcString "input x in x + 1") (Eval [42] (Value 43))
  , Test "undefVar" (SrcString "x")                TypeError
  , Test "suma"		(SrcString "input x y z in x + y + z") (Eval[5, 8, -3] (Value 10))
  , Test "mieszanka"	(SrcString "input x y z in x - y + z * x") (Eval[2, 5, 3] (Value 3))
  , Test "priorytety1"	(SrcString "input x y in x div y - y") (Eval[10, 5] (Value (-3)))
  , Test "priorytety2" 	(SrcString "input x y in -x * -x") (Eval[-5,  2] (Value 25))
  , Test "maximum"	(SrcFile "maximum.pp5") (Eval [3, 9, -6] (Value 9))
  , Test "bez input" (SrcString "2 + 5 * 8 div 2") (Eval [] (Value 22))
  , Test "ulamki" (SrcFile "ulamki.pp5") (Eval [3, 6, 11, 12] (Value 1))
  , Test "ulamki2" (SrcFile "ulamki.pp5") (Eval [3, 6, 11, 0] RuntimeError)
  , Test "brak zmiennej" (SrcFile "brakzm.pp5") TypeError
  , Test "suma cyfr dz" (SrcFile "sumadz.pp5") (Eval[534, 35435] (Value 6))
  , Test "dama krol" (SrcFile "para.pp5") (Eval[1, 12, 1, 13] (Value 1))
  , Test "dama krol2" (SrcFile "para.pp5") (Eval[1, 12, 1, 12] (Value 0))
  , Test "if1"(SrcFile "if1.pp5") TypeError
  , Test "if2"(SrcFile "if2.pp5") (Eval[8] (Value 2))
  , Test "if22"(SrcFile "if2.pp5") (Eval[-8] (Value (-8)))
  , Test "if3"(SrcFile "if3.pp5") (Eval[6] (Value 2))
  , Test "dzielnik2lub3"(SrcFile "dzielnik2lub3.pp5") (Eval[15] (Value 3))
  , Test "dzielnik2lub3 2"(SrcFile "dzielnik2lub3.pp5") (Eval[18] (Value 6))
  , Test "err"(SrcFile "err.pp5") TypeError
  , Test "power1" (SrcFile "power.pp5") (Eval[2,3] (Value 8))
  , Test "power2" (SrcFile "power.pp5") (Eval[-2,3] (Value (-8)))
  , Test "length" (SrcFile "length.pp5") (Eval[] (Value 4))
  , Test "unitEr" (SrcString "fun f (u:unit) : int = u in f()") TypeError
  , Test "f + g" (SrcString "fun f (n:int) :int = n fun g(n:int):int = 2*n input n in f n + g n") ( Eval[9] (Value 27) )
  , Test "f + gEr" (SrcString "fun f (n:int) :bool = True fun g(n:int):int = 2*n input n in f n + g n") TypeError
  , Test "max na parach" (SrcFile "max2.pp5") (Eval[99,-30] (Value 99))
  , Test "f zwraca unit" (SrcFile "unitunit.pp5") (Eval[] (Value 1000))
  , Test "fgh złożenie" (SrcFile "fgh.pp5") (Eval[4] (Value 130))
  , Test "prawie loop" (SrcFile "loop.pp5") (Eval[20] (Value 20))
  ]
