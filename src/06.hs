import Data.Char
import Data.Ord
import Data.List
import Data.Map (Map, (!))
import qualified Data.Map as Map
import Text.ParserCombinators.ReadP

main = do
  points <- (map parseLine . lines) <$> getContents
  mapM_ putStrLn $ partOne points

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

parseLine :: String -> (Int, Int)
parseLine = fst . last . readP_to_S point

point :: ReadP (Int, Int)
point = (,) <$> int <* string ", " <*> int

int :: ReadP Int
int = read <$> munch1 isDigit

symbols = (map chr [97..122]) ++ (map chr [65..90])
