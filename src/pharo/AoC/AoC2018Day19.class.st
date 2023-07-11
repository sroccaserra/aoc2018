"
no comment
"
Class {
	#name : #AoC2018Day19,
	#superclass : #AoCBase,
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

	| lines program ipReg |
	lines := self loadLines: filename.
	ipReg := (lines at: 1) last asInteger - $0 asInteger.
	program := lines allButFirst collect: [ :line | self parseLine: line ].
	^ self run: program withIpReg: ipReg startingFrom: #( 0 0 0 0 0 0 ).

]

{ #category : #running }
AoC2018Day19 >> run: aProgram withIpReg: ipReg startingFrom: stateNumbers [

	| state |
	state := AoCState fromNumbers: stateNumbers .
	[ 0 <= (state at: ipReg) and: [ (state at: ipReg) < aProgram size ] ]
		whileTrue: [
			| instruction |
			instruction := aProgram at: (state at: ipReg) + 1.
			instruction executeOn: state.
			state at: ipReg put: (state at: ipReg) + 1 ].
	^ state at: 0
]
