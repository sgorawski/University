-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający rozwiązanie.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko} gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module SlawomirGorawski (typecheck, eval) where
-- Importujemy moduły z definicją języka oraz typami potrzebnymi w zadaniu
import AST
import DataTypes

-- CUSTOM DATA TYPES
data ExprType
    = TypeInt
    | TypeBool
    | NoType
    deriving Eq

data Value
    = Val Integer
    | TT -- boolean true
    | FF -- boolean false
    | RE -- RuntimeError (div or mod 0)
    deriving Eq

-- Funkcja sprawdzająca typy
-- Dla wywołania typecheck vars e zakładamy, że zmienne występujące
-- w vars są już zdefiniowane i mają typ int, i oczekujemy by wyrażenia e
-- miało typ int
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.
typecheck :: [Var] -> Expr p -> TypeCheckResult p
typecheck varList expr = checkExpr env expr TypeInt
    where env = map createStartingEnv varList

createStartingEnv :: Var -> (Var, ExprType)
createStartingEnv var = (var, TypeInt)
    
-- Funkcja obliczająca wyrażenia
-- Dla wywołania eval input e przyjmujemy, że dla każdej pary (x, v)
-- znajdującej się w input, wartość zmiennej x wynosi v.
-- Możemy założyć, że wyrażenie e jest dobrze typowane, tzn.
-- typecheck (map fst input) e = Ok
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.
eval :: [(Var, Integer)] -> Expr p -> EvalResult
eval env expr
    | result == RE = RuntimeError
    | otherwise = Value (valueToInt result)
    where result = evaluateExpr (map convertTuple env) expr

convertTuple :: (Var, Integer) -> (Var, Value)
convertTuple (var, int) = (var, intToValue int)


-- TYPE CHECKING IMPLEMENTATION
-- helper fuctions isError and isOk
isError :: TypeCheckResult p -> Bool
isError (Error _ _) = True
isError _ = False

isOk :: TypeCheckResult p -> Bool
isOk Ok = True
isOk _ = False

checkExpr :: [(Var, ExprType)] -> Expr p -> ExprType -> TypeCheckResult p

-- EIf checking
checkExpr env (EIf p condExpr thenExpr elseExpr) expectedType
    | isError condCheck
        = condCheck
    | isError thenCheck
        = thenCheck
    | isError elseCheck
        = elseCheck
    | otherwise
        = Ok
    where condCheck = checkExpr env condExpr TypeBool
          thenCheck = checkExpr env thenExpr expectedType
          elseCheck = checkExpr env elseExpr expectedType

-- ELet checking
checkExpr env (ELet p var varExpr expr) expectedType
    | isBool
        = checkExpr ((var, TypeBool):env) expr expectedType
    | isInt
        = checkExpr ((var, TypeInt):env) expr expectedType
    | otherwise
        = (Error p "unknown expression type")
    where isBool = isOk $ checkExpr env varExpr TypeBool
          isInt = isOk $ checkExpr env varExpr TypeInt

-- EBinary checking
checkExpr env (EBinary p op firstExpr secondExpr) expectedType
    | isBTB && expectedType /= TypeBool
        = (Error p "expected boolean value")
    | isBTB
        = checkOpExpr env firstExpr secondExpr TypeBool
    | isITB && expectedType /= TypeBool
        = (Error p "expected boolean value")
    | isITB
        = checkOpExpr env firstExpr secondExpr TypeInt
    | isITI && expectedType /= TypeInt
        = (Error p "expected int value")
    | isITI
        = checkOpExpr env firstExpr secondExpr TypeInt
    | otherwise
        = (Error p "unknown operator type")
    where isBTB = elem op [BAnd, BOr]
          isITB = elem op [BEq, BNeq, BLt, BGt, BLe, BGe]
          isITI = elem op [BAdd, BSub, BMul, BDiv, BMod]   

-- EUnary checking
-- Bool to Bool
checkExpr env (EUnary p UNot expr) expectedType
    | isError $ checkExpr env expr TypeBool
        = checkExpr env expr TypeBool
    | expectedType /= TypeBool
        = (Error p "expected boolean value")
    | otherwise
        = Ok

-- Int to Int
checkExpr env (EUnary p UNeg expr) expectedType
    | isError $ checkExpr env expr TypeInt
        = checkExpr env expr TypeInt
    | expectedType /= TypeInt
        = (Error p "expected int value")
    | otherwise
        = Ok

-- EVar checking
checkExpr env (EVar p var) expectedType
    | typeOfVar == NoType
        = (Error p ("variable not instantiated" ++ show var))
    | typeOfVar /= expectedType
        = (Error p ("variable wrong type" ++ show var))
    | otherwise
        = Ok
    where typeOfVar = extractTypeOfVar env var 

-- ENum checking
checkExpr env (ENum p _) expectedType
    | expectedType /= TypeInt
        = (Error p "unexpected int value")
    | otherwise
        = Ok

-- EBool checking
checkExpr env (EBool p _) expectedType
    | expectedType /= TypeBool
        = (Error p "unexpected boolean value")
    | otherwise
        = Ok

-- check op expr
checkOpExpr :: [(Var, ExprType)] -> Expr p -> Expr p -> ExprType -> TypeCheckResult p
checkOpExpr env firstExpr secondExpr expectedExprType
    | isError $ checkExpr env firstExpr expectedExprType
        = checkExpr env firstExpr expectedExprType
    | isError $ checkExpr env secondExpr expectedExprType
        = checkExpr env secondExpr expectedExprType
    | otherwise
        = Ok

extractTypeOfVar :: [(Var, ExprType)] -> Var -> ExprType
extractTypeOfVar [] _ = NoType
extractTypeOfVar (x:xs) var
    | fst x == var = snd x
    | otherwise = extractTypeOfVar xs var

-- END OF TYPECHECKING




-- EVAL IMPLEMENTATION

-- converters
valueToInt :: Value -> Integer
valueToInt (Val int) = int

intToValue :: Integer -> Value
intToValue int = Val int

-- main evaluation function
evaluateExpr :: [(Var, Value)] -> Expr p -> Value

-- EIf evaluation
evaluateExpr env (EIf _ condExpr thenExpr elseExpr)
    | cond == TT = evaluateExpr env thenExpr
    | cond == FF = evaluateExpr env elseExpr
    | otherwise = RE
    where cond = evaluateExpr env condExpr

-- ELet evaluation
evaluateExpr env (ELet _ var varExpr expr)
    | varValue == RE = RE
    | otherwise = evaluateExpr ((var, varValue):env) expr
    where varValue = evaluateExpr env varExpr

-- EBinary evaluation
evaluateExpr env (EBinary _ op firstExpr secondExpr)
    | firstVal == RE
        = RE
    | secondVal == RE
        = RE 
    | op == BAnd
        = evaluateBAnd firstVal secondVal
    | op == BOr
        = evaluateBOr firstVal secondVal
    | op == BEq && (valueToInt firstVal) == (valueToInt secondVal)
        = TT
    | op == BEq
        = FF
    | op == BNeq && (valueToInt firstVal) /= (valueToInt secondVal)
        = TT
    | op == BNeq
        = FF
    | op == BLt && (valueToInt firstVal) < (valueToInt secondVal)
        = TT
    | op == BLt
        = FF
    | op == BGt && (valueToInt firstVal) > (valueToInt secondVal)
        = TT
    | op == BGt
        = FF  
    | op == BLe && (valueToInt firstVal) <= (valueToInt secondVal)
        = TT
    | op == BLe
        = FF
    | op == BGe && (valueToInt firstVal) >= (valueToInt secondVal)
        = TT
    | op == BGe
        = FF
    | op == BAdd
        = intToValue $ (valueToInt firstVal) + (valueToInt secondVal)
    | op == BSub
        = intToValue $ (valueToInt firstVal) - (valueToInt secondVal)
    | op == BMul
        = intToValue $ (valueToInt firstVal) * (valueToInt secondVal)
    | op == BDiv && valueToInt secondVal == 0
        = RE
    | op == BDiv
        = intToValue $ (valueToInt firstVal) `div` (valueToInt secondVal)
    | op == BMod && valueToInt secondVal == 0
        = RE
    | op == BMod
        = intToValue $ (valueToInt firstVal) `mod` (valueToInt secondVal)
    where firstVal = evaluateExpr env firstExpr
          secondVal = evaluateExpr env secondExpr

-- EUnary evaluation
evaluateExpr env (EUnary _ UNot expr)
    | valueOfExpr == TT = FF
    | valueOfExpr == FF = TT
    | otherwise = RE
    where valueOfExpr = evaluateExpr env expr

evaluateExpr env (EUnary _ UNeg expr)
    | value == RE = RE
    | otherwise = intToValue $ - valueToInt value
    where value = evaluateExpr env expr

-- EVar evaluation
evaluateExpr env (EVar _ var)
    = extractValueOfVar env var

-- ENum evaluation
evaluateExpr env (ENum _ val)
    = Val val

-- EBool evaluation
evaluateExpr env (EBool _ val)
    | val = TT
    | otherwise = FF

-- Binary bool operators evaluation
evaluateBAnd firstVal secondVal
    | firstVal == TT && secondVal == TT = TT
    | otherwise = FF

evaluateBOr firstVal secondVal
    | firstVal == FF && secondVal == FF = FF
    | otherwise = TT

-- value extraction
extractValueOfVar :: [(Var, Value)] -> Var -> Value
extractValueOfVar [] _ = error "No such variable"
extractValueOfVar (x:xs) var
    | fst x == var = snd x
    | otherwise = extractValueOfVar xs var