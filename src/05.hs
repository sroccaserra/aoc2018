import Data.Char
import Data.List

partOne = length . fullReact

partTwo xs = minimum lengths
  where letters = sort $ nub $ map toLower $ xs
        lengths = map (\c -> partOne $ exclude c xs) letters

fullReact :: String -> String
fullReact = foldr step ""
  where step x (y:ys) | doesReact x y = ys
        step x ys = x:ys

doesReact x y = x /= y && toUpper x == toUpper y

exclude c = filter ((/= c) . toLower)

main = do
  input <- getContents
  print $ partOne $ head $ lines input
  print $ partTwo $ head $ lines input
