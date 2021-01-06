import Data.Char
import Data.List
import Text.ParserCombinators.ReadP

data Event = Shift Id
           | Asleep Timestamp
           | Awake Timestamp
           deriving (Show)

type Timestamp = (Int, Int)
type Id = Int

parse = map parseLine . sort . lines

parseLine = fst . last . readP_to_S (choice [shift, awake, asleep])

timestamp :: ReadP Timestamp
timestamp =
  (munch1 $ not . isSpace) *> string " " *>
  ((,) <$> (read <$> munch1 isDigit <*string ":") <*> (read <$> munch1 isDigit))
  <* string "] "

shift = timestamp *> string "Guard #" *> (Shift . read <$> munch1 isDigit)
awake = Awake <$> timestamp <* string "wakes up"
asleep = Asleep <$> timestamp <* string "falls asleep"

main = do
  input <- getContents
  mapM_ print $ map show $ parse input
