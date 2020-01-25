-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający rozwiązanie.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko} gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module SlawomirGorawski (typecheck, eval) where

-- Importujemy moduły z definicją języka oraz typami potrzebnymi w zadaniu
import AST
import DataTypes

-- CUSTOM DATA TYPES
data ErrorKind
    = EUndefinedVariable Var
    | ETypeMismatch Type Type
    | ETypesNotEqual Type Type
    | ENotAPair Type
    | ENotAList Type
    | ENotAFunction Type

instance Show ErrorKind where
    show (EUndefinedVariable x) = "Undefined variable: " ++ show x ++ "."
    show (ETypeMismatch type1 type2) =
            "Expected " ++ show type1 ++ ", but received " ++ show type2 ++ "."
    show (ETypesNotEqual type1 type2) =
            "Types " ++ show type1 ++ " and " ++ show type2 ++ " should be the same."
    show (ENotAPair other) = "Expected a pair, but received " ++ show other ++ "."
    show (ENotAList other) = "Expected a list, but received " ++ show other ++ "."
    show (ENotAFunction other) = "Expected a function, but received " ++ show other ++ "."



data Value
    = VNum Integer
    | VBool Bool
    | VUnit
    | VPair Value  Value
    | VList [Value]
    -- | VClojure EvalEnv FuncDef

-- type FuncDef = (Var, (Expr))
type TypecheckEnv = [(Var, Type)]
type EvalEnv = [(Var, Value)]

-- ##### #   # ####   #####  #### #   # #####  #### #   #
--   #    # #  #   #  #     #     #   # #     #     #  #
--   #     #   ####   ###   #     ##### ###   #     ##
--   #     #   #      #     #     #   # #     #     #  #
--   #     #   #      #####  #### #   # #####  #### #   #

infixr 6 $>

($>) :: Maybe a -> Either a b -> Either a b
Just e  $> _ = Left e
Nothing $> e = e

-- Funkcja sprawdzająca typy
-- Dla wywołania typecheck fs vars e zakładamy, że zmienne występujące
-- w vars są już zdefiniowane i mają typ int, i oczekujemy by wyrażenia e
-- miało typ int
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.
typecheck :: [FunctionDef p] -> [Var] -> Expr p -> TypeCheckResult p
typecheck funcDefs vars e =
    case checkFunctions funcDefs ftypes of
        Nothing -> case checkType env e TInt of
            Nothing -> Ok
            Just (p, err) -> Error p $ show err
        Just (p, err) -> Error p $ show err
    where
        ftypes = map (\ (FunctionDef _ fsym _ inType outType _) ->
            (fsym, (TArrow inType outType))) funcDefs
        env = (map (\ v -> (v, TInt)) vars) ++ ftypes
-- CHECKING FUNCTIONS
checkFunctions :: [FunctionDef p] -> TypecheckEnv -> Maybe (p, ErrorKind)
checkFunctions [] _ = Nothing
checkFunctions (f:rest) ftypes =
    case checkType ((argName, argType):ftypes) funcBody resType of
        Nothing -> checkFunctions rest ftypes
        Just err -> Just err
    where (argName, argType, resType, funcBody) =
            (\ (FunctionDef _ _ argName argType resType funcBody) -> (argName, argType, resType, funcBody)) f

-- CHECKTYPE IMPLEMENTATION
checkType :: TypecheckEnv -> Expr p -> Type -> Maybe (p, ErrorKind)
checkType env e expectedType =
    case inferType env e of
        Left err -> Just err
        Right exprType ->
            if exprType == expectedType
            then Nothing
            else Just (getData e, ETypeMismatch expectedType exprType)

-- INFERTYPE IMPLEMENTATION
inferType :: TypecheckEnv -> Expr p -> Either (p, ErrorKind) Type
-- VAR
inferType env (EVar p x) =
    case lookup x env of
        Nothing -> Left (p, EUndefinedVariable x)
        Just t -> Right t
-- NUM
inferType _ (ENum _ _) =
    Right TInt
-- BOOL
inferType _ (EBool _ _) =
    Right TBool
-- UNARY
inferType env (EUnary _ uop und) =
    checkType env und uType $>
    Right opType
    where (uType, opType) = uopTypes uop
-- BINARY
inferType env (EBinary _ binop und1 und2) =
    checkType env und1 u1Type $>
    checkType env und2 u2Type $>
    Right opType
    where (u1Type, u2Type, opType) = binopTypes binop
-- LET
inferType env (ELet _ newVar varExpr inExpr) =
    case inferType env varExpr of
        Left err -> Left err
        Right newType -> inferType ((newVar, newType):env) inExpr
-- IF
inferType env (EIf p condExpr thenExpr elseExpr) =
    checkType env condExpr TBool $>
    checkEqual p (inferType env thenExpr) (inferType env elseExpr)
-- FN
inferType env (EFn _ _ varType expr) =
    case inferType env expr of
        Left err -> Left err
        Right outType -> Right $ TArrow varType outType
-- APP
inferType env (EApp p funExpr argExpr) =
    case inferType env funExpr of
        Left err -> Left err
        Right (TArrow inType outType) -> checkType env argExpr inType $>
            Right outType
        Right otherType -> Left (p, ENotAFunction otherType)
-- UNIT
inferType _ (EUnit _) =
    Right TUnit
-- PAIR
inferType env (EPair p fstExpr sndExpr) =
    case ((inferType env fstExpr), (inferType env sndExpr)) of
        (Left err, _) -> Left err
        (_, Left err) -> Left err
        (Right fstType, Right sndType) -> Right $ TPair fstType sndType
-- FST
inferType env (EFst p pair) =
    case inferType env pair of
        Left err -> Left err
        Right (TPair fstType _) -> Right fstType
        Right otherType -> Left (p, ENotAPair otherType)
-- SND
inferType env (ESnd p pair) =
    case inferType env pair of
        Left err -> Left err
        Right (TPair _ sndType) -> Right sndType
        Right otherType -> Left (p, ENotAPair otherType)
-- NIL
inferType _ (ENil p listType) =
    Right listType
-- CONS
inferType env (ECons p headExpr tailExpr) =
    case ((inferType env headExpr), (inferType env tailExpr)) of
        (_, Left err) -> Left err
        (Left err, _) -> Left err
        (Right headType, (Right (TList elemsType))) -> case headType == elemsType of
            True -> Right (TList elemsType)
            False -> Left (p, ETypeMismatch elemsType headType)
        (_, Right otherType) -> Left (p, ENotAList otherType)

-- MATCH LIST
inferType env (EMatchL p listExpr nilExpr (headVar, tailVar, consExpr)) =
    case inferType env listExpr of
        Left err -> Left err
        Right (TList elemsType) -> checkEqual p (inferType env nilExpr)
                    (inferType ((headVar, elemsType):(tailVar, (TList elemsType)):env) consExpr)
        Right otherType -> Left (p, ENotAList otherType)

-- UNARY OPERATOR TYPES EXTRACTION
uopTypes :: UnaryOperator -> (Type, Type)
uopTypes UNot = (TBool, TBool)
uopTypes UNeg = (TInt, TInt)

-- BINARY OPERATOR TYPES EXTRACTION
binopTypes :: BinaryOperator -> (Type, Type, Type)
binopTypes binop =
    case binop of
        BAnd -> tbool
        BOr  -> tbool
        BEq  -> tcomp
        BNeq -> tcomp
        BLt  -> tcomp
        BLe  -> tcomp
        BGt  -> tcomp
        BGe  -> tcomp
        BAdd -> tarit
        BSub -> tarit
        BMul -> tarit
        BDiv -> tarit
        BMod -> tarit
  where tbool = (TBool, TBool, TBool)
        tcomp = (TInt, TInt, TBool)
        tarit = (TInt, TInt, TInt)

-- CHECKING FOR EQUAL TYPES
checkEqual :: p -> Either (p, ErrorKind) Type -> Either (p, ErrorKind) Type -> Either (p, ErrorKind) Type
checkEqual _ (Left err) _ = Left err
checkEqual _ _ (Left err) = Left err
checkEqual p (Right type1) (Right type2) =
    if type1 == type2
    then Right type1
    else Left (p, ETypesNotEqual type1 type2)
-- END OF TYPECHECKING PART

-- ##### #   #  ###  #
-- #     #   # #   # #
-- ###   #   # ##### #
-- #      # #  #   # #
-- #####   #   #   # #####

-- Funkcja obliczająca wyrażenia
-- Dla wywołania eval fs input e przyjmujemy, że dla każdej pary (x, v)
-- znajdującej się w input, wartość zmiennej x wynosi v.
-- Możemy założyć, że definicje funckcji fs oraz wyrażenie e są dobrze
-- typowane, tzn. typecheck fs (map fst input) e = Ok
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.
eval :: [FunctionDef p] -> [(Var,Integer)] -> Expr p -> EvalResult
eval funcDefs args e =
    case ev env e of
        Just (VNum res) -> Value res
        Just _ -> undefined
        Nothing -> RuntimeError
    where
        env = (map (\ (var, val) -> (var, (VNum val))) args)

-- UNIVERSAL EVALUATING PREDICATE
ev :: EvalEnv -> Expr p -> Maybe Value
-- VAR
ev env (EVar _ var) =
    lookup var env
-- NUM
ev _ (ENum _ val) =
    Just $ VNum val
-- BOOL
ev _ (EBool _ val) =
    Just $ VBool val
-- UNARY
ev env (EUnary _ op expr) =
    case ev env expr of
        Just val -> evUOp op val
        Nothing -> Nothing
-- BINARY
ev env (EBinary _ op expr1 expr2) =
    case ((ev env expr1), (ev env expr2)) of
        (Just val1, Just val2) -> evBOp op val1 val2
        _ -> Nothing
-- LET
ev env (ELet _ newVar varExpr inExpr) =
    case ev env varExpr of
        Just newVal -> ev ((newVar, newVal):env) inExpr
        Nothing -> Nothing
-- IF
ev env (EIf _ condExpr thenExpr elseExpr) =
    case ev env condExpr of
        Just (VBool True) -> ev env thenExpr
        Just (VBool False) -> ev env elseExpr
        _ -> Nothing
        {-}
-- FN
ev env (EFn _ var _ expr) =
    Just $ VClojure env (var, expr)
-- APP
ev env (EApp _ funcExpr argExpr) =
    case ev env argExpr of
        Just argVal -> case ev env funcExpr of
            Just (VClojure funcEnv (arg, inExpr)) ->
                ev ((arg, argVal):funcEnv) inExpr
            Nothing -> Nothing
        Nothing -> Nothing
        -}
-- UNIT
ev _ (EUnit _) =
    Just VUnit
-- PAIR
ev env (EPair _ fstExpr sndExpr) =
    case ((ev env fstExpr), (ev env sndExpr)) of
        (Just fstVal, Just sndVal) -> Just $ VPair fstVal sndVal
        _ -> Nothing
-- FST
ev env (EFst _ pair) =
    case ev env pair of
        Just (VPair fstVal _) -> Just fstVal
        Nothing -> Nothing
-- SND
ev env (ESnd _ pair) =
    case ev env pair of
        Just (VPair _ sndVal) -> Just sndVal
        Nothing -> Nothing
-- NIL
ev _ (ENil _ _) =
    Just $ VList []
-- CONS
ev env (ECons _ headExpr tailExpr) =
    case ((ev env headExpr), (ev env tailExpr)) of
        (Just newVal, Just (VList vals)) -> Just $ VList (newVal:vals)
        _ -> Nothing
-- MATCH LIST
ev env (EMatchL _ list nilExpr (headVar, tailVar, consExpr)) =
    case ev env list of
        Just (VList []) -> ev env nilExpr
        Just (VList (h:t)) -> ev ((headVar, h):(tailVar, (VList t)):env) consExpr
        Nothing -> Nothing


-- OPERATORS EVALUATION
evUOp :: UnaryOperator -> Value -> Maybe Value
evUOp UNot (VBool b) = Just . VBool $ not b
evUOp UNeg (VNum n)  = Just . VNum $ -n

evBOp :: BinaryOperator -> Value -> Value -> Maybe Value
evBOp BAnd (VBool b1) (VBool b2) = Just . VBool $ b1 && b2
evBOp BOr  (VBool b1) (VBool b2) = Just . VBool $ b1 || b2
evBOp BEq  (VNum n1)  (VNum n2)  = Just . VBool $ n1 == n2
evBOp BNeq (VNum n1)  (VNum n2)  = Just . VBool $ n1 /= n2
evBOp BLt  (VNum n1)  (VNum n2)  = Just . VBool $ n1 <  n2
evBOp BLe  (VNum n1)  (VNum n2)  = Just . VBool $ n1 <= n2
evBOp BGt  (VNum n1)  (VNum n2)  = Just . VBool $ n1 >  n2
evBOp BGe  (VNum n1)  (VNum n2)  = Just . VBool $ n1 >= n2
evBOp BAdd (VNum n1)  (VNum n2)  = Just . VNum  $ n1 + n2
evBOp BSub (VNum n1)  (VNum n2)  = Just . VNum  $ n1 - n2
evBOp BMul (VNum n1)  (VNum n2)  = Just . VNum  $ n1 * n2
evBOp BDiv (VNum n1)  (VNum n2)
    | n2 == 0   = Nothing
    | otherwise = Just . VNum  $ n1 `div` n2
evBOp BMod (VNum n1)  (VNum n2)
    | n2 == 0   = Nothing
    | otherwise = Just . VNum  $ n1 `mod` n2
