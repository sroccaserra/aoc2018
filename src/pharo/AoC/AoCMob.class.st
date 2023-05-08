"
No comment.
"
Class {
	#name : #AoCMob,
	#superclass : #Object,
	#instVars : [
		'position',
		'hitPoints',
		'attackPower',
		'enemies'
	],
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoCMob >> enemies [

	^ enemies
]

{ #category : #accessing }
AoCMob >> enemies: aDictionary [

	enemies := aDictionary
]

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
