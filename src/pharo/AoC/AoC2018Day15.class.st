"
Example:

AoC2018Day15 new run: 'Developer/github/aoc2018/src/15.txt'

"
Class {
	#name : #AoC2018Day15,
	#superclass : #AoCBase,
	#instVars : [
		'grid',
		'elves',
		'goblins'
	],
	#category : #'AoC-2018'
}

{ #category : #showing }
AoC2018Day15 >> charAt: aPoint [

	(elves includesKey: aPoint) ifTrue: [ ^ $E ].
	(goblins includesKey: aPoint) ifTrue: [ ^ $G ].
	^ grid charAt: aPoint
]

{ #category : #showing }
AoC2018Day15 >> openInWindow [

	| frame canvas wallTile groundTile elfTile goblinTile tiles |
	wallTile := AoCGraphics pico8StringToForm:
		            '[gfx]0808999999999aaaaaa49a4444429422222299999999aaa49aaa44429a4422229422[/gfx]'.

	groundTile := AoCGraphics pico8StringToForm:
		              '[gfx]0808222222222222222222222222222222222222d222222222222222222222222222[/gfx]'.

	elfTile := AoCGraphics pico8StringToForm:
		           '[gfx]08082222222222244222224fff22224ff222fcccccf2226662222262622226626622[/gfx]'.

	goblinTile := AoCGraphics pico8StringToForm:
		             '[gfx]0808222222222b222b2222bbb222b22b22b22bbbbb2222bbb2222b222b222b222b22[/gfx]'.

	tiles := Dictionary new.
	tiles at: $# put: wallTile.
	tiles at: $E put: elfTile.
	tiles at: $G put: goblinTile.

	frame := Form extent: (grid w) * 8 @ ((grid h)  * 8) depth: 32.
	canvas := frame getCanvas.
	1 to: (grid h) do: [ :i | 
		1 to: (grid w) do: [ :j | 
			canvas
				drawImage: (tiles at: (self charAt: j @ i) ifAbsent: groundTile)
				at: (j - 1) * 8 @ ((i - 1) * 8) ] ].
	(frame magnifyBy: 2) asMorph openInWindow
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
		elves at: pos put: (Elf new position: pos yourself).
		grid at: pos put: $. ].

	goblinPositions do: [ :pos | 
		goblins at: pos put: (Goblin new position: pos yourself).
		grid at: pos put: $. ].

	^ self solve
]

{ #category : #solving }
AoC2018Day15 >> solve [

	self openInWindow.

	^ elves
]