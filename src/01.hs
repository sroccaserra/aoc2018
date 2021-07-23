import Data.Char
import Data.Maybe (fromJust)
import Data.Set (insert, member)
import qualified Data.Set as Set
import Control.Applicative
import Text.ParserCombinators.ReadP

main = do
    contents <- getContents
    let input = map parseLine $ lines contents
    print $ partOne input
    print $ partTwo input

partOne = sum

partTwo = fromJust . firstDuplicate . scanl1 (+) . cycle

firstDuplicate :: [Int] -> Maybe Int
firstDuplicate = go Set.empty
  where
    go s (x:xs)
      | member x s = Just x
      | otherwise = go (insert x s) xs
    go _ [] = Nothing

---
-- parsing

parseLine :: String -> Int
parseLine = fst . last . readP_to_S (sign <*> decimal)

decimal :: ReadP Int
decimal = read <$> munch1 isDigit

sign :: ReadP (Int -> Int)
sign = (id <$ char '+') <|> (negate <$ char '-')
