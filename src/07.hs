import Text.ParserCombinators.ReadP

import Common (getParsedLines)

main = do
  input <- getParsedLines 7 parser
  print $ partOne input

partOne = id

parser :: ReadP (Char, Char)
parser = (,) <$> (string "Step " *> get) <*> (string " must be finished before step " *> get)
