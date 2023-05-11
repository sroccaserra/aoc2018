"
no comment
"
Class {
	#name : #AoCSample,
	#superclass : #Object,
	#instVars : [
		'before',
		'instruction',
		'after'
	],
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoCSample >> after: fourNumbers [

	after := fourNumbers
]

{ #category : #accessing }
AoCSample >> before: fourNumbers [

	before := fourNumbers
]

{ #category : #counting }
AoCSample >> countMatching [

	| results |
	results := AoCInstruction ops values collect: [ :each | 
		           instruction
			           implementation: each;
			           executeOn: (AoCState fromFourNumbers: before) ].
	^ ((results collect: [ :each | each values ]) select: [ :each | each = after ])
		  size
]

{ #category : #accessing }
AoCSample >> instruction: fourNumbers [

	instruction := fourNumbers
]
