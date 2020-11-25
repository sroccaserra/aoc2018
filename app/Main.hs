module Main where

import qualified Data.Map as M

main = do
  lines <- fmap lines getContents
  print $ process lines

process ls = map points rectangles
  where
    rectangles = map createRectangle numbers
    numbers = map parseLine ls

parseLine :: String -> [Int]
parseLine = map read . words

createRectangle [n, x, y, w, h] = Rectangle {n = n, x1 = x, y1 = y, x2 = x+w-1, y2 = y+h-1}

data Rectangle = Rectangle {
  n :: Int,
  x1 :: Int,
  y1 :: Int,
  x2 :: Int,
  y2 :: Int
} deriving (Show)

points r = do
  x <- [x1 r..x2 r]
  y <- [y1 r..y2 r]
  return (x, y)
