"
AoC2018Day16 * 'Developer/github/aoc2018/src/16.txt'

"
Class {
	#name : #AoC2018Day16,
	#superclass : #AoCBase,
	#instVars : [
		'numberOpCodes',
		'program'
	],
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day16 >> findNumberOpCodes: matches [

	| found justFound opNumber |
	found := Dictionary new.
	[ found keys size = matches keys size ] whileFalse: [ 
		justFound := OrderedCollection new.
		matches associationsDo: [ :each | 
			each value size = 1 ifTrue: [ 
				opNumber := each value keys first.
				justFound addLast: opNumber.
				found at: opNumber put: each key ] ].
		justFound do: [ :n | 
			matches valuesDo: [ :each | each removeKey: n ifAbsent: [ nil ] ] ] ].
	^ found
]

{ #category : #parsing }
AoC2018Day16 >> parseFourNumbers: aString [

	| values |
	values := (aString substrings: '[],') allButFirst collect: [ :each | 
		          each asInteger ].
	[ values size = 4 ] assert.
	^ values
]

{ #category : #parsing }
AoC2018Day16 >> parseInstructionLine: aString [

	^ AoCInstruction fromFourNumbers:
		  (aString substrings collect: [ :each | each asInteger ])
]

{ #category : #parsing }
AoC2018Day16 >> parseProgramLine: aString [

	| values |
	values := aString substrings collect: [ :each | each asInteger ].
	[ values size = 4 ] assert.
	^ values
]

{ #category : #parsing }
AoC2018Day16 >> parseSample: someStrings [

	| before instruction after |
	before := self parseFourNumbers: someStrings first.
	instruction := self parseInstructionLine: someStrings second.
	after := self parseFourNumbers: someStrings last.
	^ AoCSample new
		  before: before;
		  instruction: instruction;
		  after: after;
		  yourself
]

{ #category : #running }
AoC2018Day16 >> run: filename [

	"
AoC2018Day16 new run: 'Developer/github/aoc2018/src/16.txt'
"

	| lines groups sampleGroups programLines samples |
	lines := self loadLines: filename.
	groups := (lines groupByRuns: [ :each | each isEmpty ]) reject: [ :each | 
		          each first isEmpty ].
	sampleGroups := groups allButLast.
	programLines := groups last.
	program := programLines collect: [ :each | self parseProgramLine: each ].
	samples := sampleGroups collect: [ :sample | self parseSample: sample ].
	^ { 
		  (self solvePartOne: samples).
		  (self solvePartTwo: samples) }
]

{ #category : #running }
AoC2018Day16 >> runProgram [

	| state instruction |
	state := AoCState new.
	program do: [ :each | 
		instruction := AoCInstruction fromFourNumbers: each.
		instruction implementation:
			(AoCInstruction ops at: (numberOpCodes at: each first)).
		instruction executeOn: state ].
	^ state
]

{ #category : #running }
AoC2018Day16 >> solvePartOne: samples [

	^ (samples select: [ :each | each countMatching >= 3 ]) size
]

{ #category : #running }
AoC2018Day16 >> solvePartTwo: samples [

	| matches |
	matches := Dictionary new.
	AoCInstruction ops keysDo: [ :opcode | matches at: opcode put: Dictionary new ].
	samples do: [ :aSample | 
		AoCInstruction ops associationsDo: [ :each | 
			(aSample matches: each value) ifTrue: [ 
				(matches at: each key) at: aSample opNumber put: true ] ] ].
	numberOpCodes := self findNumberOpCodes: matches.
	^ self runProgram at: 0
]
