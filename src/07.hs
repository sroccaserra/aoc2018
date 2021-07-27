import qualified Data.Array as A
import Data.Maybe
import Data.Foldable
import Data.Char
import Data.Graph
import Text.ParserCombinators.ReadP

import Common (getParsedLines)

main = do
  input <- getParsedLines 7 parser
  print $ partOne input

partOne input = findNext g
  where
    g = buildG (minVertex, maxVertex) input
    minVertex = vertexFromLabel 'A'
    maxVertex = vertexFromLabel 'Z'

findNext g = labelFromVertex $ fst $ fromJust (find ((== []) . snd) $ A.assocs g)

labelFromVertex = chr
vertexFromLabel = ord

parser :: ReadP Edge
parser = do
  b <- string "Step " *> get
  a <- string " must be finished before step " *> get
  return (vertexFromLabel a, vertexFromLabel b)
