Class {
	#name : 'BLSMVectorTileTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-VectorTiles',
	#package : 'Blossom-Tests',
	#tag : 'VectorTiles'
}

{ #category : 'tests' }
BLSMVectorTileTest >> feature: type tags: tags geometry: commands [

	^ ByteArray new: 64 streamContents: [ :s |
			  self field: 1 varint: 7 on: s.
			  self field: 2 bytes: (self packed: tags) on: s.
			  self field: 3 varint: type on: s.
			  self field: 4 bytes: (self packed: commands) on: s ]
]

{ #category : 'tests' }
BLSMVectorTileTest >> field: aNumber bytes: aByteArray on: aStream [

	self varint: (aNumber bitShift: 3) + 2 on: aStream.
	self varint: aByteArray size on: aStream.
	aStream nextPutAll: aByteArray
]

{ #category : 'tests' }
BLSMVectorTileTest >> field: aNumber varint: anInteger on: aStream [

	self varint: (aNumber bitShift: 3) on: aStream.
	self varint: anInteger on: aStream
]

{ #category : 'tests' }
BLSMVectorTileTest >> handBuiltTile [
	"One layer 'test' with a line (10,20)->(15,20)->(15,25) and a closed triangle, keys #(kind), values #('river')"

	| layer |
	layer := ByteArray new: 128 streamContents: [ :s |
			         self field: 15 varint: 2 on: s.
			         self field: 1 bytes: 'test' asByteArray on: s.
			         self field: 2 bytes: (self feature: 2 tags: #( 0 0 ) geometry: #( 9 20 40 18 10 0 0 10 )) on: s.
			         self field: 2 bytes: (self feature: 3 tags: #(  ) geometry: #( 9 0 0 18 20 0 0 20 15 )) on: s.
			         self field: 3 bytes: 'kind' asByteArray on: s.
			         self field: 4 bytes: (ByteArray new: 8 streamContents: [ :v | self field: 1 bytes: 'river' asByteArray on: v ]) on: s.
			         self field: 5 varint: 4096 on: s ].
	^ ByteArray new: 128 streamContents: [ :s | self field: 3 bytes: layer on: s ]
]

{ #category : 'tests' }
BLSMVectorTileTest >> packed: integers [

	^ ByteArray new: 32 streamContents: [ :s | integers do: [ :i | self varint: i on: s ] ]
]

{ #category : 'tests' }
BLSMVectorTileTest >> parisFixture [

	^ self parisFixtureBase64 base64Decoded
]

{ #category : 'fixtures' }
BLSMVectorTileTest >> parisFixtureBase64 [
	"OpenHistoricalMap tile 13/4149/2818 (Paris), trimmed to 2 features per layer and without name_* translations. Data (c) OpenHistoricalMap contributors, CC0."
	^ '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'
]

{ #category : 'tests' }
BLSMVectorTileTest >> testHandBuiltLayer [

	| tile layer |
	tile := BLSMVectorTile fromBytes: self handBuiltTile.
	self assert: tile layerNames asArray equals: #( 'test' ).
	layer := tile layerNamed: 'test'.
	self assert: layer extent equals: 4096.
	self assert: layer features size equals: 2
]

{ #category : 'tests' }
BLSMVectorTileTest >> testLineFeature [

	| line |
	line := ((BLSMVectorTile fromBytes: self handBuiltTile) layerNamed: 'test') features first.
	self assert: line id equals: 7.
	self assert: line isLine.
	self assert: (line at: 'kind') equals: 'river'.
	self assert: line geometry equals: { {
			(10 @ 20).
			(15 @ 20).
			(15 @ 25) } }
]

{ #category : 'tests' }
BLSMVectorTileTest >> testPolygonFeature [

	| polygon |
	polygon := ((BLSMVectorTile fromBytes: self handBuiltTile) layerNamed: 'test') features second.
	self assert: polygon isPolygon.
	self assert: polygon attributes isEmpty.
	self assert: polygon geometry equals: { {
			(0 @ 0).
			(10 @ 0).
			(10 @ 10) } }
]

{ #category : 'tests' }
BLSMVectorTileTest >> testRealTileLayers [

	| tile |
	tile := BLSMVectorTile fromBytes: self parisFixture.
	self assert: tile layerNames size equals: 15.
	self assert: (tile layerNames includes: 'transport_lines').
	self assert: (tile layerNamed: 'transport_lines') features size equals: 2
]

{ #category : 'tests' }
BLSMVectorTileTest >> testRealTileLineFeatureDates [

	| tile road |
	tile := BLSMVectorTile fromBytes: self parisFixture.
	road := (tile layerNamed: 'transport_lines') features first.
	self assert: (road at: 'name') equals: 'Rue de Grenelle'.
	self assert: ((road at: 'start_decdate') - 1529.00137) abs < 1e-3.
	self assert: (road at: 'end_decdate') isNil
]

{ #category : 'tests' }
BLSMVectorTileTest >> testRealTilePointFeature [

	| tile place |
	tile := BLSMVectorTile fromBytes: self parisFixture.
	place := (tile layerNamed: 'place_points_centroids') features first.
	self assert: place isPoint.
	self assert: (place at: 'name') equals: 'Place du Louvre'.
	self assert: place geometry equals: { { (1088 @ 642) } }
]

{ #category : 'tests' }
BLSMVectorTileTest >> varint: anInteger on: aStream [

	| n |
	n := anInteger.
	[ n >= 16r80 ] whileTrue: [
			aStream nextPut: (n bitAnd: 16r7F) + 16r80.
			n := n bitShift: -7 ].
	aStream nextPut: n
]
