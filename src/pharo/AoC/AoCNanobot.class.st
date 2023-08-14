"
no comment
"
Class {
	#name : #AoCNanobot,
	#superclass : #Object,
	#instVars : [
		'center',
		'radius'
	],
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoCNanobot >> center [

	^ center
]

{ #category : #accessing }
AoCNanobot >> center: aG3DCoordinates [

	center := aG3DCoordinates
]

{ #category : #'distance functions' }
AoCNanobot >> distanceToOrigin [

	^ 0 max: center x abs + center y abs + center z abs - radius
]

{ #category : #testing }
AoCNanobot >> includes: aG3DCoordinates [

	| vec |
	vec := center - aG3DCoordinates.
	^ vec x abs + vec y abs + vec z abs < radius
]

{ #category : #'distance functions' }
AoCNanobot >> overlapsWith: otherNanobot [

	| vec |
	vec := center - otherNanobot center.
	^ vec x abs + vec y abs + vec z abs <= (radius + otherNanobot radius)
]

{ #category : #printing }
AoCNanobot >> printOn: aStream [

	aStream nextPutAll: '{c: '.
	center printOn: aStream.
	aStream nextPutAll: ', r: '.
	radius printOn: aStream.
	aStream nextPutAll: '}'
]

{ #category : #'distance functions' }
AoCNanobot >> radius [

^ radius
]

{ #category : #accessing }
AoCNanobot >> radius: aNumber [

	radius := aNumber
]

{ #category : #accessing }
AoCNanobot >> vertices [

	^ {
		  (center + (G3DCoordinates x: radius y: 0 z: 0)).
		  (center + (G3DCoordinates x: radius negated y: 0 z: 0)).
		  (center + (G3DCoordinates x: 0 y: radius z: 0)).
		  (center + (G3DCoordinates x: 0 y: radius negated z: 0)).
		  (center + (G3DCoordinates x: 0 y: 0 z: radius)).
		  (center + (G3DCoordinates x: 0 y: 0 z: radius negated)) }
]
