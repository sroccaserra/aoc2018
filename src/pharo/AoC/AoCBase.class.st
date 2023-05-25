"
No comment.
"
Class {
	#name : #AoCBase,
	#superclass : #Object,
	#category : #'AoC-Base'
}

{ #category : #arithmetic }
AoCBase class >> * filename [

	^ self new run: filename
]

{ #category : #running }
AoCBase >> loadLines: filename [

	| file |
	file := FileSystem disk workingDirectory / filename.
	^ file contents lines
]

{ #category : #running }
AoCBase >> run: filename [

	self subclassResponsibility
]
