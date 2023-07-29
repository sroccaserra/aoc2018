"
no comment
"
Class {
	#name : #AoC2018Day19,
	#superclass : #AoCVisualBase,
	#instVars : [
		'ipReg',
		'program',
		'state',
		'view'
	],
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day19 >> debugPartTwo [

	state := AoCState fromNumbers: #( 1 0 0 0 0 0 ).
	self show.
	view on: #mouseUp send: #value to: [
		self step.
		Clipboard clipboardText: state asString.
		self show ].
	^ state at: 0
]

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
AoC2018Day19 >> rewrittenPartTwo [

	state := AoCState fromNumbers: #( 0 1 3 10551288 1 0 10550400 ).
	[ (state at: 4) <= (state at: 3) ] whileTrue: [
		state at: 1 put: 1.
		[ (state at: 1) <= (state at: 3) ] whileTrue: [
			(state at: 4) * (state at: 1) = 10551288 ifTrue: [
				state at: 0 put: (state at: 0) + (state at: 4) ].
			state at: 1 put: (state at: 1) + 1 ].
		state at: 4 put: (state at: 4) + 1 ].
	^ state at: 0
]

{ #category : #running }
AoC2018Day19 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	ipReg := (lines at: 1) last asInteger - $0 asInteger.
	program := lines allButFirst collect: [ :line | self parseLine: line ].
	^ {
		  self solvePartOne.
		  self solvePartTwo }
]

{ #category : #showing }
AoC2018Day19 >> show [

	| programLines |
	view ifNil: [
		view := SpRubScrolledTextMorph new.
		view extent: 200 @ 800.
		view openInWindowLabeled: 'AoC2018Day19' ].

	programLines := program collectWithIndex: [ :each :i |
		                | prefix pc |
		                pc := state at: ipReg.
		                prefix := i - 1 = pc
			                          ifTrue: [ '>' ]
			                          ifFalse: [ (i - 1) asString ].
		                prefix , Character tab asString , each asString ].
	view setText:
		(Character cr join: programLines , ' ' , { state asString })
]

{ #category : #running }
AoC2018Day19 >> solvePartOne [

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

{ #category : #running }
AoC2018Day19 >> solvePartTwo [

	| target sum i j |
	sum := 0.
	target := 10551288.
	"target := 888."
	i := 1.
	[ i <= target ] whileTrue: [
		j := 1.
		[ i * j <= target ] whileTrue: [
			i * j = target ifTrue: [ sum := sum + i ].
			j := j + 1 ].
		i := i + 1 ].
	^ sum
]

{ #category : #running }
AoC2018Day19 >> step [

	| instruction ip |
	ip := state at: ipReg.
	instruction := program at: ip + 1.
	instruction executeOn: state.
	state at: ipReg put: (state at: ipReg) + 1
]
