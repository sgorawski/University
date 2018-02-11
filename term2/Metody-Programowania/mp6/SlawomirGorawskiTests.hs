-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający testy.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko}Tests gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module SlawomirGorawskiTests(tests) where

import DataTypes

tests :: [Test]
tests =
    [  Test "inc"      (SrcString "input x in x + 1") (Eval [42] (Value 43)),
       Test "undefVar" (SrcString "x")                TypeError,

      -- GENERAL PERFORMANCE TESTS
       Test "divZero"   (SrcString "input x in x div 0") (Eval [2] RuntimeError),
       Test "noInput"   (SrcString "2 + 2")              (Eval [] (Value 4)),
       Test "unaryOp"   (SrcString "input x in -x")      (Eval [-2] (Value 2)),
       Test "relu1"     (SrcString "input x in if x > 0 then x else 0")   (Eval [2] (Value 2)),
       Test "relu2"     (SrcString "input x in if x > 0 then x else 0")   (Eval [-1] (Value 0)),
       Test "let"       (SrcString "input x in let y = x + 3 in y + 2")   (Eval [2] (Value 7)),
       Test "bools"     (SrcString "input x in let b = x > 0 in if b then 1 else 0")   (Eval [-1] (Value 0)),
       Test "moreArgs"  (SrcString "input x y in x + y")       (Eval [2, 3] (Value 5)),
       Test "priority1" (SrcString "input x in x + 5 div 2")   (Eval [2] (Value 4)),
       Test "priority2" (SrcString "input x in let b = x > 0 in if false or not b then 0 else 1")   (Eval [2] (Value 0)),

      -- LAMBDA EXPRESSSION TESTS
       Test "lambda1"  (SrcString "fn (x : int) -> x + 2 4") (Eval [] (Value 6)),
       Test "lambda2"  (SrcString "input x in fn (y : int) -> y + 2 x") (Eval [4] (Value 6)),
       Test "lambda3"  (SrcString "let x=1 in fn (y : int) -> x + y 2") (Eval [] (Value 3)),
       Test "lambda4"  (SrcString "input x in fn (a : int) -> x + 2") (Eval [2] (Value 4)),
       Test "lambda5"  (SrcString "fn (x : int) -> x div 0 4") (Eval [] RuntimeError),
       Test "lambda6"  (SrcString "fn (x : int) -> x > 0 4") TypeError,
       Test "lambda7"  (SrcString "fn (x : bool) -> if x then 1 else 2 3 > 0") (Eval [] (Value 1)),
       Test "lambda8"  (SrcString "input x in fn (x : bool) -> if x then 1 else 2 x") TypeError,
       Test "lambda9"  (SrcString "fn (x : int * int) -> fst x (2 3)") (Eval [] (Value 2)),

      -- NEW FUNCTION TYPE TESTS
       Test "app1" (SrcString "fun relu(x : int) : int = if x>0 then x else 0 input x in relu(x)") (Eval [-2] (Value 0)),
       Test "app2" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [2, x] : int list") (Eval [2] (Value 2)),
       Test "app3" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [4, 2] : int list") (Eval [2] (Value 4)),
       Test "app4" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [x, x] : int list") (Eval [2] (Value 2)),
       Test "app5" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [] : int list") (Eval [2] (Value 0)),
       Test "app6" (SrcString "fun f(x : bool) : int = if x then 1 else 0  input x in f x") TypeError,
       Test "app7" (SrcString "fun f(x : bool) : int = if x then 1 else false  input x in f (x > 0)") TypeError,
       Test "app8" (SrcString "fun abs(x : int) : int = if x > 0 then x else -x input x in abs(x)") (Eval [-2] (Value 2)) ]
