"
Plan : passer de `^ENWWW(NEEE|SSE(EE|N))$` à

```text
{
	ENWWW: [
		{ NEEE: [] },
		{ SSE: [{ EE: [] }, { N: [] }] }
	]
}
```

Pb : traiter les cas `^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$`
"
Class {
	#name : #AoC2018Day20,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day20 >> parseEdges: line [
	"^ENWWW(NEEE|SSE(EE|N))$"

	| positions directions stack starts ends edges actions |
	positions := { (0 @ 0) } asSet.
	starts := { (0 @ 0) } asSet.
	ends := Set new.
	stack := Stack new.
	edges := Set new.

	directions := {
		              ($N -> (0 @ -1)).
		              ($S -> (0 @ 1)).
		              ($E -> (1 @ 0)).
		              ($W -> (-1 @ 0)) } asDictionary.
	actions := {
		           ($^ -> [  ]).
		           ($$ -> [  ]).
		           (#move -> [ :dir |
		            positions do: [ :pos |
			            | newPos |
			            newPos := pos + dir.
			            edges add: (pos corner: newPos) ].
		            positions := positions collect: [ :pos | pos + dir ] ]).
		           ($( -> [
		            stack push: {
				            starts.
				            ends }.
		            starts := positions.
		            ends := Set new ]).
		           ($) -> [
		            | prevs |
		            positions addAll: ends.
		            prevs := stack pop.
		            starts := prevs first.
		            ends := prevs second ]).
		           ($| -> [
		            ends addAll: positions.
		            positions := starts ]) } asDictionary.

	line do: [ :char |
		(directions includesKey: char)
			ifTrue: [
				| dir |
				dir := directions at: char.
				(actions at: #move) value: dir ]
			ifFalse: [ (actions at: char) value ] ].

	^ edges
]

{ #category : #running }
AoC2018Day20 >> run: filename [

	| lines edges |
	lines := self loadLines: filename.
	edges := self parseEdges: lines first.
	^ self solvePartOne: edges
]

{ #category : #running }
AoC2018Day20 >> solvePartOne: edges [

	| map distances queue |
	map := Dictionary new.
	edges do: [ :rect |
		(map at: rect origin ifAbsentPut: Set new) add: rect corner.
		(map at: rect corner ifAbsentPut: Set new) add: rect origin ].

	distances := Dictionary new.
	distances at: 0 @ 0 put: 0.
	queue := SharedQueue new.
	queue nextPut: 0 @ 0.
	[ queue isEmpty ] whileFalse: [
		| pos neighbors d |
		pos := queue next.
		d := distances at: pos.
		neighbors := (map at: pos) reject: [ :n | distances includesKey: n ].
		neighbors do: [ :n |
			distances at: n put: d + 1.
			queue nextPut: n ] ].

	^ distances values max
]
