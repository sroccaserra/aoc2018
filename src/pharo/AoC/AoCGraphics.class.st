"
AoCGraphics initialize.
"
Class {
	#name : #AoCGraphics,
	#superclass : #Object,
	#classInstVars : [
		'pico8Palette',
		'c64Palette'
	],
	#category : #'AoC-Base'
}

{ #category : #displaying }
AoCGraphics class >> bitRowsToForm: bitRows [

	| w h form y |
	h := bitRows size.
	w := 8. "hardcoded, meh"
	form := Form extent: w @ h depth: 1.
	bitRows doWithIndex: [ :line :n | 
		y := n - 1.
		0 to: 7 do: [ :x | 
			form pixelValueAt: x @ y put: (line bitAt: 8 - x) ] ].
	^ form
]

{ #category : #'class initialization' }
AoCGraphics class >> initialize [

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
AoCGraphics class >> nibbleRowsToForm: nibbleRows [

	| formW formH form y xOffset nibbleSize colorNumber |
	formH := nibbleRows size.
	formW := 8.
	nibbleSize := 4.
	form := Form extent: formW @ formH depth: 32.
	nibbleRows doWithIndex: [ :line :n | 
		y := n - 1.
		0 to: 7 do: [ :x | 
			xOffset := (7 - x) * nibbleSize.
			colorNumber := line >> xOffset & 16rF.
			form colorAt: x @ y put: (c64Palette at: colorNumber) ] ].
	^ form
]

{ #category : #displaying }
AoCGraphics class >> pico8StringToForm: pico8String [

	"example of pico8String:
	'[gfx]0808999999999aaaaaa49a4444429422222299999999aaaa49aa444429a422222942[/gfx]'
	"

	| dimensionData colorData w h form c yOffset colorNumber |

	dimensionData := (pico8String allButFirst: 5) first: 4.
	w := Integer readFrom: (dimensionData first: 2) base: 16.
	h := Integer readFrom: (dimensionData last: 2) base: 16.

	colorData := (pico8String allButFirst: 9) allButLast: 6.
	form := Form extent: w @ h depth: 32.
	0 to: (h - 1) do: [ :y |
		yOffset := y*w .
		0 to: (w -1) do: [ :x |
			c := colorData at: (yOffset + x + 1).
			colorNumber := Integer readFrom: (c asString) base: 16.
			form colorAt: x @ y put: (pico8Palette at: colorNumber) ] ].
	^ form
]
