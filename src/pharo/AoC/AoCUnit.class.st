"
I represent an elf or a goblin unit for the advent of code 2018 day 15 puzzle.
"
Class {
	#name : #AoCUnit,
	#superclass : #Object,
	#instVars : [
		'position',
		'hitPoints',
		'attackPower',
		'allies',
		'enemies'
	],
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoCUnit >> allies [

	^ allies
]

{ #category : #accessing }
AoCUnit >> allies: anObject [

	allies := anObject
]

{ #category : #accessing }
AoCUnit >> enemies [

	^ enemies
]

{ #category : #accessing }
AoCUnit >> enemies: aDictionary [

	enemies := aDictionary
]

{ #category : #initialization }
AoCUnit >> initialize [

	hitPoints := 200.
	attackPower := 3
]

{ #category : #accessing }
AoCUnit >> isInRange [

	^ (enemies includesKey: position + (0 @ -1)) or: [ 
		  (enemies includesKey: position + (-1 @ 0)) or: [ 
			  (enemies includesKey: position + (1 @ 0)) or: [ 
				  enemies includesKey: position + (0 @ 1) ] ] ]
]

{ #category : #updating }
AoCUnit >> moveTo: aPoint [

	allies removeKey: position.
	position := aPoint.
	allies at: position put: self
]

{ #category : #accessing }
AoCUnit >> position [

	^ position
]

{ #category : #accessing }
AoCUnit >> position: aPoint [

	position := aPoint
]
