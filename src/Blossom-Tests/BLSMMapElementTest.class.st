Class {
	#name : 'BLSMMapElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'fake',
		'element'
	],
	#category : 'Blossom-Tests-UI',
	#package : 'Blossom-Tests',
	#tag : 'UI'
}

{ #category : 'running' }
BLSMMapElementTest >> setUp [

	super setUp.
	fake := BLSMFakeTileProvider new.
	element := BLSMMapElement on: (BLSMCoordinate lat: 0 lon: 0) zoom: 0.
	element
		synchronous: true;
		provider: fake.
	element extent: 512 @ 256.
	element forceLayout
]

{ #category : 'tests' }
BLSMMapElementTest >> testAttributionIsShown [

	| label |
	label := element childWithId: #attribution.
	self assert: (label text asString includesSubstring: 'OpenStreetMap contributors').
	self assert: element children last identicalTo: label
]

{ #category : 'tests' }
BLSMMapElementTest >> testChangingProviderReloadsTiles [

	| other |
	other := BLSMFakeTileProvider new.
	element provider: other.
	self assert: other requested size equals: 3
]

{ #category : 'tests' }
BLSMMapElementTest >> testConfigurationUpdatesAttributionAndMaxZoom [

	element transport: [ :request | BLSMHttpTileProviderTest new pngBytes ].
	element configuration: BLSMConfiguration openTopoMap.
	self assert: ((element childWithId: #attribution) text asString includesSubstring: 'OpenTopoMap').
	self assert: element map maxZoom equals: 17.
	self assert: (element tileElements values allSatisfy: [ :e | e background isKindOf: BlImageBackground ])
]

{ #category : 'tests' }
BLSMMapElementTest >> testHistoricalConfigurationUsesVectorProvider [

	self useHistoricalMap.
	self assert: (element vectorProvider isKindOf: BLSMVectorTileProvider).
	self assert: ((element childWithId: #attribution) text asString includesSubstring: 'OpenHistoricalMap').
	self assert: (element tileElements values allSatisfy: [ :e | e background isKindOf: BlImageBackground ])
]

{ #category : 'tests' }
BLSMMapElementTest >> testMapExtentFollowsElementSize [

	self assert: element map extent equals: 512 @ 256
]

{ #category : 'tests' }
BLSMMapElementTest >> testMarkerFollowsPan [

	| marker |
	marker := element addMarkerAt: (BLSMCoordinate lat: 0 lon: 0).
	element panBy: 10 @ 5.
	self assert: (marker constraints position + marker anchor - (266 @ 133)) r < 1e-6
]

{ #category : 'tests' }
BLSMMapElementTest >> testMarkerIsPlacedAtCoordinate [

	| marker |
	marker := element addMarkerAt: (BLSMCoordinate lat: 0 lon: 0).
	self assert: marker constraints position + marker anchor equals: 256 @ 128
]

{ #category : 'tests' }
BLSMMapElementTest >> testOneChildPerVisibleTile [

	self assert: element tileElements size equals: 3.
	self assert: fake requested size equals: 3
]

{ #category : 'tests' }
BLSMMapElementTest >> testPanMovesTiles [

	| before after |
	before := element tileElements values first constraints position x.
	element panBy: 10 @ 0.
	after := element tileElements values first constraints position x.
	self assert: (after - before - 10) abs < 1e-6
]

{ #category : 'tests' }
BLSMMapElementTest >> testRasterMapHasNoVectorProvider [

	self assert: element vectorProvider isNil
]

{ #category : 'tests' }
BLSMMapElementTest >> testTilesArePositioned [

	| positions |
	positions := (element tileElements values collect: [ :e | e constraints position x ]).
	self assertCollection: positions hasSameElements: #( -128 128 384 )
]

{ #category : 'tests' }
BLSMMapElementTest >> testTilesGetImageBackground [

	self assert: element tileElements isNotEmpty.
	element tileElements valuesDo: [ :e |
		self assert: (e background isKindOf: BlImageBackground) ]
]

{ #category : 'tests' }
BLSMMapElementTest >> testYearReloadsTiles [

	| before |
	self useHistoricalMap.
	before := element tileElements values asIdentitySet.
	element year: 1800.
	self assert: element year equals: 1800.
	self assert: element vectorProvider year equals: 1800.
	self assert: (element tileElements values noneSatisfy: [ :e | before includes: e ])
]

{ #category : 'tests' }
BLSMMapElementTest >> testZoomInRefreshesTiles [

	element zoomIn.
	self assert: element map zoom equals: 1.
	self assert: (element tileElements keys allSatisfy: [ :id | id zoom = 1 ])
]

{ #category : 'tests' }
BLSMMapElementTest >> useHistoricalMap [

	element transport: [ :request | BLSMVectorTileTest new parisFixture ].
	element configuration: BLSMConfiguration openHistoricalMap
]
