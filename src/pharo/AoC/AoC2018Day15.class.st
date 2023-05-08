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
		                   (grid freeNeighborsAt: enemy position) reject: [ 
			                   :pos | 
			                   (elves includesKey: pos) or:
				                   (goblins includesKey: pos) ] ].

	markers add: nextPos.
	markers addAll: possibleTargets
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

	frame := Form extent: grid w * 8 @ (grid h * 8) depth: 32.
	canvas := frame getCanvas.
	grid positionsDo: [ :pos | 
		canvas
			drawImage:
			(forms at: (self lookAt: pos) ifAbsent: (forms at: #ground))
			at: (pos x - 1) * 8 @ ((pos y - 1) * 8) ].

	markerForm := AoCGraphics markerForm.
	markers do: [ :pos | 
		canvas
			image: markerForm
			at: (pos x - 1) * 8 @ ((pos y - 1) * 8)
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
