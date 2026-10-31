Class {
	#name : 'BLSMMapTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-Core',
	#package : 'Blossom-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
BLSMMapTest >> origin [

	^ BLSMCoordinate lat: 0 lon: 0
]

{ #category : 'tests' }
BLSMMapTest >> testCoordinateAtLocalPoint [

	| map c |
	map := BLSMMap center: self origin zoom: 0.
	map extent: 256 @ 256.
	c := map coordinateAt: 0 @ 128.
	self assert: (c longitude + 180) abs < 1e-9
]

{ #category : 'tests' }
BLSMMapTest >> testInvalidRowsAreSkipped [

	| map |
	map := BLSMMap center: self origin zoom: 0.
	map extent: 256 @ 512.
	self assert: map visibleTiles size equals: 1
]

{ #category : 'tests' }
BLSMMapTest >> testLocalPointOfCoordinate [

	| map |
	map := BLSMMap center: self origin zoom: 3.
	map extent: 400 @ 300.
	self assert: (map localPointOf: self origin) equals: 200 @ 150
]

{ #category : 'tests' }
BLSMMapTest >> testMaxZoomIsConfigurable [

	| map |
	map := BLSMMap center: self origin zoom: 16.
	map maxZoom: 17.
	map
		zoomIn;
		zoomIn.
	self assert: map zoom equals: 17
]

{ #category : 'tests' }
BLSMMapTest >> testPanMovesCenterOppositeToDrag [

	| map |
	map := BLSMMap center: self origin zoom: 1.
	map extent: 256 @ 256.
	map panBy: 128 @ 0.
	self assert: (map center longitude - -90) abs < 1e-9.
	self assert: map center latitude abs < 1e-9
]

{ #category : 'tests' }
BLSMMapTest >> testPanWrapsLongitude [

	| map |
	map := BLSMMap center: (BLSMCoordinate lat: 0 lon: 170) zoom: 0.
	map panBy: -256 @ 0.
	self assert: (map center longitude - 170) abs < 1e-6
]

{ #category : 'tests' }
BLSMMapTest >> testSingleTileAtZoomZero [

	| map tiles |
	map := BLSMMap center: self origin zoom: 0.
	map extent: 256 @ 256.
	tiles := map visibleTiles.
	self assert: tiles size equals: 1.
	self assert: tiles first key equals: (BLSMTileId x: 0 y: 0 zoom: 0).
	self assert: tiles first value equals: 0 @ 0
]

{ #category : 'tests' }
BLSMMapTest >> testWideViewportRepeatsWorldHorizontally [

	| map tiles |
	map := BLSMMap center: self origin zoom: 0.
	map extent: 512 @ 256.
	tiles := map visibleTiles.
	self assert: (tiles collect: [ :a | a key x ] as: Array) equals: #( -1 0 1 ).
	self assert: (tiles collect: [ :a | a value ] as: Array) equals: {
			(-128 @ 0).
			(128 @ 0).
			(384 @ 0) }
]

{ #category : 'tests' }
BLSMMapTest >> testZoomIsClamped [

	| map |
	map := BLSMMap center: self origin zoom: 19.
	map zoomIn.
	self assert: map zoom equals: 19.
	map
		zoom: 0;
		zoomOut.
	self assert: map zoom equals: 0.
	map zoomIn.
	self assert: map zoom equals: 1
]
