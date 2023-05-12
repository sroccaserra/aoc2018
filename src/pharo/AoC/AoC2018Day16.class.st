"
Example:

AoC2018Day16 new run: 'Developer/github/aoc2018/src/16.txt'.
"
Class {
	#name : #AoC2018Day16,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

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

	^ AoCInstruction fromNumbers:
		  (aString substrings collect: [ :each | each asInteger ])
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
	samples := sampleGroups collect: [ :sample | self parseSample: sample ].
	^ self solvePartOne: samples
]

{ #category : #running }
AoC2018Day16 >> solvePartOne: samples [

	^ (samples select: [ :each | each countMatching >= 3 ]) size
]
