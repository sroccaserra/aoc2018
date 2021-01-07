import Data.Char

simplify :: String -> String
simplify = foldr step ""
  where step x (y:ys) | doesReact x y = ys
        step x ys = x:ys

doesReact x y = x /= y && toUpper x == toUpper y

main = do
  input <- getContents
  print $ length $ simplify $ head $ lines input
