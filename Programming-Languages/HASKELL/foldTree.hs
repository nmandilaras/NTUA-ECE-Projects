{-# OPTIONS_GHC -rtsopts -O2 -optc-O2 #-}
import Test.QuickCheck
import Data.Functor
import Control.Applicative
import Control.Monad
import Data.Ratio

data Tree a = T a [Tree a]
	deriving Show

bird :: Tree Rational
bird = T 1 ((mapTree auxOne bird): (mapTree auxTwo bird):[]) 
	where auxOne x = 1/(x + 1)
	      auxTwo x = 1/x + 1	

instance Arbitrary a => Arbitrary (Tree a) 
	where arbitrary = sized arbTree

arbTree :: Arbitrary a => Int -> Gen (Tree a)
arbTree 0 = do
    a <- arbitrary
    return $ T a []
arbTree n = do
    (Positive m) <- arbitrary
    --m <- choose (1, n `div` 2 +1)
    let n' = n `div` (m+1) 
    f <- replicateM m (arbTree n')
    a <- arbitrary
    return $ T a f 	
	
foldTree :: (a->[b]->b) -> Tree a -> b
foldTree f (T a ts) = f a (aux f ts)
	where aux f (t@(T c zs):ts) = f c (aux f zs) : aux f ts 
	      aux f [] = []

sizeTree t = foldTree auxSize t
	where auxSize x bs = foldr (+) 1 bs

heightTree t = foldTree auxHeight t
	where auxHeight x [] = 1
	      auxHeight x bs = 1 + maximum(bs)

sumTree t = foldTree auxSum t
	where auxSum x bs = foldr (+) x bs
	
maxTree t = foldTree auxMax t
	where auxMax x [] = x
	      auxMax x bs = if x > y then x else y
				where y = maximum(bs)

inTree x t = foldTree (auxIn x)  t  
	where auxIn x y bs = if x==y then True else if elem True bs then True else False

nodes t = foldTree auxNode t
	where auxNode x bs = foldr (++) [x] bs

countTree f t = foldTree (auxCount f) t
	where auxCount f x bs = if (f x) == True then foldr (+) 1 bs else foldr (+) 0 bs

leaves t = foldTree auxLeave t 
	where auxLeave x [] = [x]
	      auxLeave x bs = foldr (++) [] bs	 

mapTree f t = foldTree (auxMap f)  t 
	where auxMap f x bs = T (f x) bs   

--foldTree :: (a->[b]->b) -> Tree a -> b
foldTreeT f (T a ts) = f 1 a (aux 2 f ts)
        where aux acc f (t@(T c zs):ts) = f acc c (aux (acc+1) f zs) : aux acc f ts
              aux acc f [] = []

trimTree n t = foldTreeT (auxTrim n) t
        where auxTrim n acc x bs = if n<=acc then T x [] else T x bs

path [] (T a t) = a 
path (l:ls) (T a t) = aux ls (drop l t)
	where aux hs (t:ts) = path hs t

heightSize :: (Tree Char) -> Bool
heightSize t = (heightTree t) <= (sizeTree t) 	

maxIn :: (Tree Int) -> Bool
maxIn t = inTree (maxTree t) t

allNodes :: (Tree Char) -> Bool
allNodes t = aux (nodes t) t 
	where aux (z:zs) t = inTree z t && aux zs t
	      aux [] t = True

auxs a | a>4 = True
       | a<=4 = False

countHeight :: (Tree Int) -> Bool
countHeight t = countTree auxs t <= sizeTree t  	

sizeCount :: (Tree Char) -> Bool
sizeCount t = size == length (nodes t) && ( size > ( length $ leaves t) || size == 1)
	where size = sizeTree t

sizeCountTwo :: (Tree Bool) -> Bool
sizeCountTwo t = sizeTree t == (countTree (True ||) t) 

sizeMap :: (Tree Int) -> Bool
sizeMap t = sizeTree t == sizeTree experiment && heightTree t == heightTree experiment 
	where experiment = mapTree (5+) t

checkMap :: Int -> (Tree Int) -> Bool
checkMap m t = if inTree m t then inTree (aux m) (mapTree aux t) else True	  
		where aux = (+5)

strangeThing :: (Tree Int) -> Bool
strangeThing t =  ((map (+5)) . nodes) t == (nodes . (mapTree (+5))) t && ((map (+5)) . leaves) t == (leaves . (mapTree (+5))) t

--pathBird :: [Int] -> Bool
--pathBird l = path l bird == path l (trimTree (length l) bird) 

zigZag :: [Int]
zigZag = 1 : 0 : zigZag

from n = n : from (n + 1)

fibs =  1 : 2 : sumlists fibs (tail fibs)
	where sumlists (x:xs) (y:ys) = (x + y) : sumlists xs ys

pathBird [] (T a t) = []
pathBird (l:ls) (T a t) = a : (aux ls (drop l t))
        where aux hs (t:ts) = pathBird hs t

pathBirdTwo [] (T a t) = []
pathBirdTwo (l:ls) (T a t) = (denominator a) : (aux ls (drop l t))
        where aux hs (t:ts) = pathBirdTwo hs t


{-|
t = T 'a' [ T 'b' []
          , T 'c' [ T 'e' [ T 'h' [] ]
                  , T 'f' []
                  ]
          , T 'd' [T 'g' []]
          ]

t' = T 1 [ T 2 []
          , T 3 [ T 4 []
                  , T 5 []
                  ]
          , T 6 [T 7 [ T 8 []]]
          ]
|-}		
		
--main for checking the second exercise 	
	
{-|	   
main = do
	print (sizeTree t') 
    print (heightTree t')
	print (sumTree t')
	print (maxTree t')
    print (inTree 'b' t)
    print (nodes t')
    print (countTree (5>) t')
    print (leaves t)
	print (mapTree (+0) t')
	print (trimTree 3 t')
	print (path [1,0,0] t)
|-}		
		
--main for the first part of third exercise	
	
{-|
main = do
     quickCheck heightSize
     quickCheck maxIn
     quickCheck allNodes
     quickCheck countHeight
     quickCheck sizeCount	
     quickCheck sizeMap
     quickCheck checkMap
     quickCheckWith stdArgs { maxSuccess = 10000 } strangeThing
|-}			 

--main for the second part of third exercise

{-|		 
main = do
   print (pathBird (take 100000 zigZag) bird == take 100000 (from 1))
   print (pathBirdTwo (replicate 10000 0) bird == take 10000 fibs)     	
   quickCheck $ forAll (listOf (choose (0, 1))) $ \l -> 
	path l bird == path l (trimTree ((length l)+1) bird)	
	
|-}	