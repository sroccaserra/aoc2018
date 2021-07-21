import Data.Char
import Text.ParserCombinators.ReadP

main = interact $ show . partOne . (map parseLine) . lines

partOne = id

parseLine = fst . last . readP_to_S point

point = (,) <$> int <*> (string ", " *> int)

int :: ReadP Int
int = read <$> munch1 isDigit
