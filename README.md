## Démarrer un nouveau projet

```
$ stack new aoc2018
$ stack setup
$ stack build
```

## Usage

```
$ awk -f src/03.awk src/03.txt | stack runhaskell -- src/03.hs
```

## Learnings

Voir aussi :
- <https://github.com/sroccaserra/aoc2015#learnings>
- <https://github.com/sroccaserra/aoc2019#learnings>
- <https://github.com/sroccaserra/aoc2020#learnings>

### Haskell

- Générer une liste de liste de coordonnées (par exemple `[[(Int, Int)]]`) :
    - `coordsGrid = map (\y -> (map (flip (,) y) [0..maxX])) [0..maxY]`
- Appliquer une fonction sur toutes les coordonnées d'une liste de liste :
    - `map f <$> coordsGrid`
