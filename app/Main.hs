module Main where

import qualified Data.Map as M
import qualified Data.Set as S

main = do
  lines <- fmap lines getContents
  print $ process lines

process ls = M.size $ M.filter (> 1) claims
  where
    claims = foldr addPoints M.empty rectangles
    rectangles = map createClaim numbers
    numbers = map parseLine ls

parseLine :: String -> [Int]
parseLine = map read . words

createClaim [n, x, y, w, h] = Claim {n = n, x1 = x, y1 = y, x2 = x+w-1, y2 = y+h-1}

data Claim = Claim {
  n :: Int,
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
  case M.lookup p f of
       Just n -> M.insert p (n+1) f
       Nothing -> M.insert p 1 f
