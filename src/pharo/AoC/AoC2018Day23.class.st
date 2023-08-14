"
Le volume définit par un nanobot en manhatan distance est un octaèdre (octahedron). En 2d, c'est une surface, un carré à 45 degrés.
"
Class {
	#name : #AoC2018Day23,
	#superclass : #AoCBase,
	#instVars : [
		'nanobots'
	],
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day23 >> findCliqueFor: aNanobot [
	"Simplest clique algo, works in my case if nanobots are sorted from most colliding to least colliding.
	See Bron Kerbosh for an efficient algorithm.
	- https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm
	"

	| result |
	result := OrderedCollection new.
	nanobots do: [ :e |
		(result allSatisfy: [ :fromClique | fromClique overlapsWith: e ])
			ifTrue: [ result add: e ] ].
	^ result
]

{ #category : #running }
AoC2018Day23 >> parseLine: aString [

	| parts numbers center |
	parts := aString substrings: '=,<> '.
	numbers := #( 2 3 4 6 ) collect: [ :i | (parts at: i) asInteger ].
	center := G3DCoordinates
		          x: numbers first
		          y: numbers second
		          z: numbers third.

	^ AoCNanobot new
		  center: center;
		  radius: numbers fourth;
		  yourself
]

{ #category : #running }
AoC2018Day23 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	nanobots := lines collect: [ :l | self parseLine: l ].
	^ {
		  (self solvePartOne).
		  (self solvePartTwo) }
]

{ #category : #running }
AoC2018Day23 >> solvePartOne [

	| mainBot |
	mainBot := (nanobots sort: [ :e1 :e2 | e1 radius > e2 radius ]) first.
	^ nanobots count: [ :bot | mainBot includes: bot center ]
]

{ #category : #running }
AoC2018Day23 >> solvePartTwo [

	| nbOfCollisions clique |
	nbOfCollisions := (nanobots collect: [ :each |
		                   | n |
		                   n := nanobots count: [ :other |
			                        each overlapsWith: other ].
		                   each -> n ]) asDictionary.

	nanobots sort: [ :e1 :e2 |
		(nbOfCollisions at: e1) > (nbOfCollisions at: e2) ].

	clique := self findCliqueFor: nanobots first.
	^ (clique collect: [ :e | e distanceToOrigin ]) max
]
