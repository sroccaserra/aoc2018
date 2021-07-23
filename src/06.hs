import Data.Ord
import Data.List
import Data.Ix (range)
import Data.Map (Map, (!))
import qualified Data.Map as Map
import Text.ParserCombinators.ReadP

import Common (parseLines, unsigned)

main = do
  input <- parseLines point
  mapM_ putStrLn $ partOne input

partOne ps = map (namePoint . closestPoint ps) <$> gridForPoints ps
  where
      namePoint p = Map.findWithDefault '.' p pointNames
      pointNames = Map.fromList $ zip ps symbols

gridForPoints ps = map (\y -> (map (flip (,) y) [0..maxX])) [0..maxY]
  where
      maxX = maximum $ map fst ps
      maxY = maximum $ map snd ps

closestPoint ps p = fst $ minimumBy (comparing snd) $ map (\x -> (x, distance p x)) ps
  where
      coords = gridForPoints ps

distance (x1, y1) (x2, y2) = abs (x2 - x1) + abs (y2 -y1)

point :: ReadP (Int, Int)
point = (,) <$> unsigned <* string ", " <*> unsigned

symbols = range ('a', 'z') ++ range ('A', 'Z')
