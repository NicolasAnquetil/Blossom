"
I keep the OpenHistoricalMap features that exist at a given year, using their start_decdate / end_decdate attributes (decimal years; a missing bound is open). An integer year means the middle of that year. With no year, everything is kept.
"
Class {
	#name : 'BLSMDateFilter',
	#superclass : 'Object',
	#instVars : [
		'year'
	],
	#category : 'Blossom-VectorTiles',
	#package : 'Blossom',
	#tag : 'VectorTiles'
}

{ #category : 'instance creation' }
BLSMDateFilter class >> year: aNumber [

	^ self new
		  year: aNumber;
		  yourself
]

{ #category : 'filtering' }
BLSMDateFilter >> decimalYear [
	"An integer year stands for the middle of that year"

	^ year isInteger
		  ifTrue: [ year + 0.5 ]
		  ifFalse: [ year ]
]

{ #category : 'filtering' }
BLSMDateFilter >> includes: aFeature [

	| y start end |
	year ifNil: [ ^ true ].
	y := self decimalYear.
	start := aFeature at: 'start_decdate'.
	end := aFeature at: 'end_decdate'.
	(start isNumber and: [ y < start ]) ifTrue: [ ^ false ].
	(end isNumber and: [ y > end ]) ifTrue: [ ^ false ].
	^ true
]

{ #category : 'filtering' }
BLSMDateFilter >> year [

	^ year
]

{ #category : 'filtering' }
BLSMDateFilter >> year: aNumberOrNil [

	year := aNumberOrNil
]
