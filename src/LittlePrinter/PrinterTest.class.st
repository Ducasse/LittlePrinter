Class {
	#name : #PrinterTest,
	#superclass : #TestCase,
	#category : #LittlePrinter
}

{ #category : #accessing }
PrinterTest class >> packageNamesUnderTest [
	^ #('Grease-Core')
]

{ #category : #'tests-utilites' }
PrinterTest >> separate: aString left: aCharacter [
	| converter |
	converter := NumberPrinter new.
	^ String streamContents: [ :stream |
		converter 
			separate: aString
			left: aCharacter
			on: stream ]
]

{ #category : #tests }
PrinterTest >> testComposedPrinter [
	| converter |
	converter := SequentialPrinter new , 'CHF ' , NumberPrinter new.
	self assert: (converter print: 1234) = 'CHF 1234'.
	self assert: (converter print: -1234) = 'CHF 1234'.
	converter := SignPrinter new , NumberPrinter new , '%'.
	self assert: (converter print: 1234) = '1234%'.
	self assert: (converter print: -1234) = '-1234%'
]

{ #category : #'tests-timestamp' }
PrinterTest >> testCookieTimestamp [
	| printer date |
	printer := Printer cookieTimestamp.
	date := DateAndTime 
		year: 2008
		month: 8
		day: 1
		hour: 9
		minute: 4
		second: 4
		offset: (Duration 
				days: 0
				hours: 0
				minutes: 0
				seconds: 0).
	self assert: (printer print: date) = 'Fri, 01-Aug-2008 09:04:04 GMT'
]

{ #category : #'tests-utilites' }
PrinterTest >> testDigitsOf [
	| converter |
	converter := NumberPrinter new.
	self assert: (converter 
			digitsOf: 0.0
			base: 10) = '0'.
	self assert: (converter 
			digitsOf: 1.0
			base: 10) = '1'.
	self assert: (converter 
			digitsOf: -1.0
			base: 10) = '1'.
	self assert: (converter 
			digitsOf: -1234567890
			base: 10) = '1234567890'.
	self assert: (converter 
			digitsOf: 1234567890
			base: 10) = '1234567890'.
	self assert: (converter 
			digitsOf: -9876543210
			base: 10) = '9876543210'.
	self assert: (converter 
			digitsOf: 9876543210
			base: 10) = '9876543210'
]

{ #category : #'tests-utilites' }
PrinterTest >> testDigitsOfBase [
	| converter |
	converter := NumberPrinter new.
	self assert: (converter 
			digitsOf: 1234
			base: 2) = '10011010010'.
	self assert: (converter 
			digitsOf: 1234
			base: 3) = '1200201'.
	self assert: (converter 
			digitsOf: 1234
			base: 4) = '103102'.
	self assert: (converter 
			digitsOf: 1234
			base: 5) = '14414'.
	self assert: (converter 
			digitsOf: 1234
			base: 6) = '5414'.
	self assert: (converter 
			digitsOf: 1234
			base: 7) = '3412'.
	self assert: (converter 
			digitsOf: 1234
			base: 8) = '2322'.
	self assert: (converter 
			digitsOf: 1234
			base: 9) = '1621'.
	self assert: (converter 
			digitsOf: 1234
			base: 10) = '1234'.
	self assert: (converter 
			digitsOf: 1234
			base: 11) = 'a22'.
	self assert: (converter 
			digitsOf: 1234
			base: 12) = '86a'.
	self assert: (converter 
			digitsOf: 1234
			base: 13) = '73c'.
	self assert: (converter 
			digitsOf: 1234
			base: 14) = '642'.
	self assert: (converter 
			digitsOf: 1234
			base: 15) = '574'.
	self assert: (converter 
			digitsOf: 1234
			base: 16) = '4d2'
]

{ #category : #tests }
PrinterTest >> testFileSizePrinterBinary [
	| converter |
	converter := Printer binaryFileSize.
	self assert: (converter print: 1) equals: '1 byte'.
	self assert: (converter print: 2) equals: '2 bytes'.
	self assert: (converter print: 30) equals: '30 bytes'.
	self assert: (converter print: 500) equals: '500 bytes'.
	self assert: (converter print: 6000) equals: '5.9 KiB'.
	self assert: (converter print: 70000) equals: '68.4 KiB'.
	self assert: (converter print: 800000) equals: '781.3 KiB'.
	self assert: (converter print: 9000000) equals: '8.6 MiB'.
	self assert: (converter print: 10000000) equals: '9.5 MiB'.
	self assert: (converter print: 200000000) equals: '190.7 MiB'.
	self assert: (converter print: 3000000000) equals: '2.8 GiB'.
	self assert: (converter print: 40000000000) equals: '37.3 GiB'
]

{ #category : #tests }
PrinterTest >> testFileSizePrinterDecimal [
	| converter |
	converter := Printer decimalFileSize.
	self assert: (converter print: 1)  equals:  '1 byte'.
	self assert: (converter print: 2)  equals:  '2 bytes'.
	self assert: (converter print: 30)  equals:  '30 bytes'.
	self assert: (converter print: 500)  equals:  '500 bytes'.
	self assert: (converter print: 6000)  equals:  '6.0 kB'.
	self assert: (converter print: 70000)  equals:  '70.0 kB'.
	self assert: (converter print: 800000)  equals:  '800.0 kB'.
	self assert: (converter print: 9000000)  equals:  '9.0 MB'.
	self assert: (converter print: 10000000)  equals:  '10.0 MB'.
	self assert: (converter print: 200000000)  equals:  '200.0 MB'.
	self assert: (converter print: 3000000000)  equals:  '3.0 GB'.
	self assert: (converter print: 40000000000)  equals:  '40.0 GB'
]

{ #category : #tests }
PrinterTest >> testFloatPrinter [
	| converter |
	converter := NumberPrinter new precision: 2.
	self assert: (converter print: 1.009) equals: '1.01'.
	self assert: (converter print: 1.01) equals: '1.01'.
	self assert: (converter print: 1.019) equals: '1.02'.
	self assert: (converter print: 1.25) equals: '1.25'.
	self assert: (converter print: 1.254) equals: '1.25'.
	self assert: (converter print: 1.256) equals: '1.26'.
	self assert: (converter print: 1.009) equals: '1.01'.
	self assert: (converter print: 0.9) equals: '0.90'.
	self assert: (converter print: 0.99) equals: '0.99'.
	self assert: (converter print: 0.999) equals: '1.00'.
	self assert: (converter print: 0.9999) equals: '1.00'.
	self assert: (converter print: -0.9) equals: '0.90'.
	self assert: (converter print: -0.99) equals: '0.99'.
	self assert: (converter print: -0.999) equals: '1.00'.
	self assert: (converter print: -0.9999) equals: '1.00'
]

{ #category : #tests }
PrinterTest >> testFloatPrinterInfinity [
	| converter |
	converter := NumberPrinter new.
	self assert: (converter print: Float infinity) = 'Infinite'.
	self assert: (converter print: Float infinity negated) = 'Infinite'.
	converter infinite: 'very huge'.
	self assert: (converter print: Float infinity) = 'very huge'.
	self assert: (converter print: Float infinity negated) = 'very huge'
]

{ #category : #tests }
PrinterTest >> testFloatPrinterNaN [
	| converter |
	converter := NumberPrinter new.
	self assert: (converter print: Float nan) equals: 'NaN'.
	converter nan: 'Not A Number'.
	self assert: (converter print: Float nan) equals: 'Not A Number'
]

{ #category : #tests }
PrinterTest >> testFloatPrinterPadding [
	| converter |
	converter := NumberPrinter new.
	converter digits: 3.
	self assert: (converter print: 1) equals: '  1'.
	self assert: (converter print: 12) equals: ' 12'.
	self assert: (converter print: 123) equals: '123'.
	self assert: (converter print: 1234) equals: '1234'.
	converter padding: $*.
	self assert: (converter print: 1) equals: '**1'.
	self assert: (converter print: 12) equals: '*12'.
	self assert: (converter print: 123) equals: '123'.
	self assert: (converter print: 1234) equals: '1234'
]

{ #category : #tests }
PrinterTest >> testFloatPrinterSeparator [
	| converter |
	converter := NumberPrinter new.
	converter
		precision: 2;
		separator: $*.
	self assert: (converter print: 12345.0) equals: '12*345.00'.
	self assert: (converter print: 0.6789) equals: '0.68'.
	converter
		precision: 4;
		separator: $!.
	self assert: (converter print: 12345.0) equals: '12!345.000!0'.
	self assert: (converter print: 0.6789) equals: '0.678!9'
]

{ #category : #'tests-parts-date' }
PrinterTest >> testFullMonthName [
	| printer |
	printer := Printer fullMonthName.
	self assert: (printer print: (Date year: 2000 month: 8 day: 1)) = 'August'.
	self assert: (printer print: (Date year: 2000 month: 11 day: 1)) = 'November'
]

{ #category : #'tests-parts-date' }
PrinterTest >> testFullWeekName [
	| printer |
	printer := Printer fullWeekName.
	self assert: (printer print: (Date year: 1980 month: 1 day: 1)) = 'Tuesday'.
	self assert: (printer print: (Date year: 2000 month: 1 day: 1)) = 'Saturday'
]

{ #category : #'tests-timestamp' }
PrinterTest >> testHttp [
	| printer date offsetHour |
	offsetHour := 2.
	printer := Printer httpDate.
	date := DateAndTime 
		year: 1994
		month: 11
		day: 6
		hour: 8 + offsetHour
		minute: 49
		second: 37
		offset: (Duration 
				days: 0
				hours: offsetHour
				minutes: 0
				seconds: 0).
	self assert: (printer print: date) = 'Sun, 06 Nov 1994 08:49:37 GMT'
]

{ #category : #tests }
PrinterTest >> testIntegerPrinter [
	| converter |
	converter := NumberPrinter new.
	self assert: (converter print: 1234) equals: '1234'.
	self assert: (converter print: -1234) equals: '1234'.
	converter separator: $..
	self assert: (converter print: 1234) equals: '1.234'.
	self assert: (converter print: 1234567) equals: '1.234.567'.
	converter
		base: 16;
		separator: nil.
	self assert: (converter print: 1234) equals: '4d2'.
	self assert: (converter print: 123123) equals: '1e0f3'.
	converter uppercase.
	self assert: (converter print: 1234) equals: '4D2'.
	self assert: (converter print: 123123) equals: '1E0F3'.
	
	
	converter
		base: 10;
		separator: $';
		digits: 6;
		padding: $0.
	self assert: (converter print: 1234) equals: '001''234'.
	self assert: (converter print: 12345) equals: '012''345'.
	self assert: (converter print: 123456) equals: '123''456'.
	self assert: (converter print: 1234567) equals: '1''234''567'.
	self assert: (converter print: 12345678) equals: '12''345''678'.
	self assert: (converter print: 123456789) equals: '123''456''789'.
	self assert: (converter print: 0) equals: '000''000'
]

{ #category : #'tests-timestamp' }
PrinterTest >> testIsoDate [
	| printer |
	printer := Printer isoDate.
	self assert: (printer print: (Date 
				year: 1980
				month: 6
				day: 11)) = '1980-06-11'.
	self assert: (printer print: (Date 
				year: 2003
				month: 12
				day: 1)) = '2003-12-01'.
	self assert: (printer print: (Date 
				year: 800
				month: 12
				day: 24)) = '0800-12-24'
]

{ #category : #'tests-timestamp' }
PrinterTest >> testIsoTime [
	| printer |
	printer := Printer isoTime.
	self assert: (printer print: (Time 
				hour: 0
				minute: 0
				second: 0)) = '00:00:00'.
	self assert: (printer print: (Time 
				hour: 1
				minute: 2
				second: 3)) = '01:02:03'.
	self assert: (printer print: (Time 
				hour: 12
				minute: 23
				second: 34)) = '12:23:34'
]

{ #category : #tests }
PrinterTest >> testOrdinalizePrinter [
	| converter |
	converter := NumberPrinter new , OrdinalizePrinter new.
	self assert: (converter print: 1) equals: '1st'.
	self assert: (converter print: 2) equals: '2nd'.
	self assert: (converter print: 3) equals: '3rd'.
	self assert: (converter print: 4) equals: '4th'.
	self assert: (converter print: 10) equals: '10th'.
	self assert: (converter print: 111) equals: '111th'.
	self assert: (converter print: 212) equals: '212th'.
	self assert: (converter print: 313) equals: '313th'.
	self assert: (converter print: 414) equals: '414th'.
	self assert: (converter print: 20) equals: '20th'.
	self assert: (converter print: 121) equals: '121st'.
	self assert: (converter print: 222) equals: '222nd'.
	self assert: (converter print: 323) equals: '323rd'.
	self assert: (converter print: 424) equals: '424th'
]

{ #category : #'tests-utilites' }
PrinterTest >> testPadCenter [
	| converter |
	converter := Printer new.
	self assert: (converter 
			pad: ''
			center: $*
			to: 3) = '***'.
	self assert: (converter 
			pad: '1'
			center: $*
			to: 3) = '*1*'.
	self assert: (converter 
			pad: '12'
			center: $*
			to: 3) = '12*'.
	self assert: (converter 
			pad: '123'
			center: $*
			to: 3) = '123'.
	self assert: (converter 
			pad: '1234'
			center: $*
			to: 3) = '1234'
]

{ #category : #'tests-utilites' }
PrinterTest >> testPadLeft [
	| converter |
	converter := Printer new.
	self assert: (converter 
			pad: ''
			left: $*
			to: 3) = '***'.
	self assert: (converter 
			pad: '1'
			left: $*
			to: 3) = '**1'.
	self assert: (converter 
			pad: '12'
			left: $*
			to: 3) = '*12'.
	self assert: (converter 
			pad: '123'
			left: $*
			to: 3) = '123'.
	self assert: (converter 
			pad: '1234'
			left: $*
			to: 3) = '1234'
]

{ #category : #'tests-utilites' }
PrinterTest >> testPadRight [
	| converter |
	converter := Printer new.
	self assert: (converter 
			pad: ''
			right: $*
			to: 3) = '***'.
	self assert: (converter 
			pad: '1'
			right: $*
			to: 3) = '1**'.
	self assert: (converter 
			pad: '12'
			right: $*
			to: 3) = '12*'.
	self assert: (converter 
			pad: '123'
			right: $*
			to: 3) = '123'.
	self assert: (converter 
			pad: '1234'
			right: $*
			to: 3) = '1234'
]

{ #category : #'tests-parts-date' }
PrinterTest >> testPaddedCentury [
	| printer |
	printer := Printer paddedCentury.
	self assert: (printer print: (Date year: 1980 month: 1 day: 1)) = '80'.
	self assert: (printer print: (Date year: 2009 month: 1 day: 1)) = '09'
]

{ #category : #'tests-parts-time' }
PrinterTest >> testPaddedHour12 [
	| printer |
	printer := Printer paddedHour12.
	self assert: (printer print: (Time hour: 5 minute: 0 second: 0)) = '05'.
	self assert: (printer print: (Time hour: 10 minute: 0 second: 0)) = '10'.
	self assert: (printer print: (Time hour: 14 minute: 0 second: 0)) = '02'.
	self assert: (printer print: (Time hour: 23 minute: 0 second: 0)) = '11'
]

{ #category : #'tests-timestamp' }
PrinterTest >> testRfc822 [
	| printer date |
	printer := Printer rfc822.
	date := DateAndTime 
		year: 2008
		month: 8
		day: 1
		hour: 9
		minute: 4
		second: 4
		offset: (Duration 
				days: 0
				hours: -2
				minutes: 0
				seconds: 0).
	self assert: (printer print: date) = 'Fri, 01 Aug 2008 09:04:04 -0200'.
	date := DateAndTime 
		year: 2008
		month: 8
		day: 31
		hour: 19
		minute: 41
		second: 46
		offset: (Duration 
				days: 0
				hours: 0
				minutes: 30
				seconds: 0).
	self assert: (printer print: date) = 'Sun, 31 Aug 2008 19:41:46 +0030'
]

{ #category : #'tests-timestamp' }
PrinterTest >> testRfc822WithTimeZone [
	| printer date |
	printer := Printer rfc822WithTimeZone: 'GMT'.
	date := DateAndTime 
		year: 2008
		month: 8
		day: 1
		hour: 9
		minute: 4
		second: 4
		offset: (Duration 
				days: 0
				hours: 0
				minutes: 0
				seconds: 0).
	self assert: (printer print: date) = 'Fri, 01 Aug 2008 09:04:04 GMT'
]

{ #category : #tests }
PrinterTest >> testScaledDecimalPrinter [
	| converter |
	converter := NumberPrinter new precision: 2.
	self assert: (converter print: 1.009s3) equals: '1.01'.
	self assert: (converter print: 1.01s2) equals: '1.01'.
	self assert: (converter print: 1.019s3) equals: '1.02'.
	self assert: (converter print: 1.25s2) equals: '1.25'.
	self assert: (converter print: 1.254s3) equals: '1.25'.
	self assert: (converter print: 1.256s3) equals: '1.26'.
	self assert: (converter print: 1.009s3) equals: '1.01'.
	self assert: (converter print: 0.9s1) equals: '0.90'.
	self assert: (converter print: 0.99s2) equals: '0.99'.
	self assert: (converter print: 0.999s3) equals: '1.00'.
	self assert: (converter print: 0.9999s4) equals: '1.00'.
	self assert: (converter print: -0.9s1) equals: '0.90'.
	self assert: (converter print: -0.99s2) equals: '0.99'.
	self assert: (converter print: -0.999s3) equals: '1.00'.
	self assert: (converter print: -0.9999s4) equals: '1.00'
]

{ #category : #'tests-utilites' }
PrinterTest >> testSeparateLeft [
	self assert: (self 
			separate: ''
			left: $*) = ''.
	self assert: (self 
			separate: '1'
			left: $*) = '1'.
	self assert: (self 
			separate: '12'
			left: $*) = '12'.
	self assert: (self 
			separate: '123'
			left: $*) = '123'.
	self assert: (self 
			separate: '1234'
			left: $*) = '123*4'.
	self assert: (self 
			separate: '12345'
			left: $*) = '123*45'.
	self assert: (self 
			separate: '123456'
			left: $*) = '123*456'.
	self assert: (self 
			separate: '1234567'
			left: $*) = '123*456*7'.
	self assert: (self 
			separate: '12345678'
			left: $*) = '123*456*78'.
	self assert: (self 
			separate: '123456789'
			left: $*) = '123*456*789'
]

{ #category : #'tests-utilites' }
PrinterTest >> testSeparateRight [
	| converter |
	converter := NumberPrinter new.
	self assert: (converter 
			separate: ''
			right: $*) = ''.
	self assert: (converter 
			separate: '1'
			right: $*) = '1'.
	self assert: (converter 
			separate: '12'
			right: $*) = '12'.
	self assert: (converter 
			separate: '123'
			right: $*) = '123'.
	self assert: (converter 
			separate: '1234'
			right: $*) = '1*234'.
	self assert: (converter 
			separate: '12345'
			right: $*) = '12*345'.
	self assert: (converter 
			separate: '123456'
			right: $*) = '123*456'.
	self assert: (converter 
			separate: '1234567'
			right: $*) = '1*234*567'.
	self assert: (converter 
			separate: '12345678'
			right: $*) = '12*345*678'.
	self assert: (converter 
			separate: '123456789'
			right: $*) = '123*456*789'
]

{ #category : #tests }
PrinterTest >> testSignPrinter [
	| converter |
	converter := SignPrinter new.
	converter
		negativePrinter: $-;
		positivePrinter: $+.
	self assert: (converter print: 12) equals: '+'.
	self assert: (converter print: -12) equals: '-'
]

{ #category : #tests }
PrinterTest >> testStringPrinter [
	| converter |
	converter := StringPrinter new.
	self assert: (converter print: 123) equals: '123'.
	self assert: (converter print: 'foo') equals: 'foo'.
	self assert: (converter print: true) equals: 'true'
]

{ #category : #tests }
PrinterTest >> testStringPrinterLength [
	| converter |
	converter := StringPrinter new.
	self assert: (converter print: 'foo') equals: 'foo'.
	converter length: 3.
	self assert: (converter print: 'foo') equals: 'foo'.
	converter length: 1.
	self assert: (converter print: 'foo') equals: 'f'
]

{ #category : #tests }
PrinterTest >> testStringPrinterPad [
	| converter |
	converter := StringPrinter new.
	converter
		character: $*;
		length: 5.
	converter padLeft.
	self assert: (converter print: 'foo') equals: '**foo'.
	converter padRight.
	self assert: (converter print: 'foo') equals: 'foo**'.
	converter padCenter.
	self assert: (converter print: 'foo') equals: '*foo*'
]

{ #category : #tests }
PrinterTest >> testStringPrinterTrim [
	| converter |
	converter := StringPrinter new.
	self assert: (converter print: ' foo ') equals: ' foo '.
	converter trimLeft.
	self assert: (converter print: ' foo ') equals: 'foo '.
	converter trimRight.
	self assert: (converter print: ' foo ') equals: ' foo'.
	converter trimBoth.
	self assert: (converter print: ' foo ') equals: 'foo'
]

{ #category : #'tests-currency' }
PrinterTest >> testSwissCurrency [
	| printer |
	printer := Printer swissCurrency.
	self assert: (printer print: 12.34) = 'CHF 12.35'.
	self assert: (printer print: -12.39) = 'CHF -12.40'
]

{ #category : #'tests-parts-date' }
PrinterTest >> testUnpaddedCentury [
	| printer |
	printer := Printer unpaddedCentury.
	self assert: (printer print: (Date year: 1980 month: 1 day: 1)) = '80'.
	self assert: (printer print: (Date year: 2009 month: 1 day: 1)) = '9'
]

{ #category : #'tests-parts-date' }
PrinterTest >> testUnpaddedDay [
	| printer |
	printer := Printer unpaddedDay.
	self assert: (printer print: (Date year: 2000 month: 1 day: 4)) = '4'.
	self assert: (printer print: (Date year: 2000 month: 1 day: 19)) = '19'
]

{ #category : #'tests-parts-time' }
PrinterTest >> testUnpaddedHour12 [
	| printer |
	printer := Printer unpaddedHour12.
	self assert: (printer print: (Time hour: 5 minute: 0 second: 0)) = '5'.
	self assert: (printer print: (Time hour: 10 minute: 0 second: 0)) = '10'.
	self assert: (printer print: (Time hour: 14 minute: 0 second: 0)) = '2'.
	self assert: (printer print: (Time hour: 23 minute: 0 second: 0)) = '11'
]

{ #category : #'tests-parts-time' }
PrinterTest >> testUnpaddedHour24 [
	| printer |
	printer := Printer unpaddedHour24.
	self assert: (printer print: (Time hour: 5 minute: 0 second: 0)) = '5'.
	self assert: (printer print: (Time hour: 10 minute: 0 second: 0)) = '10'.
	self assert: (printer print: (Time hour: 14 minute: 0 second: 0)) = '14'.
	self assert: (printer print: (Time hour: 23 minute: 0 second: 0)) = '23'
]

{ #category : #'tests-parts-time' }
PrinterTest >> testUnpaddedMinute [
	| printer |
	printer := Printer unpaddedMinute.
	self assert: (printer print: (Time hour: 0 minute: 5 second: 0)) = '5'.
	self assert: (printer print: (Time hour: 0 minute: 12 second: 0)) = '12'
]

{ #category : #'tests-parts-date' }
PrinterTest >> testUnpaddedMonth [
	| printer |
	printer := Printer unpaddedMonth.
	self assert: (printer print: (Date year: 2000 month: 8 day: 1)) = '8'.
	self assert: (printer print: (Date year: 2000 month: 11 day: 1)) = '11'
]

{ #category : #'tests-parts-time' }
PrinterTest >> testUnpaddedSecond [
	| printer |
	printer := Printer unpaddedSecond.
	self assert: (printer print: (Time hour: 0 minute: 0 second: 0)) = '0'.
	self assert: (printer print: (Time hour: 0 minute: 0 second: 9)) = '9'.
	self assert: (printer print: (Time hour: 0 minute: 0 second: 12)) = '12'
]

{ #category : #'tests-parts-date' }
PrinterTest >> testUnpaddedYear [
	| printer |
	printer := Printer unpaddedYear.
	self assert: (printer print: (Date year: 766 month: 1 day: 1)) = '766'.
	self assert: (printer print: (Date year: 1980 month: 1 day: 1)) = '1980'.
	self assert: (printer print: (Date year: 2009 month: 1 day: 1)) = '2009'
]

{ #category : #'tests-currency' }
PrinterTest >> testUsCurrency [
	| printer |
	printer := Printer usCurrency.
	self assert: (printer print: 12.34) = '$12.34'.
	self assert: (printer print: -12.34) = '-$12.34'
]
