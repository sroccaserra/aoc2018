import Data.Char
import Data.Map (Map, (!))
import qualified Data.Map as Map
import Text.ParserCombinators.ReadP

main = do
  points <- (map parseLine . lines) <$> getContents
  mapM_ putStrLn $ partOne points

partOne ps = map namePoint <$> coordsGrid
  where namePoint p = Map.findWithDefault '.' p pointNames
        pointNames :: Map (Int, Int) Char
        pointNames = Map.fromList $ zip ps symbols
        maxX = maximum $ map fst ps
        maxY = maximum $ map snd ps
        coordsGrid = map (\y -> (map (flip (,) y) [0..maxX])) [0..maxY]

parseLine = fst . last . readP_to_S point

point = (,) <$> int <*> (string ", " *> int)

int :: ReadP Int
int = read <$> munch1 isDigit

symbols = (map chr [97..122]) ++ (map chr [65..90])
