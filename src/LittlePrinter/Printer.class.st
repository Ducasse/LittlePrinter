Class {
	#name : #Printer,
	#superclass : #Object,
	#category : #LittlePrinter
}

{ #category : #'parts-date' }
Printer class >> abbreviatedMonthName [
	^ self monthName: #('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec')
]

{ #category : #'parts-date' }
Printer class >> abbreviatedWeekName [
	^ self weekName: #('Sun' 'Mon' 'Tue' 'Wed' 'Thu' 'Fri' 'Sat')
]

{ #category : #'parts-date' }
Printer class >> absOffsetHoursPadded [
	^ MappedPrinter 
		block: [ :date | date offset hours abs ]
		next: (self numberWithAtLeastDigits: 2)
]

{ #category : #'parts-date' }
Printer class >> absOffsetMinutesPadded [
	^ MappedPrinter 
		block: [ :date | date offset minutes abs ]
		next: (self numberWithAtLeastDigits: 2)
]

{ #category : #'parts-units' }
Printer class >> binaryFileSize [
	^ UnitPrinter base: 1024 units: #('byte' 'bytes' 'KiB' 'MiB' 'GiB' 'TiB' 'PiB' 'EiB' 'ZiB' 'YiB')
]

{ #category : #'factory-http' }
Printer class >> cookieTimestamp [
	"Netscape's original proposal defined an Expires header that took a date value in a fixed-length variant format in place of Max-Age: Wdy, DD-Mon-YY HH:MM:SS GMT"

	^ MappedPrinter
		block: [ :timestamp | timestamp asUTC ]
		next: self abbreviatedWeekName , ', ' , self paddedDay , '-' , self abbreviatedMonthName , '-' , self paddedYear , ' ' , self isoTime , ' GMT'
]

{ #category : #'parts-units' }
Printer class >> decimalFileSize [
	^ UnitPrinter base: 1000 units: #('byte' 'bytes' 'kB' 'MB' 'GB' 'TB' 'PB' 'EB' 'ZB' 'YB')
]

{ #category : #'parts-date' }
Printer class >> fullMonthName [
	^ self monthName: #('January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December')
]

{ #category : #'parts-date' }
Printer class >> fullWeekName [
	^ self weekName: #('Sunday' 'Monday' 'Tuesday' 'Wednesday' 'Thursday' 'Friday' 'Saturday')
]

{ #category : #'factory-http' }
Printer class >> httpDate [
	"Answers a printer that formats dates for HTTP1.1 (RFC 2616)"

	^ self rfc1123
]

{ #category : #'factory-http' }
Printer class >> isoDate [
	"Ansers a printer that formats dates according to ISO(YYYY-MM-DD) E.g. 2003-12-24"

	^ self paddedYear , $- , self paddedMonth , $- , self paddedDay
]

{ #category : #'factory-http' }
Printer class >> isoTime [
	"Ansers a printer that formats time according to ISO(HH:MM:SS) E.g. 12:23:34"
	
	^ self paddedHour24 , $: , self paddedMinute , $: , self paddedSecond
]

{ #category : #'parts-date' }
Printer class >> monthName: anArray [ 
	^ PluggablePrinter on: [ :date | anArray at: date monthIndex ]
]

{ #category : #'parts-units' }
Printer class >> numberWithAtLeastDigits: anInteger [
	^ NumberPrinter new
		padding: $0;
		digits: anInteger;
		yourself
]

{ #category : #'parts-date' }
Printer class >> offsetSign [
	^ MappedPrinter 
		block: [ :date | date offset ]
		next: (SignPrinter new
				positivePrinter: $+;
				negativePrinter: $-;
				yourself)
]

{ #category : #'parts-date' }
Printer class >> paddedCentury [
	^ MappedPrinter 
		block: [ :date | date year \\ 100 ]
		next: (self numberWithAtLeastDigits: 2)
]

{ #category : #'parts-date' }
Printer class >> paddedDay [
	^ MappedPrinter 
		block: [ :date | date dayOfMonth ]
		next: (self numberWithAtLeastDigits: 2)
]

{ #category : #'parts-time' }
Printer class >> paddedHour12 [
	^ MappedPrinter 
		block: [ :time | (time hour - 1) \\ 12 + 1 ]
		next: (self numberWithAtLeastDigits: 2)
]

{ #category : #'parts-time' }
Printer class >> paddedHour24 [
	^ MappedPrinter 
		block: [ :time | time hour ]
		next: (self numberWithAtLeastDigits: 2)
]

{ #category : #'parts-time' }
Printer class >> paddedMinute [
	^ MappedPrinter 
		block: [ :time | time minute ]
		next: (self numberWithAtLeastDigits: 2)
]

{ #category : #'parts-date' }
Printer class >> paddedMonth [
	^ MappedPrinter 
		block: [ :date | date monthIndex ]
		next: (self numberWithAtLeastDigits: 2)
]

{ #category : #'parts-time' }
Printer class >> paddedSecond [
	^ MappedPrinter 
		block: [ :time | time second ]
		next: (NumberPrinter new
				padding: $0;
				digits: 2)
]

{ #category : #'parts-date' }
Printer class >> paddedYear [
	^ MappedPrinter 
		block: [ :date | date year ]
		next: (self numberWithAtLeastDigits: 4)
]

{ #category : #'factory-http' }
Printer class >> rfc1123 [
	"Answers a printer that formats dates for HTTP1.1 (RFC 1123). Eg.
	Sun, 06 Nov 1994 08:49:37 GMT "
	
	^ MappedPrinter 
		block: [ :date | 
			"For the purposes of HTTP, GMT is exactly equal to UTC (Coordinated Universal Time)"
			date asUTC ]
		next: SequentialPrinter new , self abbreviatedWeekName , ', ' , self paddedDay , Character space , self abbreviatedMonthName , Character space , self paddedYear , Character space , self isoTime , ' GMT'
]

{ #category : #'factory-http' }
Printer class >> rfc822 [
	"Answers a printer that formats dates according to RFC 822 (email). Eg.
	Sun, 31 Aug 2008 19:41:46 +0200"

	^ self abbreviatedWeekName , ', ' , self paddedDay , Character space , self abbreviatedMonthName , Character space , self paddedYear , Character space , self isoTime , Character space , self offsetSign , self absOffsetHoursPadded , self absOffsetMinutesPadded
]

{ #category : #'factory-http' }
Printer class >> rfc822WithTimeZone: aString [
	"Answers a privter that formats dates according to RFC 822 (email) with the given time zone String. Eg.
	Sun, 31 Aug 2008 19:41:46 <aString>"

	^ self abbreviatedWeekName , ', ' , self paddedDay , Character space , self abbreviatedMonthName , Character space , self paddedYear , Character space , self isoTime , Character space , aString
]

{ #category : #'factory-currency' }
Printer class >> swissCurrency [
	^ SequentialPrinter new , 'CHF ' , SignPrinter new , (NumberPrinter new
			separator: $';
			precision: 2;
			accuracy: 0.05;
			yourself)
]

{ #category : #'parts-date' }
Printer class >> unpaddedCentury [
	^ MappedPrinter 
		block: [ :date | date year \\ 100 ]
		next: NumberPrinter new
]

{ #category : #'parts-date' }
Printer class >> unpaddedDay [
	^ MappedPrinter 
		block: [ :date | date dayOfMonth ]
		next: NumberPrinter new
]

{ #category : #'parts-time' }
Printer class >> unpaddedHour12 [
	^ MappedPrinter 
		block: [ :time | (time hour - 1) \\ 12 + 1 ]
		next: NumberPrinter new
]

{ #category : #'parts-time' }
Printer class >> unpaddedHour24 [
	^ MappedPrinter 
		block: [ :time | time hour ]
		next: NumberPrinter new
]

{ #category : #'parts-time' }
Printer class >> unpaddedMinute [
	^ MappedPrinter 
		block: [ :time | time minute ]
		next: NumberPrinter new
]

{ #category : #'parts-date' }
Printer class >> unpaddedMonth [
	^ MappedPrinter 
		block: [ :date | date monthIndex ]
		next: NumberPrinter new
]

{ #category : #'parts-time' }
Printer class >> unpaddedSecond [
	^ MappedPrinter 
		block: [ :time | time second ]
		next: NumberPrinter new
]

{ #category : #'parts-date' }
Printer class >> unpaddedYear [
	^ MappedPrinter 
		block: [ :date | date year ]
		next: NumberPrinter new
]

{ #category : #'factory-currency' }
Printer class >> usCurrency [
	^ SignPrinter new , $$ , (NumberPrinter new
			separator: $,;
			precision: 2;
			yourself)
]

{ #category : #'parts-date' }
Printer class >> weekName: anArray [ 
	^ PluggablePrinter on: [ :date | anArray at: date dayOfWeek ]
]

{ #category : #operators }
Printer >> , aPrinter [ 
	^ SequentialPrinter new , self , aPrinter
]

{ #category : #utilities }
Printer >> pad: aString center: aCharacter to: anInteger [
	"Pad to the center of aString with aCharacter to at least anInteger characters."

	| result index |
	anInteger <= aString size
		ifTrue: [ ^ aString ].
	index := (anInteger - aString size) // 2.
	result := (String new: anInteger) atAllPut: aCharacter.
	result
		replaceFrom: index + 1
		to: index + aString size
		with: aString
		startingAt: 1.
	^ result
]

{ #category : #utilities }
Printer >> pad: aString left: aCharacter to: anInteger [
	"Pad to the left side of aString with aCharacter to at least anInteger characters."

	| result |
	anInteger <= aString size
		ifTrue: [ ^ aString ].
	result := (String new: anInteger) atAllPut: aCharacter.
	result
		replaceFrom: anInteger - aString size + 1
		to: anInteger
		with: aString
		startingAt: 1.
	^ result
]

{ #category : #utilities }
Printer >> pad: aString right: aCharacter to: anInteger [
	"Pad to the right side of aString with aCharacter to at least anInteger characters."

	| result |
	anInteger <= aString size
		ifTrue: [ ^ aString ].
	result := (String new: anInteger) atAllPut: aCharacter.
	result
		replaceFrom: 1
		to: aString size
		with: aString
		startingAt: 1.
	^ result
]

{ #category : #printing }
Printer >> print: anObject [
	^ String streamContents: [ :stream | self print: anObject on: stream ]
]

{ #category : #printing }
Printer >> print: anObject on: aStream [
	"Subclasses override this method to produce some output."
]
