import Data.Char
import Control.Applicative
import Text.ParserCombinators.ReadP

main = interact $ show . partOne . (map parseLine) . lines

partOne = sum

---
-- parsing

parseLine :: String -> Int
parseLine = fst . last . readP_to_S (sign <*> decimal)

decimal :: ReadP Int
decimal = read <$> munch1 isDigit

sign :: ReadP (Int -> Int)
sign = (id <$ char '+') <|> (negate <$ char '-')
