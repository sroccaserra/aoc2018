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
		'markers'
	],
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoC2018Day15 >> charAt: aPoint [

	(elves includesKey: aPoint) ifTrue: [ ^ $E ].
	(goblins includesKey: aPoint) ifTrue: [ ^ $G ].
	^ grid charAt: aPoint
]

{ #category : #initialization }
AoC2018Day15 >> initialize [
	markers := Set new.
]

{ #category : #running }
AoC2018Day15 >> run: filename [

	| lines elfPositions goblinPositions |
	lines := self loadLines: filename.
	grid := AoCTextGrid fromLines: lines.
	elfPositions := grid findChar: $E.
	goblinPositions := grid findChar: $G.

	elves := Dictionary new.
	goblins := Dictionary new.

	elfPositions do: [ :pos | 
		elves at: pos put: (Elf new
				 position: pos;
				 enemies: goblins;
				 yourself).
		grid clearAt: pos ].

	goblinPositions do: [ :pos | 
		goblins at: pos put: (Goblin new
				 position: pos;
				 enemies: elves;
				 yourself).
		grid clearAt: pos ].

	^ self solve
]

{ #category : #showing }
AoC2018Day15 >> show [

	| frame canvas wallTile groundTile elfTile goblinTile markerTile tiles |
	wallTile := AoCGraphics pico8StringToForm:
		            '[gfx]0808999999999aaaaaa49a4444429422222299999999aaa49aaa44429a4422229422[/gfx]'.

	groundTile := AoCGraphics pico8StringToForm:
		              '[gfx]0808222222222222222222222222222222222222d222222222222222222222222222[/gfx]'.

	elfTile := AoCGraphics pico8StringToForm:
		           '[gfx]08082222222222244222224fff22224ff222fcccccf2226662222262622226626622[/gfx]'.

	goblinTile := AoCGraphics pico8StringToForm:
		              '[gfx]0808222222222b222b2222bbb222b22b22b22bbbbb2222bbb2222b222b222b222b22[/gfx]'.

	markerTile := AoCGraphics markerForm.

	tiles := Dictionary new.
	tiles at: $# put: wallTile.
	tiles at: $E put: elfTile.
	tiles at: $G put: goblinTile.

	frame := Form extent: grid w * 8 @ (grid h * 8) depth: 32.
	canvas := frame getCanvas.
	1 to: grid h do: [ :i | 
		1 to: grid w do: [ :j | 
			canvas
				drawImage: (tiles at: (self charAt: j @ i) ifAbsent: groundTile)
				at: (j - 1) * 8 @ ((i - 1) * 8) ] ].
	markers do: [ :pos | 
		canvas
			image: markerTile
			at: (pos x - 1) * 8 @ ((pos y - 1) * 8)
			sourceRect: markerTile boundingBox
			rule: Form blend ].
	(frame magnifyBy: 2) asMorph openInWindowLabeled: 'AoC 2018 Day 15'
]

{ #category : #solving }
AoC2018Day15 >> solve [

	| unitsToMove next nextPos |
	unitsToMove := OrderedCollection new.
	grid positionsDo: [ :pos | 
		(elves includesKey: pos) ifTrue: [ 
			unitsToMove addLast: pos ].
		(goblins includesKey: pos) ifTrue: [ 
			unitsToMove addLast: pos ] ].

	nextPos := unitsToMove first.
	next := elves at: nextPos ifAbsent: (goblins at: nextPos).
	markers add: nextPos.
	next enemies do: [ :unit | 
		markers addAll:
			((grid freeNeighborsAt: unit position) reject: [ :pos | 
				 unitsToMove includes: pos ]) ]
]
