"
Tests for BLSMCoordinate.
"
Class {
	#name : 'BLSMCoordinateTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-Core',
	#package : 'Blossom-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
BLSMCoordinateTest >> testCreation [

	| c |
	c := BLSMCoordinate lat: 48.8566 lon: 2.3522.
	self assert: c latitude equals: 48.8566.
	self assert: c longitude equals: 2.3522
]

{ #category : 'tests' }
BLSMCoordinateTest >> testEquality [

	self assert: (BLSMCoordinate lat: 1 lon: 2) equals: (BLSMCoordinate lat: 1 lon: 2).
	self assert: (BLSMCoordinate lat: 1 lon: 2) hash equals: (BLSMCoordinate lat: 1 lon: 2) hash.
	self deny: (BLSMCoordinate lat: 1 lon: 2) equals: (BLSMCoordinate lat: 2 lon: 1)
]

{ #category : 'tests' }
BLSMCoordinateTest >> testInvalidLatitude [

	self should: [ BLSMCoordinate lat: 91 lon: 0 ] raise: Error.
	self should: [ BLSMCoordinate lat: -91 lon: 0 ] raise: Error
]

{ #category : 'tests' }
BLSMCoordinateTest >> testInvalidLongitude [

	self should: [ BLSMCoordinate lat: 0 lon: 181 ] raise: Error.
	self should: [ BLSMCoordinate lat: 0 lon: -181 ] raise: Error
]
