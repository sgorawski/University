-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający testy.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko}Tests gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module SlawomirGorawskiTests(tests) where

-- Importujemy moduł zawierający typy danych potrzebne w zadaniu
import DataTypes

-- Lista testów do zadania
-- Należy uzupełnić jej definicję swoimi testami
tests :: [Test]
tests =
  [ Test "I'm Still Standing"     (SrcString "input x in x + (let a = false in a)") TypeError,
    Test "Nikita" (SrcString "x")         TypeError,
    Test "Your Song"(SrcString "input x y in (x or y) and false")          TypeError,
	Test "Rocket Man" (SrcString "input x in if x > 5 then true else 5")   TypeError,
	Test "Crocodile Rock" (SrcString "input x in if x > a then true else 5")  TypeError,
	Test "Daniel" (SrcString "false") TypeError,
	Test "Goodbye Yellow Brick Road" (SrcString "input a b in if a <> b then let a = 4 + 1  in a + 2 else let b = false in b or (a < 2) " ) TypeError,
	Test "Don't Let The Sun Go Down On Me" (SrcString "let the_sun = 5 in let b = the_sun > 2 in the_sun mod b" ) TypeError,
	Test "Sorry Seems To Be The Hardest Word" (SrcString "let a = 5 in let b = a > 2 in a and b" ) TypeError,
	Test "The Last Song"  (SrcString "if The then Last else Song " ) TypeError,
	Test "Sacrifice"  (SrcString "5 + 5 or 2 > 3 and false " ) TypeError,
	Test "Circle Of Life" (SrcString "5 + 2 * (42 - (12 mod (23 div a)) )" ) TypeError,
	Test "Candle In the Wind" (SrcString "5 + 2 * (42 - (12 mod (23 div false)) )" ) TypeError,
	Test "Can You Feel The Love Tonight?" (SrcString "let e = false in let j = true in e and (j or (a and (e or (false and 1)))) " ) TypeError,


	Test "Tubular Bells" (SrcString "input x in let y = 3 in if x * 2 >= 100 and x * y <= 150 then 4 else 5 * y") (Eval [50] (Value 4)),
	Test "Tubular Bells II" (SrcString "input x in let y = 3 in if x * 2 >= 100 and x * y <= 150 then 4 else 5 * y") (Eval [44] (Value 15)),
	Test "Tubular Bells III" (SrcString "let y = 3 in y * y div y div y") (Eval [] (Value 1)),
	Test "Voyager" (SrcString "input x in x + 1") (Eval [42] (Value 43)),
	Test "QE2" (SrcString "input x in if x >= 0 then x else -x") (Eval [-5] (Value 5)),
	Test "Five Miles Out" (SrcString "input x in if x >= 0 then x else -x") (Eval [42] (Value 42)),
	Test "Crises" (SrcString "input x in if x >= 0 then x else -x") (Eval [0] (Value 0)),
	Test "Ommadawn" (SrcString "input x in if x mod 2 = 0 then  x * x - 3 * x + 7 else x mod 17 + 3") (Eval [1975] (Value 6)),
	Test "Return to Ommadawn" (SrcString "input x in if x mod 2 <> 0 then  x * x - 3 * x + 7 else x mod 17 + 3") (Eval [2017] (Value 4062245)),
	Test "The Songs Of Distant Earth" (SrcString "input x in if x mod 2 = 0 then x mod 50 else x div 0") (Eval [1994] (Value 44)),
	Test "Guitars" (SrcString "input x in if x mod 2 = 0 then x mod 50 else x div 0") (Eval [1999] RuntimeError),
	Test "Man On The Rocks" (SrcString "input x  y z in let a = 2 in let b = 3 in let c = 4 in let p = true in if p then x + y + z - a + b * c else -12") (Eval [2014, 3, 3] (Value 2030)),
	Test "Tubular Bells 2003"  (SrcString "if 2003 > 42 and 2003 < 4540 then 53 else 8 mod 0") (Eval [] (Value 53)),
	Test "Heaven's Open"  (SrcString "input x in let x = 44 in let x = 2 in let x = 32 in x") (Eval [22] (Value 32)),


	Test "Another Brick In The Wall" (SrcString "fun const(x:int) : int = 2  input x in if const x then 1 else 0")  TypeError,
	Test "Hey You" (SrcString "fun const(x:int) : int = false  input x in if const x then 1 else 0")  TypeError,
	Test "Mother" (SrcString "fun f(x:bool) : int = if x then 1 else 0  input x in f x") TypeError,
	Test "Young Lust" (SrcString "fun f(x:bool) : int = if x then 1 else false  input x in f (x > 0)") TypeError,
	Test "Comfortably Numb" (SrcString "fst (true, false) + 1") TypeError,
	Test "In The Flesh" (SrcString "snd (1, 2) + true ") TypeError,
	--Test "One Slip" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [true, false] : bool list") TypeError,
	Test "Terminal Frost" (SrcString "fun f(x : int ) : bool = x > 2 input x in snd (f x, f (x - 2))") TypeError,
	Test "High Hopes" (SrcString "fun fib(n : int) : bool = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") TypeError,
	Test "Marooned"  (SrcString  "fun f (n : bool) : int list = [1,2,3] : int list  input x  in f (x > 5)") TypeError,
	Test "Wearing The Inside Out" (SrcString "fun p (n : int) : int * int = (n, n) input n in p n") TypeError,
	Test "Echoes"  (SrcString "fst (1, 2)") (Eval [] (Value 1)),
	Test "Wish You Were Here"  (SrcString "snd (1, 2)") (Eval [] (Value 2)),
	Test "Shine On You Crazy Diamond" (SrcString "fun fib(n : int) : int = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") (Eval [0] (Value 0)),
	Test "Time" (SrcString "fun fib(n : int) : int = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") (Eval [1] (Value 1)),
	Test "Money" (SrcString "fun fib(n : int) : int = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") (Eval [2] (Value 1)),
	Test "Us And Them" (SrcString "fun fib(n : int) : int = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") (Eval [19] (Value 4181)),
	Test "Lost For Words" (SrcString "fun p (n : int) : int * int = (n, n) input n in fst (p n)") (Eval [1] (Value 1)),
	Test "Breathe (In The Air)" (SrcString "fun p (n : int) : int * int = (n, n) input n in snd (p n)") (Eval [42] (Value 42)),
	Test "Cluster One" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [2, x] : int list") (Eval [42] (Value 2)),
	Test "One Of These Days" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [4, 2] : int list") (Eval [42] (Value 4)),
	Test "Dogs" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [x , x, x] : int list") (Eval [42] (Value 42)),
	Test "Sheep" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [] : int list") (Eval [42] (Value 0))
  ]
