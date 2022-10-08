Class {
	#name : #SequentialPrinter,
	#superclass : #Printer,
	#instVars : [
		'parts'
	],
	#category : #LittlePrinter
}

{ #category : #operators }
SequentialPrinter >> , aConverter [
	parts add: aConverter
]

{ #category : #initialization }
SequentialPrinter >> initialize [
	super initialize.
	parts := OrderedCollection new
]

{ #category : #printing }
SequentialPrinter >> print: anObject on: aStream [ 
	parts do: [ :each | each print: anObject on: aStream ]
]
