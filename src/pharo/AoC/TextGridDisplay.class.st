"
no comment.
"
Class {
	#name : #TextGridDisplay,
	#superclass : #Object,
	#instVars : [
		'textGrid',
		'c64Palette',
		'pico8Palette'
	],
	#category : #'AoC-2018'
}

{ #category : #initialization }
TextGridDisplay >> initialize [

	c64Palette := Dictionary new.
	c64Palette at: 0 put: Color black.
	c64Palette at: 1 put: Color white.
	c64Palette at: 2 put: (Color fromHexString: '880000').
	c64Palette at: 3 put: (Color fromHexString: 'AAFFEE').
	c64Palette at: 4 put: (Color fromHexString: 'CC44CC').
	c64Palette at: 5 put: (Color fromHexString: '00CC55').
	c64Palette at: 6 put: (Color fromHexString: '0000AA').
	c64Palette at: 7 put: (Color fromHexString: 'EEEE77').
	c64Palette at: 8 put: (Color fromHexString: 'DD8855').
	c64Palette at: 9 put: (Color fromHexString: '664400').
	c64Palette at: 10 put: (Color fromHexString: 'FF7777').
	c64Palette at: 11 put: (Color fromHexString: '333333').
	c64Palette at: 12 put: (Color fromHexString: '777777').
	c64Palette at: 13 put: (Color fromHexString: 'AAFF66').
	c64Palette at: 14 put: (Color fromHexString: '0088FF').
	c64Palette at: 15 put: (Color fromHexString: 'BBBBBB').

	pico8Palette := Dictionary new.
	pico8Palette at: 0 put: Color black.
	pico8Palette at: 1 put: (Color fromHexString: '1D2B53').
	pico8Palette at: 2 put: (Color fromHexString: '7E2553').
	pico8Palette at: 3 put: (Color fromHexString: '008751').
	pico8Palette at: 4 put: (Color fromHexString: 'AB5236').
	pico8Palette at: 5 put: (Color fromHexString: '5F574F').
	pico8Palette at: 6 put: (Color fromHexString: 'C2C3C7').
	pico8Palette at: 7 put: (Color fromHexString: 'FFF1E8').
	pico8Palette at: 8 put: (Color fromHexString: 'FF004D').
	pico8Palette at: 9 put: (Color fromHexString: 'FFA300').
	pico8Palette at: 10 put: (Color fromHexString: 'FFEC27').
	pico8Palette at: 11 put: (Color fromHexString: '00E436').
	pico8Palette at: 12 put: (Color fromHexString: '29ADFF').
	pico8Palette at: 13 put: (Color fromHexString: '83769C').
	pico8Palette at: 14 put: (Color fromHexString: 'FF77A8').
	pico8Palette at: 15 put: (Color fromHexString: 'FFCCAA')
]

{ #category : #displaying }
TextGridDisplay >> openInWindow [

	| frame canvas wallTile groundTile elfTile gnomeTile tiles |
	wallTile := AoCGraphics pico8StringToForm:
		            '[gfx]0808999999999aaaaaa49a4444429422222299999999aaa49aaa44429a4422229422[/gfx]'.

	groundTile := AoCGraphics pico8StringToForm:
		              '[gfx]0808222222222222222222222222222222222222d222222222222222222222222222[/gfx]'.

	elfTile := AoCGraphics pico8StringToForm:
		           '[gfx]08082222222222244222224fff22224ff222fcccccf2226662222262622226626622[/gfx]'.

	gnomeTile := AoCGraphics pico8StringToForm:
		             '[gfx]0808222222222b222b2222bbb222b22b22b22bbbbb2222bbb2222b222b222b222b22[/gfx]'.

	tiles := Dictionary new.
	tiles at: $# put: wallTile.
	tiles at: $E put: elfTile.
	tiles at: $G put: gnomeTile.

	frame := Form extent: (textGrid w) * 8 @ ((textGrid h)  * 8) depth: 32.
	canvas := frame getCanvas.
	1 to: (textGrid h) do: [ :i | 
		1 to: (textGrid w) do: [ :j | 
			canvas
				drawImage: (tiles at: (textGrid charAt: j @ i) ifAbsent: groundTile)
				at: (j - 1) * 8 @ ((i - 1) * 8) ] ].
	(frame magnifyBy: 2) asMorph openInWindow
]

{ #category : #accessing }
TextGridDisplay >> textGrid: aTextGrid [

	textGrid := aTextGrid
]
