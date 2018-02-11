{-# LANGUAGE Safe #-}
module SlawomirGorawskiTests(tests) where

-- Importujemy moduł zawierający typy danych potrzebne w zadaniu
import DataTypes

-- Lista testów do zadania
-- Należy uzupełnić jej definicję swoimi testami
tests :: [Test]
tests =
  [ Test "inc"       (SrcString "input x in x + 1")   (Eval [42] (Value 43))
  , Test "undefVar"  (SrcString "x")                  TypeError
  , Test "divZero"   (SrcString "input x in x div 0") (Eval [2] RuntimeError)
  , Test "noInput"   (SrcString "2 + 2")              (Eval [] (Value 4))
  , Test "unaryOp"   (SrcString "input x in -x")      (Eval [2] (Value -2))
  , Test "relu1"     (SrcString "input x in if x > 0 then x else 0")   (Eval [2] (Value 2))
  , Test "relu2"     (SrcString "input x in if x > 0 then x else 0")   (Eval [-1] (Value 0))
  , Test "let"       (SrcString "input x in let y = x + 3 in y + 2")   (Eval [2] (Value 7))
  , Test "bools"     (SrcString "input x in let b = x > 0 if b then 1 else 0")   (Eval [-1] (Value 0))
  , Test "moreArgs"  (SrcString "input x y in x + y")       (Eval [2, 3] (Value 5))
  , Test "priority1" (SrcString "input x in x + 5 div 2")   (Eval [2] (Value 4))
  , Test "priority2" (SrcString "input x in let b = x > 0 in if false or not b then 0 else 1")   (Eval [2] (Value 0))
  , Test "fileValid" (SrcFile "relu.pp4")   (Eval [2] (Value 2))
  , Test "fileInv"   (SrcFile "inv.pp4")    TypeError
  ]

