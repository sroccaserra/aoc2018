"
I represent a text grid of dimensions w and h.

I am indexed by `x@y` (or `j@i`) points, with `1 <= x <= w` and `1 <= y <= h`.
"
Class {
	#name : #AoCTextGrid,
	#superclass : #Object,
	#instVars : [
		'dict',
		'w',
		'h'
	],
	#category : #'AoC-Base'
}

{ #category : #'instance creation' }
AoCTextGrid class >> fromLines: lines [

	| w h result |
	w := (lines at: 1) size.
	h := lines size.
	result := self new w: w h: h.
	lines doWithIndex: [ :line :i | 
		line doWithIndex: [ :char :j | result at: j @ i put: char ] ].
	^ result
]

{ #category : #converting }
AoCTextGrid >> asString [

	^ String streamContents: [ :s | 
		  1 to: h do: [ :i | 
			  1 to: w do: [ :j | 
			  s nextPutAll: (dict at: j @ i ifAbsent: $x) asString ].
			  s cr ] ]
]

{ #category : #accessing }
AoCTextGrid >> at: aPoint put: aChar [

	dict at: aPoint put: aChar
]

{ #category : #accessing }
AoCTextGrid >> charAt: aPoint [

	^ dict at: aPoint
]

{ #category : #accessing }
AoCTextGrid >> findChar: aChar [

	| result |
	result := OrderedCollection new.
	dict associationsDo: [ :assoc | 
		assoc value = aChar ifTrue: [ result addLast: assoc key ] ].
	^ result
]

{ #category : #accessing }
AoCTextGrid >> h [

	^ h
]

{ #category : #initialization }
AoCTextGrid >> initialize [

	dict := Dictionary new.
]

{ #category : #accessing }
AoCTextGrid >> w [

	^ w
]

{ #category : #initialization }
AoCTextGrid >> w: wNumber h: hNumber [

	w := wNumber.
	h := hNumber
]