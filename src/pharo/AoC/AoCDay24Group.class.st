"
no comment
"
Class {
	#name : #AoCDay24Group,
	#superclass : #Object,
	#instVars : [
		'units',
		'target',
		'attackDamage',
		'attackType',
		'initiative',
		'weaknesses',
		'immunities'
	],
	#category : #'AoC-2018'
}

{ #category : #testing }
AoCDay24Group >> <= other [

	^ self effectivePower = other effectivePower
		  ifTrue: [ ^ self initiative > other initiative ]
		  ifFalse: [ self effectivePower > other effectivePower ]
]

{ #category : #accessing }
AoCDay24Group >> addUnit: anAoCDay24Unit [

	units add: anAoCDay24Unit
]

{ #category : #accessing }
AoCDay24Group >> attack: other [

	| damages |
	damages := self damagesTo: other.
	other suffer: damages
]

{ #category : #accessing }
AoCDay24Group >> attackDamage: aNumber [

	attackDamage := aNumber
]

{ #category : #accessing }
AoCDay24Group >> attackType: aString [

	attackType := aString
]

{ #category : #accessing }
AoCDay24Group >> damagesTo: other [

	(other isImmuneTo: attackType) ifTrue: [ ^ 0 ].
	(other isWeakTo: attackType) ifTrue: [ ^ 2 * self effectivePower ].
	^ self effectivePower
]

{ #category : #accessing }
AoCDay24Group >> effectivePower [

	^ self nbUnits * attackDamage
]

{ #category : #accessing }
AoCDay24Group >> immunities: strings [

	immunities := strings
]

{ #category : #initialization }
AoCDay24Group >> initialize [

	units := OrderedCollection new
]

{ #category : #accessing }
AoCDay24Group >> initiative [

	^ initiative
]

{ #category : #accessing }
AoCDay24Group >> initiative: aNumber [

	initiative := aNumber
]

{ #category : #testing }
AoCDay24Group >> isDefeated [

	^ units isEmpty
]

{ #category : #testing }
AoCDay24Group >> isImmuneTo: anAttackType [

	^ immunities includes: anAttackType
]

{ #category : #testing }
AoCDay24Group >> isWeakTo: anAttackType [

	^ weaknesses includes: anAttackType
]

{ #category : #accessing }
AoCDay24Group >> nbUnits [

	^ units size
]

{ #category : #printing }
AoCDay24Group >> printOn: aStream [

	aStream
		nextPutAll: self className;
		nextPutAll: ' nbUnits: '.
	units size printOn: aStream.
	aStream nextPutAll: ', ep: '.
	self effectivePower printOn: aStream.
	aStream nextPutAll: ', ad: '.
	attackDamage printOn: aStream.
	aStream nextPutAll: ', at: '.
	attackType printOn: aStream.
	aStream nextPutAll: ', i: '.
	initiative printOn: aStream.
	aStream nextPutAll: ', ws: '.
	weaknesses printOn: aStream.
	aStream nextPutAll: ', is: '.
	immunities printOn: aStream
]

{ #category : #accessing }
AoCDay24Group >> suffer: damages [

	| hitPoints nbUnitLost |
	hitPoints := units first hitPoints.
	nbUnitLost := damages // hitPoints.
	units := units allButLast: nbUnitLost
]

{ #category : #accessing }
AoCDay24Group >> target [

	^ target
]

{ #category : #accessing }
AoCDay24Group >> target: aGroup [

	target := aGroup
]

{ #category : #accessing }
AoCDay24Group >> weaknesses: strings [

	weaknesses := strings
]
