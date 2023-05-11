"
no comment
"
Class {
	#name : #AoCInstruction,
	#superclass : #Object,
	#instVars : [
		'opcode',
		'a',
		'b',
		'c',
		'implementation'
	],
	#category : #'AoC-2018'
}

{ #category : #'instance creation' }
AoCInstruction class >> fromNumbers: fourNumbers [

	^ self new
		  opcode: fourNumbers first;
		  a: fourNumbers second;
		  b: fourNumbers third;
		  c: fourNumbers fourth;
		  yourself
]

{ #category : #accessing }
AoCInstruction class >> ops [

	^ Dictionary newFrom: { 
			  (#addr -> [ :inst :state | 
			   state
				   at: inst c put: (state at: inst a) + (state at: inst b);
				   yourself ]).
			  (#addi -> [ :inst :state | 
			   state
				   at: inst c put: (state at: inst a) + inst b;
				   yourself ]).
			  (#mulr -> [ :inst :state | 
			   state
				   at: inst c put: (state at: inst a) * (state at: inst b);
				   yourself ]).
			  (#muli -> [ :inst :state | 
			   state
				   at: inst c put: (state at: inst a) * inst b;
				   yourself ]).
			  (#banr -> [ :inst :state | 
			   state
				   at: inst c put: ((state at: inst a) bitAnd: (state at: inst b));
				   yourself ]).
			  (#bani -> [ :inst :state | 
			   state
				   at: inst c put: ((state at: inst a) bitAnd: inst b);
				   yourself ]).
			  (#borr -> [ :inst :state | 
			   state
				   at: inst c put: ((state at: inst a) bitOr: (state at: inst b));
				   yourself ]).
			  (#bori -> [ :inst :state | 
			   state
				   at: inst c put: ((state at: inst a) bitOr: inst b);
				   yourself ]).
			  (#setr -> [ :inst :state | 
			   state
				   at: inst c put: (state at: inst a);
				   yourself ]).
			  (#seti -> [ :inst :state | 
			   state
				   at: inst c put: inst a;
				   yourself ]).
			  (#gtir -> [ :inst :state | 
			   state
				   at: inst c put: { 
						   (inst a bytesCompare: (state at: inst b)).
						   0 } max;
				   yourself ]).
			  (#gtri -> [ :inst :state | 
			   state
				   at: inst c put: { 
						   ((state at: inst a) bytesCompare: inst b).
						   0 } max;
				   yourself ]).
			  (#gtrr -> [ :inst :state | 
			   state
				   at: inst c put: { 
						   ((state at: inst a) bytesCompare: (state at: inst b)).
						   0 } max;
				   yourself ]).
			  (#eqir -> [ :inst :state | 
			   state
				   at: inst c put: (inst a = (state at: inst b)
						    ifTrue: 1
						    ifFalse: 0);
				   yourself ]).
			  (#eqri -> [ :inst :state | 
			   state
				   at: inst c put: ((state at: inst a) = inst b
						    ifTrue: 1
						    ifFalse: 0);
				   yourself ]).
			  (#eqrr -> [ :inst :state | 
			   state
				   at: inst c put: ((state at: inst a) = (state at: inst b)
						    ifTrue: 1
						    ifFalse: 0);
				   yourself ]) }
]

{ #category : #accessing }
AoCInstruction >> a [

	^ a
]

{ #category : #accessing }
AoCInstruction >> a: aNumber [

	a := aNumber
]

{ #category : #accessing }
AoCInstruction >> b [

	^ b
]

{ #category : #accessing }
AoCInstruction >> b: aNumber [

	b := aNumber
]

{ #category : #accessing }
AoCInstruction >> c [

	^ c
]

{ #category : #accessing }
AoCInstruction >> c: aNumber [

	c := aNumber
]

{ #category : #execution }
AoCInstruction >> executeOn: aState [

	implementation value: self value: aState.
	^ aState
]

{ #category : #accessing }
AoCInstruction >> implementation: aBloc [

	implementation := aBloc
]

{ #category : #accessing }
AoCInstruction >> opcode: aNumber [

	opcode := aNumber
]
