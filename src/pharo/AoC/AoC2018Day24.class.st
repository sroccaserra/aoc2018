"
no comment
"
Class {
	#name : #AoC2018Day24,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day24 >> parseAttackOn: aLine [

	| matcher |
	matcher := '([\d]+) ([\w]+) damage' asRegex.
	matcher search: aLine.
	^ {
		  (matcher subexpression: 2) asNumber.
		  (matcher subexpression: 3) }
]

{ #category : #running }
AoC2018Day24 >> parseHitPointsOn: aLine [

	| matcher |
	matcher := '([\d]+) hit points' asRegex.
	matcher search: aLine.
	^ (matcher subexpression: 2) asNumber
]

{ #category : #running }
AoC2018Day24 >> parseInitiativeOn: aLine [

	| matcher |
	matcher := 'initiative ([\d]+)' asRegex.
	matcher search: aLine.
	^ (matcher subexpression: 2) asNumber
]

{ #category : #running }
AoC2018Day24 >> parseLine: aLine [

	| weaknesses immunities attack hitPoints initiative nbUnits result |
	nbUnits := aLine asNumber.
	hitPoints := self parseHitPointsOn: aLine.
	attack := self parseAttackOn: aLine.
	initiative := self parseInitiativeOn: aLine.
	weaknesses := self parseXTo: 'weak' on: aLine.
	immunities := self parseXTo: 'immune' on: aLine.

	result := AoCDay24Group new
		          attackDamage: attack first;
		          attackType: attack second;
		          initiative: initiative;
		          weaknesses: weaknesses;
		          immunities: immunities;
		          yourself.

	nbUnits timesRepeat: [
		result addUnit: (AoCDay24Unit new
				 hitPoints: hitPoints;
				 yourself) ].
	^ result
]

{ #category : #running }
AoC2018Day24 >> parseXTo: prefix on: aLine [

	| matcher match |
	matcher := (prefix , ' to ([^;)]+)') asRegex.
	matcher search: aLine.
	match := matcher subexpression: 2.
	match ifNotNil: [ ^ match substrings: ', ' ] ifNil: [ ^ #(  ) ]
]

{ #category : #running }
AoC2018Day24 >> performAttacksIn: targetSelection [

	targetSelection do: [ :e |
		| attacker defender |
		attacker := e key.
		defender := e value.
		attacker attack: defender ]
]

{ #category : #running }
AoC2018Day24 >> run: filename [

	| lines parts specs parseBlock |
	lines := self loadLines: filename.
	parts := lines splitOn: #( '' ).
	specs := parts collect: #allButFirst.
	parseBlock := [ :spec |
	              spec asOrderedCollection collect: [ :line |
		              self parseLine: line ] ].
	^ self solvePartOne: (specs collect: parseBlock)
]

{ #category : #running }
AoC2018Day24 >> selectAllTargetsFor: immuneSystemArmy opposing: infectionArmy [

	| infectionTargets result allGroupsSorted immuneSystemTargets |
	allGroupsSorted := OrderedCollection new
		                   addAll: immuneSystemArmy;
		                   addAll: infectionArmy;
		                   sort;
		                   yourself.

	immuneSystemTargets := immuneSystemArmy asSet.
	infectionTargets := infectionArmy asSet.
	result := OrderedCollection new.

	allGroupsSorted sorted do: [ :attacker |
		| targets |
		targets := (immuneSystemArmy includes: attacker)
			           ifTrue: [ infectionTargets ]
			           ifFalse: [ immuneSystemTargets ].
		targets ifNotEmpty: [
			| association |
			association := attacker
			               -> (self sortedTargets: targets for: attacker) first.
			targets remove: association value.
			result add: association ] ].

	^ result sorted: [ :a :b | a key initiative > b key initiative ]
]

{ #category : #running }
AoC2018Day24 >> solvePartOne: armies [

	| targetSelection immuneSystemArmy infectionArmy |
	immuneSystemArmy := armies first.
	infectionArmy := armies second.

	[ armies allSatisfy: #notEmpty ] whileTrue: [
		targetSelection := self
			                   selectAllTargetsFor: immuneSystemArmy
			                   opposing: infectionArmy.

		self performAttacksIn: targetSelection.
		immuneSystemArmy removeAllSuchThat: [ :e | e isDefeated ].
		infectionArmy removeAllSuchThat: [ :e | e isDefeated ] ].
	^ (armies select: #notEmpty) first
		  inject: 0
		  into: [ :acc :each | acc + each nbUnits ]
]

{ #category : #running }
AoC2018Day24 >> sortedTargets: anArmy for: anAttacker [

	^ anArmy sorted: [ :a :b |
		  | damagesToA damagesToB |
		  damagesToA := anAttacker damagesTo: a.
		  damagesToB := anAttacker damagesTo: b.
		  damagesToA = damagesToB
			  ifTrue: [
				  | effectivePowerA effectivePowerB |
				  effectivePowerA := a effectivePower.
				  effectivePowerB := b effectivePower.
				  effectivePowerA = effectivePowerB
					  ifTrue: [ a initiative > b initiative ]
					  ifFalse: [ effectivePowerA > effectivePowerB ] ]
			  ifFalse: [ damagesToA > damagesToB ] ]
]
