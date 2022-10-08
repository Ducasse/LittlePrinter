Class {
	#name : #MappedPrinter,
	#superclass : #Printer,
	#instVars : [
		'next',
		'block'
	],
	#category : #LittlePrinter
}

{ #category : #'instance creation' }
MappedPrinter class >> block: aBlock next: aPrinter [
	^ self new 
		block: aBlock;
		next: aPrinter;
		yourself
]

{ #category : #accessing }
MappedPrinter >> block: aBlock [
	block := aBlock
]

{ #category : #initialization }
MappedPrinter >> initialize [
	super initialize.
	self block: [ :value | value ]
]

{ #category : #accessing }
MappedPrinter >> next: aPrinter [
	next := aPrinter
]

{ #category : #printing }
MappedPrinter >> print: anObject on: aStream [
	next print: (block value: anObject) on: aStream
]
