"
No comment.
"
Class {
	#name : #AoCMob,
	#superclass : #Object,
	#instVars : [
		'position',
		'hitPoints',
		'attackPower'
	],
	#category : #'AoC-2018'
}

{ #category : #initialization }
AoCMob >> initialize [

	hitPoints := 200.
	attackPower := 3
]

{ #category : #accessing }
AoCMob >> position [

	^ position
]

{ #category : #accessing }
AoCMob >> position: aPoint [

	position := aPoint
]
