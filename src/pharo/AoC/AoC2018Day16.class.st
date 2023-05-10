"
Example:

AoC2018Day16 new run: 'Developer/github/aoc2018/src/16.txt'.
"
Class {
	#name : #AoC2018Day16,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day16 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	^ ((lines groupByRuns: [ :each | each isEmpty ]) reject: [ :each | 
		   each first isEmpty ]) collect: [ :each | each size ]
]
