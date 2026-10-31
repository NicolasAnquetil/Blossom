Class {
	#name : 'BLSMProjectionTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-Core',
	#package : 'Blossom-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
BLSMProjectionTest >> testNorthWestCornerOfTile [

	| c |
	c := BLSMProjection new northWestOf: (BLSMTileId x: 0 y: 0 zoom: 0).
	self assert: c longitude equals: -180.
	self assert: (c latitude - 85.0511) abs < 0.001
]

{ #category : 'tests' }
BLSMProjectionTest >> testOriginAtZoomOne [

	self assert: (BLSMProjection new tileIdFor: (BLSMCoordinate lat: 0 lon: 0) zoom: 1) equals: (BLSMTileId x: 1 y: 1 zoom: 1)
]

{ #category : 'tests' }
BLSMProjectionTest >> testParisAtZoom13 [

	self
		assert: (BLSMProjection new tileIdFor: (BLSMCoordinate lat: 48.8566 lon: 2.3522) zoom: 13)
		equals: (BLSMTileId x: 4149 y: 2818 zoom: 13)
]

{ #category : 'tests' }
BLSMProjectionTest >> testPixelOfOrigin [

	self assert: (BLSMProjection new pixelFor: (BLSMCoordinate lat: 0 lon: 0) zoom: 0) equals: 128 @ 128
]

{ #category : 'tests' }
BLSMProjectionTest >> testRoundTrip [

	| p c back |
	p := BLSMProjection new.
	c := BLSMCoordinate lat: 45.5 lon: -73.6.
	back := p coordinateForPixel: (p pixelFor: c zoom: 10) zoom: 10.
	self assert: (back latitude - 45.5) abs < 1e-9.
	self assert: (back longitude + 73.6) abs < 1e-9
]
