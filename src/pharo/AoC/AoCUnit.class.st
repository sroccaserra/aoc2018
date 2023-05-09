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

{ #category : #action }
AoCUnit >> attack: aUnit [

	aUnit losesHP: attackPower.
]

{ #category : #updating }
AoCUnit >> die [

	self allies removeAt: position
]

{ #category : #accessing }
AoCUnit >> enemies [

	^ enemies
]

{ #category : #accessing }
AoCUnit >> enemies: aDictionary [

	enemies := aDictionary
]

{ #category : #accessing }
AoCUnit >> hitPoints [

	^ hitPoints
]

{ #category : #initialization }
AoCUnit >> initialize [

	hitPoints := 200.
	attackPower := 3
]

{ #category : #accessing }
AoCUnit >> isAlive [

	^ hitPoints > 0
]

{ #category : #updating }
AoCUnit >> losesHP: anInteger [

	hitPoints := hitPoints - anInteger.
	hitPoints <= 0 ifTrue: [ self die ]
]

{ #category : #updating }
AoCUnit >> moveTo: aPoint [

	allies removeKey: position.
	position := aPoint.
	allies at: position put: self
]

{ #category : #accessing }
AoCUnit >> pointsInRange [

	^ Array
		  with: position + (0 @ -1)
		  with: position + (-1 @ 0)
		  with: position + (1 @ 0)
		  with: position + (0 @ 1)
]

{ #category : #accessing }
AoCUnit >> position [

	^ position
]

{ #category : #accessing }
AoCUnit >> position: aPoint [

	position := aPoint
]

{ #category : #accessing }
AoCUnit >> targetInRange [

	| result minHP enemy weakestTarget |
	minHP := 999999.
	weakestTarget := nil.
	result := OrderedCollection new.
	self pointsInRange do: [ :p | 
		(enemies includesKey: p) ifTrue: [ 
			enemy := enemies at: p.
			enemy hitPoints < minHP ifTrue: [ 
				minHP := enemy hitPoints.
				weakestTarget := enemy ] ] ].
	^ weakestTarget
]
