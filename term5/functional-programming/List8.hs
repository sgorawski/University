import Data.List

-- 1


cantor :: [a] -> [b] -> [b] -> [(a, b)]
cantor xs window ys = case ys of
    (y:ys) -> let wnd = y:window in zip xs wnd ++ cantor xs wnd ys
    [] -> case xs of
        (_:xs) -> zip xs window ++ cantor xs window ys
        [] -> []

(><) :: [a] -> [b] -> [(a, b)]
(><) xs ys = cantor xs [] ys

-- 2

f :: [Integer] -> [Integer]
f [] = error "Empty list"
f (x:xs) = [n | n <- xs, n `mod` x /= 0]

primes :: [Integer]
primes = map head $ iterate f [2..]

-- 3

primes' :: [Integer]
primes' = 2 : [p | p <- [3..], all (\q -> p `mod` q /= 0) (takeWhile (\q -> q * q <= p) primes')]

-- 4

fib :: [Integer]
fib = 1 : 1 : zipWith (+) fib (tail fib)

-- 5

iperm :: [a] -> [[a]]
iperm = foldr (concatMap . insEverywhere) [[]]
    where insEverywhere :: a -> [a] -> [[a]]
          insEverywhere x [] = [[x]]
          insEverywhere x l@(y:ys) = (x:l) : map (y:) (insEverywhere x ys)

sperm :: [a] -> [[a]]
sperm [] = [[]]
sperm xs = [y:zs | (y, ys) <- sel xs, zs <- sperm ys]
    where sel :: [a] -> [(a, [a])]
          sel [] = []
          sel (x:xs) = (x, xs) : [(y, x:ys) | (y, ys) <- sel xs]

-- 6

sublist :: [a] -> [[a]]
sublist [] = [[]]
sublist (x:xs) = prev ++ map (x:) prev
    where prev = sublist xs

-- 7

qsortBy :: (a -> a -> Bool) -> [a] -> [a]
qsortBy _ [] = []
qsortBy cmp (x:xs) = qsortBy cmp [y | y <- xs, cmp x y] ++ [x] ++ qsortBy cmp [y | y <- xs, not $ cmp x y]

-- 8

data Tree a = Node (Tree a) a (Tree a) | Leaf

treeInsert :: Ord a => a -> Tree a -> Tree a
treeInsert x Leaf = Node Leaf x Leaf
treeInsert x t@(Node left a right)
    | x == a = t
    | x < a = Node (treeInsert x left) a right
    | x > a = Node left a $ treeInsert x right

treeFromList :: Ord a => [a] -> Tree a
treeFromList = foldr treeInsert Leaf

listFromTree :: Ord a => Tree a -> [a]
listFromTree Leaf = []
listFromTree (Node left a right) = listFromTree left ++ [a] ++ listFromTree right

treeUnion :: Ord a => Tree a -> Tree a -> Tree a
treeUnion t1 t2 = foldr treeInsert t1 $ listFromTree t2

treeIntersection :: Ord a => Tree a -> Tree a -> Tree a
treeIntersection t1 t2 = foldr treeInsert Leaf common
    where common = intersect (listFromTree t1) (listFromTree t2)

treeSub :: Ord a => Tree a -> Tree a -> Tree a
treeSub t1 t2 = foldr treeInsert Leaf onlyFirst
    where onlyFirst = (listFromTree t1) \\ (listFromTree t2)

treeMember :: Ord a => a -> Tree a -> Bool
treeMember _ Leaf = False
treeMember x (Node left a right)
    | x == a = True
    | x < a = treeMember x left
    | x > a = treeMember x right

data Set a = Fin (Tree a) | Cofin (Tree a)

setFromList :: Ord a => [a] -> Set a
setFromList xs = Fin (treeFromList xs)

setEmpty :: Ord a => Set a
setEmpty = Fin Leaf

setFull :: Ord a => Set a
setFull = Cofin Leaf

setUnion :: Ord a => Set a -> Set a -> Set a
setUnion (Fin t1) (Fin t2) = Fin $ treeUnion t1 t2
setUnion (Cofin t1) (Cofin t2) = Cofin $ treeIntersection t1 t2
setUnion (Cofin t1) (Fin t2) = Cofin $ treeSub t1 t2
setUnion f c = setUnion c f

setIntersection :: Ord a => Set a -> Set a -> Set a
setIntersection (Fin t1) (Fin t2) = Fin $ treeIntersection t1 t2
setIntersection (Cofin t1) (Cofin t2) = Cofin $ treeUnion t1 t2
setIntersection (Fin t1) (Cofin t2) = Fin $ treeSub t1 t2
setIntersection c f = setIntersection f c

setComplement :: Ord a => Set a -> Set a
setComplement (Fin t) = Cofin t
setComplement (Cofin t) = Fin t

setMember :: Ord a => a -> Set a -> Bool
setMember x (Fin t) = x `treeMember` t
setMember x (Cofin t) = not $ x `treeMember` t
