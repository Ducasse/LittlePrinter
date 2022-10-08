Class {
	#name : #PluggablePrinter,
	#superclass : #Printer,
	#instVars : [
		'block'
	],
	#category : #LittlePrinter
}

{ #category : #'instance creation' }
PluggablePrinter class >> on: aBlock [
	^ self new block: aBlock
]

{ #category : #accessing }
PluggablePrinter >> block: aBlock [
	block := aBlock
]

{ #category : #initialization }
PluggablePrinter >> initialize [
	super initialize.
	self block: [ :value | String new ]
]

{ #category : #printing }
PluggablePrinter >> print: anObject on: aStream [
	aStream nextPutAll: (block value: anObject)
]
