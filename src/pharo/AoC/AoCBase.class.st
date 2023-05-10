"
No comment.
"
Class {
	#name : #AoCBase,
	#superclass : #Object,
	#category : #'AoC-Base'
}

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
