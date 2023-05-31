"
AoC2018Day17 * 'Developer/github/aoc2018/ex'

"
Class {
	#name : #AoC2018Day17,
	#superclass : #AoCVisualBase,
	#instVars : [
		'grid',
		'wallPoints',
		'springPos'
	],
	#category : #'AoC-2018'
}

{ #category : #'drawing - images' }
AoC2018Day17 class >> groundGraphics [

	^ '[gfx]08081111111111111111111111111111111111111511111111111115111111111111[/gfx]'
]

{ #category : #'drawing - images' }
AoC2018Day17 class >> springGraphics [

	^ '[gfx]08081111111111111111111111111166761116566761165567611655676165566676[/gfx]'
]

{ #category : #'drawing - images' }
AoC2018Day17 class >> wallGraphics [

	^ '[gfx]0808555555555666666d56ddddd25d22222255555555666d5666ddd256dd22225d22[/gfx]'
]

{ #category : #'drawing - images' }
AoC2018Day17 class >> waterGraphics [

	^ '[gfx]0808cccccccccc77cc7cc7cc77cccccccccccccccccccccccccccccccccccccccccc[/gfx]'
]

{ #category : #'drawing - images' }
AoC2018Day17 class >> waterPassedGraphics [

	^ '[gfx]0808115111151111511111c111c5c1151c1111111111151c15111111111c1c11c111[/gfx]'
]

{ #category : #running }
AoC2018Day17 >> canPass: aPoint [

	^ (grid charAt: aPoint) = $.
]

{ #category : #running }
AoC2018Day17 >> dropWaterFrom: aPoint [

	| nextPoint |
	nextPoint := aPoint.
	[ 
	nextPoint := nextPoint + (0 @ 1).
	self canPass: nextPoint ] whileTrue: [ grid at: nextPoint putChar: $| ].
	^ nextPoint - (0 @ 1)
]

{ #category : #running }
AoC2018Day17 >> freeNeighborsDownAt: aPoint [

	| down |
	down := aPoint + (0 @ 1).
	(self isFreeAt: down) ifTrue: [ ^ { down } ].
	^ #(  )
]

{ #category : #running }
AoC2018Day17 >> freeNeighborsSidesAt: aPoint [

	| down right left |
	down := aPoint + (0 @ 1).
	(self isFreeAt: down) ifTrue: [ ^ { down } ].
	right := aPoint + (1 @ 0).
	left := aPoint + (-1 @ 0).
	^ { 
		  right.
		  left } select: [ :each | self isFreeAt: each ]
]

{ #category : #initialization }
AoC2018Day17 >> initialize [

	springPos := 500 @ 0
]

{ #category : #running }
AoC2018Day17 >> isFreeAt: aPoint [

	^ '.|' includes: (grid charAt: aPoint)
]

{ #category : #running }
AoC2018Day17 >> parseWall: aString [

	| parts axis constant range rangeParts |
	parts := aString substrings: ','.
	axis := parts first first.
	constant := (parts first substrings: '=') second asInteger.
	rangeParts := parts second substrings: '=.'.
	range := rangeParts second asInteger @ rangeParts third asInteger.
	^ axis = $x
		  ifTrue: [ constant @ range x corner: constant + 0.5 @ (range y + 0.5) ]
		  ifFalse: [ range x @ constant corner: range y + 0.5 @ (constant + 0.5) ]
]

{ #category : #running }
AoC2018Day17 >> parseWallPoints: aString [

	| parts axis constant range rangeParts |
	parts := aString substrings: ','.
	axis := parts first first.
	constant := (parts first substrings: '=') second asInteger.
	rangeParts := parts second substrings: '=.'.
	range := rangeParts second asInteger @ rangeParts third asInteger.
	^ (range x to: range y) collect: [ :n | 
		  axis = $x
			  ifTrue: [ constant @ n ]
			  ifFalse: [ n @ constant ] ]
]

{ #category : #running }
AoC2018Day17 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	wallPoints := lines flatCollect: [ :each | self parseWallPoints: each ].
	wallPoints := (OrderedCollection newFrom: wallPoints)
		              addLast: 500 @ 0;
		              yourself.
	"Generate grid"
	grid := AoCTextGrid fromPoints: wallPoints.
	grid at: springPos putChar: $+.

	^ self solvePartOne
]

{ #category : #showing }
AoC2018Day17 >> show [

	| forms frame canvas translation pane |
	forms := Dictionary newFrom: { 
			         ($. -> (AoCGraphics pico8StringToForm: self class groundGraphics)).
			         ($# -> (AoCGraphics pico8StringToForm: self class wallGraphics)).
			         ($+ -> (AoCGraphics pico8StringToForm: self class springGraphics)).
			         ($~ -> (AoCGraphics pico8StringToForm: self class waterGraphics)).
			         ($|
			          -> (AoCGraphics pico8StringToForm: self class waterPassedGraphics)) }.

	frame := Form extent: 8 * (grid w @ grid h) depth: 32.
	canvas := frame getCanvas.
	translation := grid origin - (1 @ 1).
	grid positionsDo: [ :pos | 
		| worldPos canvasPos tile |
		worldPos := pos + translation.
		canvasPos := 8 * (pos - (1 @ 1)).
		tile := forms at: (grid charAt: worldPos).
		canvas drawImage: tile at: canvasPos ].

	pane := ScrollPane new.
	pane extent: 1024 @ 800.
	pane scroller addMorph: (frame magnifyBy: 2) asMorph.
	pane openInWindowLabeled: 'AoC 2018 Day 17'
]

{ #category : #solving }
AoC2018Day17 >> solvePartOne [

	| vertQ seen horQ |
	vertQ := WaitfreeQueue new
		         nextPut: springPos;
		         yourself.
	horQ := WaitfreeQueue new.
	seen := Dictionary new
		        at: springPos put: true;
		        yourself.
	[ vertQ isEmpty ] whileFalse: [ 
		| node freeNeighbors |
		node := vertQ nextOrNil.
		freeNeighbors := self freeNeighborsDownAt: node.
		freeNeighbors do: [ :neighbor | 
			(neighbor y < 500 and: [ (seen includesKey: neighbor) not ]) ifTrue: [ 
				seen at: neighbor put: true.
				grid at: neighbor putChar: $|.
				vertQ nextPut: neighbor ] ] ].

	^ grid
]

{ #category : #running }
AoC2018Day17 >> step [

	grid at: 500 @ 1 putChar: $|
]
