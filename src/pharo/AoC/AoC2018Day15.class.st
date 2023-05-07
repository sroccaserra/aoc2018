"
Example:

AoC2018Day15 new run: 'Developer/github/aoc2018/src/15.txt'

"
Class {
	#name : #AoC2018Day15,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day15 >> run: filename [

	| lines grid |
	lines := self loadLines: filename.
	grid := AoCTextGrid fromLines: lines.

	TextGridDisplay new
		textGrid: grid;
		openInWindow
]
