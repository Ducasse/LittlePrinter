Class {
	#name : #OrdinalizePrinter,
	#superclass : #Printer,
	#category : #LittlePrinter
}

{ #category : #private }
OrdinalizePrinter >> ordinalize: anInteger [
	^ (anInteger \\ 100 between: 11 and: 13)
		ifTrue: [ 'th' ]
		ifFalse: [ 
			#('st' 'nd' 'rd')
				at: anInteger \\ 10 
				ifAbsent: [ 'th' ] ]
]

{ #category : #printing }
OrdinalizePrinter >> print: anObject on: aStream [
	aStream nextPutAll: (self ordinalize: anObject integerPart)
]
