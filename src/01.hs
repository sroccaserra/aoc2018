import Data.Char
import Data.Set (Set, insert, member)
import qualified Data.Set as Set
import Control.Applicative
import Text.ParserCombinators.ReadP

main = do
    contents <- getContents
    let input = map parseLine $ lines contents
    print $ partOne input
    print $ partTwo input

partOne = sum

partTwo = result . last . takeWhile (not . found) . scanl step (False, Set.fromList [], 0) . cycle
  where
    step (_, s, freq) n = (member freq s, insert freq s, nextFreq)
      where
        nextFreq = freq + n
    found (b, _, _) = b
    result (_, _, f) = f

---
-- parsing

parseLine :: String -> Int
parseLine = fst . last . readP_to_S (sign <*> decimal)

decimal :: ReadP Int
decimal = read <$> munch1 isDigit

sign :: ReadP (Int -> Int)
sign = (id <$ char '+') <|> (negate <$ char '-')
