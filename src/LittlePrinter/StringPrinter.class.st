Class {
	#name : #StringPrinter,
	#superclass : #Printer,
	#instVars : [
		'trim',
		'length',
		'pad',
		'character'
	],
	#category : #LittlePrinter
}

{ #category : #accessing }
StringPrinter >> character: aCharacter [
	"The character to pad the string with."
	
	character := aCharacter
]

{ #category : #initialization }
StringPrinter >> initialize [
	super initialize.
	self character: $ ; length: nil.
	self trimNone; padNone
]

{ #category : #accessing }
StringPrinter >> length: anInteger [
	"The maximal size of the string, or the size to pad to."

	length := anInteger
]

{ #category : #padding }
StringPrinter >> padCenter [
	"Pad to the center."
	
	pad := #pad:center:to:
]

{ #category : #padding }
StringPrinter >> padLeft [
	"Pad to the left."
	
	pad := #pad:left:to:
]

{ #category : #padding }
StringPrinter >> padNone [
	"Do not pad the input."
	
	pad := nil
]

{ #category : #padding }
StringPrinter >> padRight [
	"Pad to the right."
	
	pad := #pad:right:to:
]

{ #category : #printing }
StringPrinter >> print: anObject on: aStream [ 
	| string |
	string := anObject greaseString.
	trim isNil
		ifFalse: [ string := string perform: trim ].
	length isNil ifFalse: [
		length < string size 
			ifTrue: [ string := string copyFrom: 1 to: length ].
		(pad isNil or: [ character isNil ])
			ifFalse: [ string := self perform: pad with: string with: character with: length ] ].
	aStream nextPutAll: string
]

{ #category : #trimming }
StringPrinter >> trimBoth [
	"Trim to the left and to the right."

	trim := #trimBoth
]

{ #category : #trimming }
StringPrinter >> trimLeft [
	"Trim to the left and to the right."

	trim := #trimLeft
]

{ #category : #trimming }
StringPrinter >> trimNone [
	"Do not trim the input."

	trim := nil
]

{ #category : #trimming }
StringPrinter >> trimRight [
	"Trim to the left and to the right."

	trim := #trimRight
]
