import Data.List
import Data.Maybe

import Common (getLines)

main = do
  input <- getLines 2
  print $ partOne input

partOne boxIds = numberOfSame 2 boxIds * numberOfSame 3 boxIds
  where
    numberOfSame n = length . filter id . map (hasNSames n)
    hasNSames n = isJust . find (== n) . map length . group . sort
