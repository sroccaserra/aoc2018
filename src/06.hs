import Data.Ord
import Data.List
import Data.Ix (range)
import Data.Map (Map, (!))
import qualified Data.Map as Map
import qualified Data.Set as Set
import Text.ParserCombinators.ReadP

import Common (getParsedLines, unsigned)

main = do
  input <- getParsedLines 6 point
  putStrLn $ partOne input

partOne ps = showAsciiGrid '.' m
  where
    m = Map.fromList $ zip ps symbols

distance (Point x1 y1) (Point x2 y2) = abs (x2 - x1) + abs (y2 - y1)

data Point = Point !Int !Int
           deriving (Show, Eq, Ord)

_x (Point x _) = x
_y (Point _ y) = y

showAsciiGrid :: Char -> Map Point Char -> String
showAsciiGrid c m = unlines $ do
    y <- [minY..maxY]
    return [Map.findWithDefault c (Point x y) m | x <- [minX..maxX]]
  where
    (Point minX minY, Point maxX maxY) = boundingBox m

boundingBox :: Map Point a -> (Point, Point)
boundingBox m = (Point (minimum xs) (minimum ys), Point (maximum xs) (maximum ys))
  where
    points = Map.keysSet m
    xs = Set.map _x points
    ys = Set.map _y points

point :: ReadP Point
point = Point <$> unsigned <* string ", " <*> unsigned

symbols = range ('a', 'z') ++ range ('A', 'Z')
