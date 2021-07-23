module Common
  where

import Control.Applicative
import Data.Char
import Text.ParserCombinators.ReadP

parseLines :: ReadP a -> IO [a]
parseLines parser = map (parseLine parser) . lines <$> getContents
  where
    parseLine :: ReadP a -> String -> a
    parseLine p = fst . last . readP_to_S p

unsigned :: ReadP Int
unsigned = read <$> munch1 isDigit

sign :: ReadP (Int -> Int)
sign = (id <$ char '+') <|> (negate <$ char '-')

signed :: ReadP Int
signed = option id sign <*> unsigned
