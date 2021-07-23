## Démarrer un nouveau projet

```
$ stack new aoc2018
$ stack setup
$ stack build
```

## Usage

```
$ stack runhaskell src/01.hs < src/01.txt
```

## Learnings

Voir aussi :
- <https://github.com/sroccaserra/aoc2015#learnings>
- <https://github.com/sroccaserra/aoc2019#learnings>
- <https://github.com/sroccaserra/aoc2020#learnings>

### Haskell

- Pattern simple vu plusieurs fois : utiliser une fonction `go` dans un `where` pour ammorcer les données initiales d'une fonction récursive (voir la partie 2 du jour 1)
- Combiner `takeWhile` et `scanl` pour appliquer une fonction à une liste d'entrée jusqu'à une condition sur le résultat (voir la deuxième partie du jour 1)
- Utiliser `let` pour affecter le résultat d'un calcul non `IO` dans une `do` notation (voir le `main` du jour 1)
- Générer une liste de liste de coordonnées (par exemple `[[(Int, Int)]]`) :
    - `coordsGrid = map (\y -> (map (flip (,) y) [0..maxX])) [0..maxY]`
- Voir aussi `range((0, 0), (maxX, maxY))` dans `Data.Idx`
- Appliquer une fonction sur toutes les coordonnées d'une liste de liste :
    - `map f <$> coordsGrid`
    - (appliquer `map f` à l'Applicative `List`, soit `map (map f) coordsGrid`)
