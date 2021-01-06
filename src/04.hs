import Data.Char
import Data.Ord
import Data.Function
import Data.List
import Text.ParserCombinators.ReadP


solve xs = grouped
  where grouped = foldl step [] xs
        sleepTimesById = groupBy ((==) `on` fst) $ map (\(id, xs) -> (id, sleepTimes xs)) grouped
        sleepTimeSumById = map (foldl1 (\(id, x) (_, y)-> (id, x+y))) sleepTimesById
        m = maximumBy (comparing snd) sleepTimeSumById

step xs (Shift id) = (id, []):xs
step ((id, evs):xs) x = (id, evs++[x]):xs

data Event = Shift Id
           | Asleep Timestamp
           | Awake Timestamp
           deriving (Show, Eq)

type Timestamp = Int
type Id = Int

sleepTime (Asleep x) (Awake y) = y - x

sleepTimes [] = 0
sleepTimes (x:y:xs) = (sleepTime x y) + (sleepTimes xs)

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
