Class {
	#name : #SignPrinter,
	#superclass : #Printer,
	#instVars : [
		'negativePrinter',
		'positivePrinter'
	],
	#category : #LittlePrinter
}

{ #category : #initialization }
SignPrinter >> initialize [
	super initialize.
	self negativePrinter: $-.
	self positivePrinter: nil
]

{ #category : #accessing }
SignPrinter >> negativePrinter: aPrinter [
	"The printer to be used when the number is negative."
	
	negativePrinter := aPrinter
]

{ #category : #accessing }
SignPrinter >> positivePrinter: aPrinter [
	"The printer to be used when the number is zero or positive."
	
	positivePrinter := aPrinter
]

{ #category : #printing }
SignPrinter >> print: anObject on: aStream [ 
	anObject negative
		ifTrue: [ negativePrinter print: anObject on: aStream ]
		ifFalse: [ positivePrinter print: anObject on: aStream ]
]
