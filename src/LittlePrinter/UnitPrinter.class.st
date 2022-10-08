Class {
	#name : #UnitPrinter,
	#superclass : #Printer,
	#instVars : [
		'integerPrinter',
		'fractionPrinter',
		'units',
		'base'
	],
	#category : #LittlePrinter
}

{ #category : #'instance creation' }
UnitPrinter class >> base: anInteger units: anArray [
	^ self new 
		base: anInteger;
		units: anArray;
		yourself
]

{ #category : #accessing }
UnitPrinter >> base: anInteger [
	base := anInteger
]

{ #category : #accessing }
UnitPrinter >> fractionPrinter: aPrinter [
	fractionPrinter := aPrinter
]

{ #category : #initialization }
UnitPrinter >> initialize [
	super initialize.
	self integerPrinter: (NumberPrinter new
		precision: 0;
		yourself).
	self fractionPrinter: (NumberPrinter new
		precision: 1;
		yourself)
]

{ #category : #accessing }
UnitPrinter >> integerPrinter: aPrinter [
	integerPrinter := aPrinter
]

{ #category : #printing }
UnitPrinter >> print: anObject on: aStream [
	anObject = 1
		ifTrue: [ ^ self print: anObject unit: units first on: aStream ].
	units allButFirst
		inject: anObject asFloat
		into: [ :value :each |
			value < base
				ifFalse: [ value / base ]
				ifTrue: [ ^ self print: value unit: each on: aStream ] ]
]

{ #category : #printing }
UnitPrinter >> print: aNumber unit: aString on: aStream [
	(units first = aString or: [ units second = aString ])
		ifTrue: [ integerPrinter print: aNumber on: aStream ]
		ifFalse: [ fractionPrinter print: aNumber on: aStream ].
	aStream nextPut: $ ; nextPutAll: aString
]

{ #category : #accessing }
UnitPrinter >> units: anArray [
	units := anArray
]
