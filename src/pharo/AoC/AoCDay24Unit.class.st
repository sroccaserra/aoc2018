"
no comment
"
Class {
	#name : #AoCDay24Unit,
	#superclass : #Object,
	#instVars : [
		'hitPoints'
	],
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoCDay24Unit >> hitPoints [

	^ hitPoints
]

{ #category : #accessing }
AoCDay24Unit >> hitPoints: aNumber [

	hitPoints := aNumber
]

{ #category : #printing }
AoCDay24Unit >> printOn: aStream [

	self class name printOn: aStream.
	aStream nextPutAll: ' hp: '.
	hitPoints printOn: aStream
]
