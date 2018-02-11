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
    | EUndefinedFunction FSym
    | ETypeMismatch Type Type
    | ETypesNotEqual Type Type
    | ENotAPair Type
    | ENotAList Type

instance Show ErrorKind where
    show (EUndefinedVariable x) = "Undefined variable: " ++ show x ++ "."
    show (EUndefinedFunction f) = "Undefined function: " ++ show f ++ "."
    show (ETypeMismatch type1 type2) =
            "Expected " ++ show type1 ++ ", but received " ++ show type2 ++ "."
    show (ETypesNotEqual type1 type2) =
            "Types " ++ show type1 ++ " and " ++ show type2 ++ " should be the same."
    show (ENotAPair other) = "Expected a pair, but received " ++ show other ++ "."
    show (ENotAList other) = "Expected a list, but received " ++ show other ++ "."



data Value
    = VNum Integer
    | VBool Bool
    | VUnit
    | VPair Value Value
    | VList [Value]

type Env = [(Var, Type)]
type FuncTypes = [(FSym, (Type, Type))]

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
    case checkFunctions funcDefs fs of
        Nothing -> case checkType fs env e TInt of
            Nothing -> Ok
            Just (p, err) -> Error p $ show err
        Just (p, err) -> Error p $ show err
    where
        env = map (\ v -> (v, TInt)) vars
        fs = zip (map (\ (FunctionDef _ fsym _ _ _ _) -> fsym) funcDefs)
            (map (\ (FunctionDef _ _ _ argType resType _) -> (argType, resType)) funcDefs)
-- CHECKING FUNCTIONS
checkFunctions :: [FunctionDef p] -> FuncTypes -> Maybe (p, ErrorKind)
checkFunctions [] _ = Nothing
checkFunctions (f:rest) fs =
    case checkType fs [(argName, argType)] funcBody resType of
        Nothing -> checkFunctions rest fs
        Just err -> Just err
    where (argName, argType, resType, funcBody) =
            (\ (FunctionDef _ _ argName argType resType funcBody) -> (argName, argType, resType, funcBody)) f

-- CHECKTYPE IMPLEMENTATION
checkType :: FuncTypes -> Env -> Expr p -> Type -> Maybe (p, ErrorKind)
checkType fs env e expectedType =
    case inferType fs env e of
        Left err -> Just err
        Right exprType ->
            if exprType == expectedType
            then Nothing
            else Just (getData e, ETypeMismatch expectedType exprType)

-- INFERTYPE IMPLEMENTATION
inferType :: FuncTypes -> Env -> Expr p -> Either (p, ErrorKind) Type
-- VAR
inferType _ env (EVar p x) =
    case lookup x env of
        Nothing -> Left (p, EUndefinedVariable x)
        Just t -> Right t
-- NUM
inferType _ _ (ENum _ _) =
    Right TInt
-- BOOL
inferType _ _ (EBool _ _) =
    Right TBool
-- UNARY
inferType fs env (EUnary _ uop und) =
    checkType fs env und uType $>
    Right opType
    where (uType, opType) = uopTypes uop
-- BINARY
inferType fs env (EBinary _ binop und1 und2) =
    checkType fs env und1 u1Type $>
    checkType fs env und2 u2Type $>
    Right opType
    where (u1Type, u2Type, opType) = binopTypes binop
-- LET
inferType fs env (ELet _ newVar varExpr inExpr) =
    case inferType fs env varExpr of
        Left err -> Left err
        Right newType -> inferType fs ((newVar, newType):env) inExpr
-- IF
inferType fs env (EIf p condExpr thenExpr elseExpr) =
    checkType fs env condExpr TBool $>
    checkEqual p (inferType fs env thenExpr) (inferType fs env elseExpr)
-- APP
inferType fs env (EApp p fsym argExpr) =
    case lookup fsym fs of
        Nothing -> Left (p, EUndefinedFunction fsym)
        Just (argType, resType) ->
            checkType fs env argExpr argType $>
            Right resType
-- UNIT
inferType _ _ (EUnit _) =
    Right TUnit
-- PAIR
inferType fs env (EPair p fstExpr sndExpr) =
    case ((inferType fs env fstExpr), (inferType fs env sndExpr)) of
        (Left err, _) -> Left err
        (_, Left err) -> Left err
        (Right fstType, Right sndType) -> Right $ TPair fstType sndType
-- FST
inferType fs env (EFst p pair) =
    case inferType fs env pair of
        Left err -> Left err
        Right (TPair fstType _) -> Right fstType
        Right otherType -> Left (p, ENotAPair otherType)
-- SND
inferType fs env (ESnd p pair) =
    case inferType fs env pair of
        Left err -> Left err
        Right (TPair _ sndType) -> Right sndType
        Right otherType -> Left (p, ENotAPair otherType)
-- NIL
inferType _ _ (ENil p listType) =
    Right listType
-- CONS
inferType fs env (ECons p headExpr tailExpr) =
    case ((inferType fs env headExpr), (inferType fs env tailExpr)) of
        (_, Left err) -> Left err
        (Left err, _) -> Left err
        (Right headType, (Right (TList elemsType))) -> case headType == elemsType of
            True -> Right (TList elemsType)
            False -> Left (p, ETypeMismatch elemsType headType)
        (_, Right otherType) -> Left (p, ENotAList otherType)

-- MATCH LIST
inferType fs env (EMatchL p listExpr nilExpr (headVar, tailVar, consExpr)) =
    case inferType fs env listExpr of
        Left err -> Left err
        Right (TList elemsType) -> checkEqual p (inferType fs env nilExpr)
                    (inferType fs ((headVar, elemsType):(tailVar, (TList elemsType)):env) consExpr)
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
    case ev fs env e of
        Just (VNum res) -> Value res
        Just _ -> undefined
        Nothing -> RuntimeError
    where
        fs = zip (map (\ (FunctionDef _ name _ _ _ _) -> name) funcDefs)
            (map (\ (FunctionDef _ _ arg _ _ bodyExpr) -> (arg, bodyExpr)) funcDefs)
        env = map (\ (var, val) -> (var, (VNum val))) args

-- UNIVERSAL EVALUATING PREDICATE
ev :: [(FSym, (Var, Expr p))] -> [(Var, Value)] -> Expr p -> Maybe Value
-- VAR
ev _ env (EVar _ var) =
    lookup var env
-- NUM
ev _ _ (ENum _ val) =
    Just $ VNum val
-- BOOL
ev _ _ (EBool _ val) =
    Just $ VBool val
-- UNARY
ev fs env (EUnary _ op expr) =
    case ev fs env expr of
        Just val -> evUOp op val
        Nothing -> Nothing
-- BINARY
ev fs env (EBinary _ op expr1 expr2) =
    case ((ev fs env expr1), (ev fs env expr2)) of
        (Just val1, Just val2) -> evBOp op val1 val2
        _ -> Nothing
-- LET
ev fs env (ELet _ newVar varExpr inExpr) =
    case ev fs env varExpr of
        Just newVal -> ev fs ((newVar, newVal):env) inExpr
        Nothing -> Nothing
-- IF
ev fs env (EIf _ condExpr thenExpr elseExpr) =
    case ev fs env condExpr of
        Just (VBool True) -> ev fs env thenExpr
        Just (VBool False) -> ev fs env elseExpr
        _ -> Nothing
-- APP
ev fs env (EApp _ fsym argExpr) =
    case ev fs env argExpr of
        Just argVal -> ev fs [(argName, argVal)] funcBody
        Nothing -> Nothing
    where Just (argName, funcBody) = lookup fsym fs
-- UNIT
ev _ _ (EUnit _) =
    Just VUnit
-- PAIR
ev fs env (EPair _ fstExpr sndExpr) =
    case ((ev fs env fstExpr), (ev fs env sndExpr)) of
        (Just fstVal, Just sndVal) -> Just $ VPair fstVal sndVal
        _ -> Nothing
-- FST
ev fs env (EFst _ pair) =
    case ev fs env pair of
        Just (VPair fstVal _) -> Just fstVal
        Nothing -> Nothing
-- SND
ev fs env (ESnd _ pair) =
    case ev fs env pair of
        Just (VPair _ sndVal) -> Just sndVal
        Nothing -> Nothing
-- NIL
ev _ _ (ENil _ _) =
    Just $ VList []
-- CONS
ev fs env (ECons _ headExpr tailExpr) =
    case ((ev fs env headExpr), (ev fs env tailExpr)) of
        (Just newVal, Just (VList vals)) -> Just $ VList (newVal:vals)
        _ -> Nothing
-- MATCH LIST
ev fs env (EMatchL _ list nilExpr (headVar, tailVar, consExpr)) =
    case ev fs env list of
        Just (VList []) -> ev fs env nilExpr
        Just (VList (h:t)) -> ev fs ((headVar, h):(tailVar, (VList t)):env) consExpr
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
