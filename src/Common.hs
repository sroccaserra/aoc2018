module Common
  where

import Control.Applicative
import Data.Char
import Text.ParserCombinators.ReadP
import System.Environment
import Text.Printf

getRawInput :: Int -> IO String
getRawInput n = do
  args <- getArgs
  case args of
       [] -> readFile (printf "src/%02d.txt" n)
       "-":_ -> getContents
       fileName:_ -> readFile fileName

getParsedLines :: Int -> ReadP a -> IO [a]
getParsedLines n parser = map (parseLine parser) . lines <$> getRawInput n
  where
    parseLine :: ReadP a -> String -> a
    parseLine p = fst . last . readP_to_S p

unsigned :: ReadP Int
unsigned = read <$> munch1 isDigit

sign :: ReadP (Int -> Int)
sign = (id <$ char '+') <|> (negate <$ char '-')

signed :: ReadP Int
signed = option id sign <*> unsigned

---
-- Coords

data Coord = Coord !Int !Int
           deriving (Show, Eq, Ord)

_x :: Coord -> Int
_x (Coord x _) = x

_y :: Coord -> Int
_y (Coord _ y) = y

boundingBox :: [Coord] -> (Coord, Coord)
boundingBox cs = (Coord (minimum xs) (minimum ys), Coord (maximum xs) (maximum ys))
  where
    xs = map _x cs
    ys = map _y cs
