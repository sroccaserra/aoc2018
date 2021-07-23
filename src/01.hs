import Data.Char
import Data.Maybe (fromJust)
import Data.Set (insert, member)
import qualified Data.Set as Set
import Control.Applicative
import Text.ParserCombinators.ReadP

import Common (parseLines)

main = do
    input <- parseLines $ sign <*> unsigned
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

unsigned :: ReadP Int
unsigned = read <$> munch1 isDigit

sign :: ReadP (Int -> Int)
sign = (id <$ char '+') <|> (negate <$ char '-')
