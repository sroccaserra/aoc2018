"
no comment
"
Class {
	#name : #AoC2018Day23,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day23 >> parseLine: aString [

	| parts numbers |
	parts := aString substrings: '=,<> '.
	numbers := #( 2 3 4 6 ) collect: [ :i | (parts at: i) asInteger ].
	^ {
		  (G3DCoordinates
			   x: numbers first
			   y: numbers second
			   z: numbers third).
		  numbers fourth }
]

{ #category : #running }
AoC2018Day23 >> run: filename [

	| lines nanobots |
	lines := self loadLines: filename.
	nanobots := lines collect: [ :l | self parseLine: l ].
	^ self solvePartOne: nanobots
]

{ #category : #running }
AoC2018Day23 >> solvePartOne: nanobots [

	| bot result |
	bot := nanobots first.
	nanobots do: [ :each |
		each second > bot second ifTrue: [ bot := each ] ].
	result := 0.
	nanobots do: [ :each |
		| vec |
		vec := bot first - each first.
		vec x abs + vec y abs + vec z abs <= bot second ifTrue: [
			result := result + 1 ] ].
	^ result
]
