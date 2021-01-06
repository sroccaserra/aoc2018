import Data.Char
import Data.Ord
import Data.Function
import Data.Set (Set)
import qualified Data.Set as Set
import Data.List
import Text.ParserCombinators.ReadP


solve xs = sleepMinutesById
  where grouped = foldl step [] xs
        sleepPeriodsById = map (\(id, xs) -> (id, sleepPeriods xs)) grouped
        sleepMinutesById = map (\(id, xs) -> (id, foldl markSleepMinutes Set.empty xs)) sleepPeriodsById

step xs (Shift id) = (id, []):xs
step ((id, evs):xs) x = (id, evs++[x]):xs

data Event = Shift Id
           | Asleep Timestamp
           | Awake Timestamp
           deriving (Show, Eq)

type Timestamp = Int
type Id = Int

markSleepMinutes s (start, end) = foldl (\s x -> Set.insert x s) s [start..end]

sleepPeriod (Asleep x) (Awake y) = (x, pred y)

sleepPeriods [] = []
sleepPeriods (x:y:xs) = (sleepPeriods xs) ++ [sleepPeriod x y]

---
-- Parsing and main

parse = map parseLine . sort . lines

parseLine = fst . last . readP_to_S (choice [shift, awake, asleep])

timestamp :: ReadP Timestamp
timestamp =
  (munch1 $ not . isSpace) *> string " " *>
  (munch1 isDigit *> string ":") *> (read <$> munch1 isDigit)
  <* string "] "

shift = timestamp *> string "Guard #" *> (Shift . read <$> munch1 isDigit)
awake = Awake <$> timestamp <* string "wakes up"
asleep = Asleep <$> timestamp <* string "falls asleep"

main = do
  input <- getContents
  mapM_ print $ solve $ parse input
