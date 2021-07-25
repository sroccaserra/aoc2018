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

distance (x1, y1) (x2, y2) = abs (x2 - x1) + abs (y2 -y1)

type Point = (Int, Int)

showAsciiGrid :: Char -> Map Point Char -> String
showAsciiGrid c m = unlines $ do
    y <- [minY..maxY]
    return [Map.findWithDefault c (x, y) m | x <- [minX..maxX]]
  where
    points = Map.keysSet m
    xs = Set.map fst points
    ys = Set.map snd points
    maxX = maximum xs
    minX = minimum xs
    maxY = maximum ys
    minY = minimum ys

point :: ReadP Point
point = (,) <$> unsigned <* string ", " <*> unsigned

symbols = range ('a', 'z') ++ range ('A', 'Z')
