## Démarrer un nouveau projet

```
$ stack new aoc2018
$ stack setup
$ stack build
```

## Usage

```
$ $ echo 1 2 3 4 | stack runhaskell -- app/Main
```
ou :
```
$ awk -f script.awk input | stack runhaskell -- app/Main
```
