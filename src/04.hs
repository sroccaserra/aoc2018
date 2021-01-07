import Data.Char
import Data.Function
import Data.List
import Data.Ord
import Data.Set (Set)
import qualified Data.Set as Set
import Text.ParserCombinators.ReadP

partOne xs = guardId * minute
  where grouped = foldl groupByShift [] xs
        sleepPeriodsById = map (\(id, xs) -> (id, sleepPeriods xs)) grouped
        sleepMinutesById = map (\(id, xs) -> (id, foldl markSleepMinutes Set.empty xs)) sleepPeriodsById
        sleepSizesById = map (\(id, xs) -> (id, Set.size xs)) sleepMinutesById
        totalSleepMinutesById = map (foldl1 (\(id, s) (_, x) -> (id, s+x))) $ groupBy ((==) `on` fst) $ sort sleepSizesById
        (guardId, _) = foldl1 (\(idm, xm) (id, x) -> if x > xm then (id, x) else (idm, xm)) totalSleepMinutesById
        occurences = uniqC $ concatMap (Set.toList . snd) $ filter (\(id, _) -> id == guardId) sleepMinutesById
        (_,minute) = maximumBy (comparing fst) occurences

partTwo xs = guardId * minute
  where grouped = foldl groupByShift [] xs
        sleepPeriodsById = map (\(id, xs) -> (id, sleepPeriods xs)) grouped
        sleepMinutesById = map (\(id, s) -> (id, Set.toList s)) $ map (\(id, xs) -> (id, foldl markSleepMinutes Set.empty xs)) sleepPeriodsById
        groupedMinutesById = map (foldl1 (\(id, xs) (_, ys) -> (id, concat [xs, ys]))) $ groupBy ((==) `on` fst) $ sort sleepMinutesById
        uniqued = map (\(id, xs) -> (id, uniqC xs)) groupedMinutesById
        maxMinutesById = map (\(id, xs) -> (id, maximumBy (comparing fst) xs)) $ filter (\(_, xs) -> xs /= []) uniqued
        (guardId, (_, minute)) = maximumBy (comparing $ fst . snd ) maxMinutesById

data Event = Shift Id
           | Asleep Timestamp
           | Awake Timestamp
           deriving (Show, Eq)

type Timestamp = Int
type Id = Int

groupByShift :: [(Int, [Event])] -> Event -> [(Id, [Event])]
groupByShift xs (Shift id) = (id, []):xs
groupByShift ((id, evs):xs) x = (id, evs++[x]):xs

sleepPeriods :: [Event] -> [(Int, Int)]
sleepPeriods [] = []
sleepPeriods (x:y:xs) = (sleepPeriods xs) ++ [sleepPeriod x y]

sleepPeriod :: Event -> Event -> (Int, Int)
sleepPeriod (Asleep x) (Awake y) = (x, pred y)

markSleepMinutes :: Set Int -> (Int, Int) -> Set Int
markSleepMinutes s (start, end) = foldl (\s x -> Set.insert x s) s [start..end]

uniqC :: Ord a => [a] -> [(Int, a)]
uniqC xs = map f $ group $ sort xs
  where f xs = (length xs, head xs)

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
  print $ partOne $ parse input
  print $ partTwo $ parse input
