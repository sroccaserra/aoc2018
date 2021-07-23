module Common
  where

import Text.ParserCombinators.ReadP

parseLines :: ReadP a -> IO [a]
parseLines parser = map (parseLine parser) . lines <$> getContents
  where
    parseLine :: ReadP a -> String -> a
    parseLine p = fst . last . readP_to_S p
