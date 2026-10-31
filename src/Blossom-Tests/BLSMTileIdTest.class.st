Class {
	#name : 'BLSMTileIdTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-Core',
	#package : 'Blossom-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
BLSMTileIdTest >> testCreation [

	| t |
	t := BLSMTileId x: 3 y: 4 zoom: 5.
	self assert: t x equals: 3.
	self assert: t y equals: 4.
	self assert: t zoom equals: 5
]

{ #category : 'tests' }
BLSMTileIdTest >> testEquality [

	self assert: (BLSMTileId x: 1 y: 2 zoom: 3) equals: (BLSMTileId x: 1 y: 2 zoom: 3).
	self assert: (BLSMTileId x: 1 y: 2 zoom: 3) hash equals: (BLSMTileId x: 1 y: 2 zoom: 3) hash.
	self deny: (BLSMTileId x: 1 y: 2 zoom: 3) equals: (BLSMTileId x: 1 y: 2 zoom: 4)
]

{ #category : 'tests' }
BLSMTileIdTest >> testIsValid [

	self assert: (BLSMTileId x: 0 y: 3 zoom: 2) isValid.
	self deny: (BLSMTileId x: 0 y: 4 zoom: 2) isValid.
	self deny: (BLSMTileId x: 0 y: -1 zoom: 2) isValid
]

{ #category : 'tests' }
BLSMTileIdTest >> testWrapped [

	self assert: (BLSMTileId x: 5 y: 1 zoom: 2) wrapped equals: (BLSMTileId x: 1 y: 1 zoom: 2).
	self assert: (BLSMTileId x: -1 y: 1 zoom: 2) wrapped equals: (BLSMTileId x: 3 y: 1 zoom: 2)
]
