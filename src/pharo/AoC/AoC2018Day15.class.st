"
Example:

AoC2018Day15 new run: 'Developer/github/aoc2018/src/15.txt' ; show.
"
Class {
	#name : #AoC2018Day15,
	#superclass : #AoCBase,
	#instVars : [
		'grid',
		'elves',
		'goblins',
		'markers',
		'elfStartPositions',
		'goblinStartPositions'
	],
	#category : #'AoC-2018'
}

{ #category : #solving }
AoC2018Day15 >> findPathFromUnit: aUnit toClosestTarget: targets [

	| unitPosition q distances node d neighbors parents |
	unitPosition := aUnit position.
	q := WaitfreeQueue new
		     nextPut: unitPosition;
		     yourself.
	distances := Dictionary new
		             at: unitPosition put: 0;
		             yourself.
	parents := Dictionary new.
	[ q isEmpty ] whileFalse: [ 
		node := q nextOrNil.
		d := distances at: node.
		neighbors := (self freeNeighborsAt: node) reject: [ :n | 
			             distances includesKey: n ].
		neighbors do: [ :n | 
			parents at: n put: node.
			distances at: n put: d + 1.
			(targets includes: n)
				ifTrue: [ ^ self unwindPathFromNode: n withParents: parents ]
				ifFalse: [ q nextPut: n ] ] ]
]

{ #category : #solving }
AoC2018Day15 >> freeNeighborsAt: aPoint [

	| orderedIncrements neighbors |
	orderedIncrements := { 
		                     (0 @ -1).
		                     (-1 @ 0).
		                     (1 @ 0).
		                     (0 @ 1) }.
	neighbors := orderedIncrements collect: [ :inc | aPoint + inc ].
	^ neighbors reject: [ :n | 
		  (grid isWall: n) or: [ 
			  (elves includesKey: n) or: [ goblins includesKey: n ] ] ]
]

{ #category : #showing }
AoC2018Day15 >> graphics [

	^ Dictionary newFrom: { 
			  (#wall
			   ->
			   '[gfx]0808555555555666666d56ddddd25d22222255555555666d5666ddd256dd22225d22[/gfx]').
			  (#ground
			   ->
			   '[gfx]08081111111111111111111111111111111111111511111111111115111111111111[/gfx]').
			  (#elf
			   ->
			   '[gfx]0808118811111188811111aff11111aff111f78787f1118881111181811114414411[/gfx]').
			  (#goblin
			   ->
			   '[gfx]0808111111111b111b1111bbb111b11b11b11bbbbb1111bbb1111b111b111b111b11[/gfx]') }
]

{ #category : #initialization }
AoC2018Day15 >> initialize [
	markers := OrderedCollection new.
]

{ #category : #showing }
AoC2018Day15 >> lookAt: aPoint [

	(elves includesKey: aPoint) ifTrue: [ ^ #elf ].
	(goblins includesKey: aPoint) ifTrue: [ ^ #goblin ].
	^ (grid isWall: aPoint)
		  ifTrue: [ ^ #wall ]
		  ifFalse: [ ^ #ground ]
]

{ #category : #solving }
AoC2018Day15 >> playGameTurn [

	| unitsToMove nextUnit possibleTargets path |
	unitsToMove := OrderedCollection new.
	grid positionsDo: [ :pos | 
		(elves includesKey: pos) ifTrue: [ unitsToMove addLast: pos ].
		(goblins includesKey: pos) ifTrue: [ unitsToMove addLast: pos ] ].

	unitsToMove do: [ :unitPosition | 
		nextUnit := elves at: unitPosition ifAbsent: [ goblins at: unitPosition ].
		nextUnit isInRange ifFalse: [ 
			possibleTargets := nextUnit enemies flatCollect: [ :enemy | 
				                   self freeNeighborsAt: enemy position ].
			possibleTargets isEmpty ifFalse: [ 
				path := self findPathFromUnit: nextUnit toClosestTarget: possibleTargets.
				path removeFirst.
				nextUnit moveTo: path first.
				1 to: path size - 1 do: [ :n | 
				markers addLast: (AoCLineMarker from: (path at: n) to: (path at: n + 1)) ] ] ] ]
]

{ #category : #running }
AoC2018Day15 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	grid := AoCTextGrid fromLines: lines.
	elfStartPositions := grid findChar: $E.
	goblinStartPositions := grid findChar: $G.
	grid clearNonWallCells.

	^ self solve
]

{ #category : #showing }
AoC2018Day15 >> show [

	| forms frame canvas |
	"
AoC2018Day15 new run: 'Developer/github/aoc2018/src/15.txt' ; show.
"
	forms := self graphics collect: [ :str | AoCGraphics pico8StringToForm: str ].

	frame := Form extent: 8 * (grid w @ grid h) depth: 32.
	canvas := frame getCanvas.
	grid positionsDo: [ :pos | 
		canvas
			drawImage: (forms at: (self lookAt: pos) ifAbsent: (forms at: #ground))
			at: 8 * (pos - (1 @ 1)) ].

	markers do: [ :m | m drawOn: canvas ].
	(frame magnifyBy: 2) asMorph openInWindowLabeled: 'AoC 2018 Day 15'
]

{ #category : #solving }
AoC2018Day15 >> solve [

	self startGame.
	1 to: 3 do: [ :n | 
		self playGameTurn.
		self show ]
]

{ #category : #solving }
AoC2018Day15 >> startGame [

	| unit |
	elves := Dictionary new.
	goblins := Dictionary new.

	elfStartPositions do: [ :pos | 
		unit := AoCUnit new
			        position: pos;
			        allies: elves;
			        enemies: goblins;
			        yourself.
		elves at: pos put: unit ].

	goblinStartPositions do: [ :pos | 
		unit := AoCUnit new
			        position: pos;
			        allies: goblins;
			        enemies: elves;
			        yourself.
		goblins at: pos put: unit ]
]

{ #category : #solving }
AoC2018Day15 >> unwindPathFromNode: aNode withParents: parentDict [

	| result cursor |
	result := LinkedList new.
	cursor := aNode.
	[ cursor ] whileNotNil: [ 
		result addFirst: cursor.
		cursor := parentDict at: cursor ifAbsent: nil ].
	^ result
]
