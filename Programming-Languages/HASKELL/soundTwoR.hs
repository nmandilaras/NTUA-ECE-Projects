{-# OPTIONS_GHC -O2 -optc-O2` #-}

import Data.Char (isSpace)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BSC

main = 
  do all <- BS.getContents
     let Just (n, r1) = readInt all
     let Just (m, r2) = readInt r1
     let (x, _)  = readMany readInt r2
     let modAd a = if a `mod` m == 0 then (a `div` m) else  (a `div` m + 1)
     let soundTwo [] acc [] = acc
         soundTwo [x] acc [] = acc  
         soundTwo [x] acc (z:zs) = soundTwo [z] (acc + (modAd (z-x) )) zs 
         soundTwo (x:y:xs) acc [] = if y > x then soundTwo (y:xs) (acc + (modAd (y-x) )) [] else soundTwo (y:xs) acc [x] 
         soundTwo (x:y:xs) acc zs = if y > x then soundTwo (y:xs) arg1  arg2 else soundTwo (y:xs) acc (x:zs)
	   where (arg1,arg2) = aux x y acc zs
	         aux x y acc [] = (acc + (modAd (y-x) ) ,[])
	         aux x y acc (z:zs) = if z < y then aux z  y (acc + (modAd (z-x) )) zs else (acc + (modAd (y-x) ),(z:zs))	
     print (soundTwo x 0 [])
  where readInt s = BSC.readInt (BSC.dropWhile isSpace s)
        readInteger s = BSC.readInteger (BSC.dropWhile isSpace s)
        readMany readf s = case readf s of
          Just (x, r) -> let (xs, t) = readMany readf r
                         in  (x : xs, t)
          Nothing     -> ([], s)

