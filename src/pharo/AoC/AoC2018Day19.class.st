"
no comment
"
Class {
	#name : #AoC2018Day19,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day19 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	^ lines
]
