"
no comment
"
Class {
	#name : #AoCState,
	#superclass : #Object,
	#instVars : [
		'registers'
	],
	#category : #'AoC-2018'
}

{ #category : #'instance creation' }
AoCState class >> fromNumbers: numbers [

	| result |
	result := self new.
	numbers doWithIndex: [ :each :i | result at: i - 1 put: each ].
	^ result
]

{ #category : #accessing }
AoCState >> at: aNumber [

	^ registers at: aNumber
]

{ #category : #accessing }
AoCState >> at: register put: value [

	registers at: register put: value
]

{ #category : #initialization }
AoCState >> initialize [

	registers := Dictionary new
]

{ #category : #printing }
AoCState >> printOn: aStream [

	self class printOn: aStream.
	' -> ' printOn: aStream.
	registers values printOn: aStream
]

{ #category : #accessing }
AoCState >> values [

	^ registers values
]
