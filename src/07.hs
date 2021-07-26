import Data.Ix (range)
import qualified Data.Map as M
import Text.ParserCombinators.ReadP

import Common (getParsedLines)

main = do
  input <- getParsedLines 7 parser
  mapM_ print $ M.toList $ partOne input

partOne input = m
  where
    m = foldl (\acc (a, b) -> M.insertWith (++) a [b] acc) emptyMap input
    emptyMap = M.fromList $ zip letters (cycle [""])
    letters = range ('A', 'Z')

parser :: ReadP (Char, Char)
parser = flip (,) <$> (string "Step " *> get) <*> (string " must be finished before step " *> get)
