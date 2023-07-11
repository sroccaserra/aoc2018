"
no comment
"
Class {
	#name : #AoC2018Day19,
	#superclass : #AoCBase,
	#instVars : [
		'ipReg',
		'program'
	],
	#category : #'AoC-2018'
}

{ #category : #parsing }
AoC2018Day19 >> parseLine: aString [

	| parts mnemonic args |
	parts := aString substrings.
	mnemonic := parts first asSymbol.
	args := parts allButFirst collect: [ :each | each asInteger ].
	^ AoCInstruction new
		  mnemonic: mnemonic;
		  implementation: (AoCInstruction implementations at: mnemonic);
		  a: args first;
		  b: args second;
		  c: args third;
		  yourself
]

{ #category : #running }
AoC2018Day19 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	ipReg := (lines at: 1) last asInteger - $0 asInteger.
	program := lines allButFirst collect: [ :line | self parseLine: line ].
	^ self solvePartOne
]

{ #category : #running }
AoC2018Day19 >> solvePartOne [

	| state |
	state := AoCState fromNumbers: #( 0 0 0 0 0 0 ).
	[ 0 <= (state at: ipReg) and: [ (state at: ipReg) < program size ] ]
		whileTrue: [
			| instruction ip |
			ip := state at: ipReg.
			instruction := program at: ip + 1.
			instruction executeOn: state.
			state at: ipReg put: (state at: ipReg) + 1 ].
	^ state at: 0
]
