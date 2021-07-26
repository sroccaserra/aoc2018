import Data.Ix (range)
import Data.Map (Map)
import qualified Data.Map as M
import Text.ParserCombinators.ReadP

import Common (getParsedLines, unsigned, Coord(..), _x, _y)

main = do
  input <- getParsedLines 6 point
  putStrLn $ partOne input

partOne points = showAsciiGrid '.' m
  where
    m = M.fromList $ zip points symbols
    symbols = range ('a', 'z') ++ range ('A', 'Z')

distance (Coord x1 y1) (Coord x2 y2) = abs (x2 - x1) + abs (y2 - y1)

showAsciiGrid :: Char -> Map Coord Char -> String
showAsciiGrid c m = unlines $ do
    y <- [minY..maxY]
    return [M.findWithDefault c (Coord x y) m | x <- [minX..maxX]]
  where
    (Coord minX minY, Coord maxX maxY) = boundingBox m

boundingBox :: Map Coord a -> (Coord, Coord)
boundingBox m = (Coord (minimum xs) (minimum ys), Coord (maximum xs) (maximum ys))
  where
    points = M.keys m
    xs = map _x points
    ys = map _y points

point :: ReadP Coord
point = Coord <$> unsigned <* string ", " <*> unsigned
