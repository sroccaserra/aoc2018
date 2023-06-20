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
AoCState class >> fromFourNumbers: fourNumbers [

	[ fourNumbers size = 4 ] assert.
	^ self new
		  at: 0 put: fourNumbers first;
		  at: 1 put: fourNumbers second;
		  at: 2 put: fourNumbers third;
		  at: 3 put: fourNumbers fourth;
		  yourself
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

	registers := {
		             (0 -> 0).
		             (1 -> 0).
		             (2 -> 0).
		             (3 -> 0) } asDictionary
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
