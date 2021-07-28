import Data.Array ((//), (!))
import Data.Char (chr, ord)
import Data.Graph
import Text.ParserCombinators.ReadP

import Common (getParsedLines)

main = do
  input <- getParsedLines 7 parser
  print $ partOne input

partOne input = map chr $ snd $ (iterate step (g, [])) !! 26
  where
    g = buildG (minVertex, maxVertex) input
    minVertex = ord 'A'
    maxVertex = ord 'Z'

step :: (Graph, [Vertex]) -> (Graph, [Vertex])
step (g, is) = (g' // [(next, done)], is ++ [next])
  where
    next = findNext g
    g' = filter (/= next) <$> g
    done = [-1]

findNext :: Graph -> Vertex
findNext g = head [i | i <- vertices g, [] == g ! i]

parser :: ReadP Edge
parser = do
  b <- string "Step " *> get
  a <- string " must be finished before step " *> get
  return (ord a, ord b)
