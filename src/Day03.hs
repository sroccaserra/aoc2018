module Day03 where

import qualified Data.Map as M

main :: IO ()
main = do
  ls <- fmap lines getContents
  print $ partTwo ls

partOne :: [String] -> Int
partOne ls = M.size $ M.filter (> 1) fabric
  where
    fabric = foldr addPoints M.empty claims
    claims = map createClaim numbers
    numbers = map parseLine ls

partTwo :: [String] -> [Claim]
partTwo ls = filter (\ c -> 1 == (foldr max 0 $ heights fabric c)) claims
  where
    fabric = foldr addPoints M.empty claims
    claims = map createClaim numbers
    numbers = map parseLine ls

parseLine :: String -> [Int]
parseLine = map read . words

createClaim [i, x, y, w, h] = Claim i x y (x+w-1) (y+h-1)

data Claim = Claim {
  i :: Int,
  x1 :: Int,
  y1 :: Int,
  x2 :: Int,
  y2 :: Int
} deriving (Show)

type Point = (Int, Int)
type Points = [Point]

type Fabric = M.Map Point Int

points :: Claim -> Points
points r = do
  x <- [x1 r..x2 r]
  y <- [y1 r..y2 r]
  return (x, y)

addPoints :: Claim -> Fabric -> Fabric
addPoints c f = foldr addPoint f $ points c

addPoint :: Point -> Fabric -> Fabric
addPoint p f =
  M.alter (Just . maybe 1 succ) p f

heights :: Fabric -> Claim -> [Int]
heights f c = [maybe 0 id $ M.lookup y f | y <- ps]
  where ps = points c
