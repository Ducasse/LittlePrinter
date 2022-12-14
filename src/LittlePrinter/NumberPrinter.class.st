"
A GRNumberPrinter prints numbers (integers and floats) in various formats in a platform independent way.

Instance Variables
	accuracy:	<UndefinedObject|Float>
	base:		<Integer>
	delimiter:	<UndefinedObject|Character>
	digits:		<UndefinedObject|Integer>
	infinite:		<UndefinedObject|String>
	nan:			<UndefinedObject|String>
	padding:	<UndefinedObject|Character>
	precision:	<Integer>
	separator:	<UndefinedObject|Character>
"
Class {
	#name : #NumberPrinter,
	#superclass : #Printer,
	#instVars : [
		'characters',
		'base',
		'delimiter',
		'digits',
		'infinite',
		'nan',
		'padding',
		'accuracy',
		'precision',
		'separator'
	],
	#classVars : [
		'NumbersToCharactersLowercase',
		'NumbersToCharactersUppercase'
	],
	#category : #LittlePrinter
}

{ #category : #initialization }
NumberPrinter class >> initialize [
	NumbersToCharactersLowercase := '0123456789abcdefghijklmnopqrstuvwxyz'.
	NumbersToCharactersUppercase := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
]

{ #category : #accessing }
NumberPrinter >> accuracy: aFloat [
	"Round towards the nearest number that is a multiple of aFloat."
	
	accuracy := aFloat
]

{ #category : #accessing }
NumberPrinter >> base: anInteger [
	"The numeric base to which the number should be printed."

	base := anInteger
]

{ #category : #accessing }
NumberPrinter >> characters: aString [
	"The characters to be used to convert a number to a string."

	characters := aString
]

{ #category : #accessing }
NumberPrinter >> delimiter: aCharacter [
	"The delimiter to separate the integer and fraction part of the number."

	delimiter := aCharacter
]

{ #category : #accessing }
NumberPrinter >> digits: anInteger [
	"The number of digits to be printed in the integer part."

	digits := anInteger
]

{ #category : #utilities }
NumberPrinter >> digitsOf: aNumber base: aBaseInteger [
	"Answer the absolute digits of aNumber in the base aBaseInteger."

	| integer stream next |
	integer := aNumber truncated abs.
	integer = 0 ifTrue: [ ^ '0' ].
	stream := WriteStream on: (String new: 10).
	[ integer > 0 ] whileTrue: [
		next := integer quo: aBaseInteger.
		stream nextPut: (characters 
			at: 1 + integer - (next * aBaseInteger)).
		integer := next ].
	^ stream contents reverse
]

{ #category : #accessing }
NumberPrinter >> infinite: aString [
	"The string that should be displayed if the number is positive or negative infinity."
	
	infinite := aString
]

{ #category : #initialization }
NumberPrinter >> initialize [
	super initialize.
	self lowercase.
	self base: 10.
	self delimiter: $..
	self infinite: 'Infinite'.
	self nan: 'NaN'.
	self padding: $ .
	self precision: 0
]

{ #category : #utilities }
NumberPrinter >> lengthOf: aNumber base: aBaseInteger [
	"Answer the number of digits of aNumber in the base aBaseInteger.
	Same as #decimalDigitLength"

	| integer current length |
	integer := aNumber truncated abs.
	length := 1.
	current := aBaseInteger.
	[ current <= integer ] whileTrue: [ 
		length := length + 1.
		current := current * aBaseInteger ].
	^ length
]

{ #category : #actions }
NumberPrinter >> lowercase [
	"Use lowercase characters for numbers of base 10 and higher."

	self characters: NumbersToCharactersLowercase
]

{ #category : #accessing }
NumberPrinter >> nan: aString [
	"The string that should be displayed if the number is not a number."
	
	nan := aString
]

{ #category : #utilities }
NumberPrinter >> padLeft: aCharacter to: aPadCountInteger on: aStream [
	"Pad to the left side of aString with aCharacter to at anInteger characters."

	1 to: aPadCountInteger do: [ :index |
		separator isNil ifFalse: [
			(index ~= 1 and: [ (digits - index) \\ 3 = 2 ])
				ifTrue: [ aStream nextPut: separator ] ].
		aStream nextPut: aCharacter ]
]

{ #category : #accessing }
NumberPrinter >> padding: aCharacter [
	"The padding for the integer part."

	padding := aCharacter
]

{ #category : #accessing }
NumberPrinter >> precision: anInteger [
	"The number of digits to be printed in the fraction part."
	
	precision := anInteger
]

{ #category : #printing }
NumberPrinter >> print: aNumber on: aStream [
	aNumber isNaN
		ifTrue: [ ^ self printNaN: aNumber on: aStream ].
	aNumber isInfinite 
		ifTrue: [ ^ self printInfinite: aNumber on: aStream ].
	precision = 0
		ifTrue: [ self printInteger: aNumber on: aStream ]
		ifFalse: [ self printFloat: aNumber on: aStream ]
]

{ #category : #utilities }
NumberPrinter >> printDigitsOf: aNumber withLength: aLengthInteger on: aStream [
	"Print the digits of aNumber with a lenght of aLengthInteger on aStream.
	Also print a separator if required."

	| rest |
	rest := aNumber truncated abs.
	1 to: aLengthInteger do: [ :index |
		| divisor current |
		divisor := base raisedTo: aLengthInteger - index.
		current := rest // divisor.
		separator isNil ifFalse: [ 
			 (index ~= 1 and: [ (aLengthInteger - index) \\ 3 = 2 ])
				ifTrue: [ aStream nextPut: separator ] ].
		aStream nextPut: (characters at: current + 1).
		rest := rest - (divisor * current) ]
]

{ #category : #printing }
NumberPrinter >> printFloat: aNumber on: aStream [
	| multiplier rounded |
	multiplier := base raisedTo: precision.
	rounded := aNumber roundTo: (accuracy ifNil: [ multiplier reciprocal ]).
	self printInteger: rounded on: aStream.
	delimiter isNil
		ifFalse: [ aStream nextPut: delimiter ].
	self printFraction: rounded fractionPart abs * multiplier on: aStream
]

{ #category : #printing }
NumberPrinter >> printFraction: aNumber on: aStream [
	| result |
	result := self
		pad: (self digitsOf: aNumber rounded base: base)
		left: $0 to: precision.
	separator isNil
		ifTrue: [ aStream nextPutAll: result ]
		ifFalse: [ self separate: result left: separator on: aStream ]
]

{ #category : #printing }
NumberPrinter >> printInfinite: aNumber on: aStream [
	infinite isNil
		ifFalse: [ aStream nextPutAll: infinite ]
]

{ #category : #printing }
NumberPrinter >> printInteger: aNumber on: aStream [
	| length |
	length := self lengthOf: aNumber base: base.
	
	(digits notNil and: [ padding notNil ])
		ifTrue: [ self padLeft: padding to: (digits - length) on: aStream ].
	
	self printDigitsOf: aNumber withLength: length on: aStream
]

{ #category : #printing }
NumberPrinter >> printNaN: anInteger on: aStream [
	nan isNil
		ifFalse: [ aStream nextPutAll: nan ]
]

{ #category : #utilities }
NumberPrinter >> separate: aString left: aCharacter on: aStream [
	"Separate from the left side every 3 characters with aCharacter."
		
	| size |
	size := aString size.
	1 to: size do: [ :index |
		(index ~= 1 and: [ index \\ 3 = 1 ])
			ifTrue: [ aStream nextPut: aCharacter ].
		aStream nextPut: (aString at: index) ]
]

{ #category : #utilities }
NumberPrinter >> separate: aString right: aCharacter [
	"Separate from the right side every 3 characters with aCharacter."
		
	| size stream |
	size := aString size.
	stream := WriteStream on: (String new: 2 * size).
	1 to: size do: [ :index |
		(index ~= 1 and: [ size - index \\ 3 = 2 ])
			ifTrue: [ stream nextPut: aCharacter ].
		stream nextPut: (aString at: index) ].
	^ stream contents
]

{ #category : #accessing }
NumberPrinter >> separator: aCharacter [
	"Separator character to be used to group digits."

	separator := aCharacter
]

{ #category : #actions }
NumberPrinter >> uppercase [
	"Use uppercase characters for numbers of base 10 and higher."
	
	self characters: NumbersToCharactersUppercase
]
