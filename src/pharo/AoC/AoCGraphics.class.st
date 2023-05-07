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
	#( '000000' 'FFFFFF' '880000' 'AAFFEE' 'CC44CC' '00CC55' '0000AA'
	   'EEEE77' 'DD8855' '664400' 'FF7777' '333333' '777777' 'AAFF66'
	   '0088FF' 'BBBBBB' ) doWithIndex: [ :hexString :n | 
		c64Palette at: n - 1 put: (Color fromHexString: hexString) ].

	pico8Palette := Dictionary new.
	#( '000000' '1D2B53' '7E2553' '008751' 'AB5236' '5F574F' 'C2C3C7'
	   'FFF1E8' 'FF004D' 'FFA300' 'FFEC27' '00E436' '29ADFF' '83769C'
	   'FF77A8' 'FFCCAA' ) doWithIndex: [ :hexString :n | 
		pico8Palette at: n - 1 put: (Color fromHexString: hexString) ]
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