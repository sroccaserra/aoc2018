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
AoC2018Day15 >> findUnit: aUnit closestTargetFrom: targets [

	| unitPosition q distances node d neighbors |
	unitPosition := aUnit position.
	q := WaitfreeQueue new
		     nextPut: unitPosition;
		     yourself.
	distances := Dictionary new
		             at: unitPosition put: 0;
		             yourself.
	[ q isEmpty ] whileFalse: [ 
		node := q nextOrNil.
		d := distances at: node.
		neighbors := (self freeNeighborsAt: node) reject: [ :n | 
			             distances includesKey: n ].
		neighbors do: [ :n | 
			(targets includes: n)
				ifTrue: [ ^ n ]
				ifFalse: [ 
					distances at: n put: d + 1.
					q nextPut: n ] ] ]
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
			   '[gfx]0808111111111111111111111111111111111111d111111111111111111111111111[/gfx]').
			  (#elf
			   ->
			   '[gfx]0808111811111188811111afff1111aff111f78787f1118881111181811114414411[/gfx]').
			  (#goblin
			   ->
			   '[gfx]0808111111111b111b1111bbb111b11b11b11bbbbb1111bbb1111b111b111b111b11[/gfx]') }
]

{ #category : #initialization }
AoC2018Day15 >> initialize [
	markers := Set new.
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

	| nextPos unitsToMove nextUnit possibleTargets |
	unitsToMove := OrderedCollection new.
	grid positionsDo: [ :pos | 
		(elves includesKey: pos) ifTrue: [ unitsToMove addLast: pos ].
		(goblins includesKey: pos) ifTrue: [ unitsToMove addLast: pos ] ].

	nextPos := unitsToMove first.
	nextUnit := elves at: nextPos ifAbsent: [ goblins at: nextPos ].
	possibleTargets := nextUnit enemies flatCollect: [ :enemy | 
		                   self freeNeighborsAt: enemy position ].

	markers add:
		(self findUnit: nextUnit closestTargetFrom: possibleTargets).

	markers add: nextPos
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

	| forms frame canvas markerForm |
	"
AoC2018Day15 new run: 'Developer/github/aoc2018/src/15.txt' ; show.
"
	forms := self graphics collect: [ :str | 
		         AoCGraphics pico8StringToForm: str ].

	frame := Form extent: 8 * (grid w @ grid h) depth: 32.
	canvas := frame getCanvas.
	grid positionsDo: [ :pos | 
		canvas
			drawImage:
			(forms at: (self lookAt: pos) ifAbsent: (forms at: #ground))
			at: 8 * (pos - (1 @ 1)) ].

	markerForm := AoCGraphics markerForm.
	markers do: [ :pos | 
		canvas
			image: markerForm
			at: 8 * (pos - (1 @ 1))
			sourceRect: markerForm boundingBox
			rule: Form blend ].
	(frame magnifyBy: 2) asMorph openInWindowLabeled: 'AoC 2018 Day 15'
]

{ #category : #solving }
AoC2018Day15 >> solve [

	self startGame.
	self playGameTurn
]

{ #category : #solving }
AoC2018Day15 >> startGame [

	elves := Dictionary new.
	goblins := Dictionary new.

	elfStartPositions do: [ :pos | 
		elves at: pos put: (Elf new
				 position: pos;
				 enemies: goblins;
				 yourself) ].

	goblinStartPositions do: [ :pos | 
		goblins at: pos put: (Goblin new
				 position: pos;
				 enemies: elves;
				 yourself) ]
]
