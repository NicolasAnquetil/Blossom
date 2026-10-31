"
I download Mapbox Vector Tiles (e.g. from OpenHistoricalMap), decode them and draw them into Forms with a BLSMVectorRenderer. Set #year: to only show what existed at that year (nil shows everything), and #style: to change the look.
"
Class {
	#name : 'BLSMVectorTileProvider',
	#superclass : 'BLSMHttpTileProvider',
	#instVars : [
		'renderer',
		'decodedTiles',
		'mutex'
	],
	#category : 'Blossom-VectorTiles',
	#package : 'Blossom',
	#tag : 'VectorTiles'
}

{ #category : 'fetching' }
BLSMVectorTileProvider >> formFor: aTileId [

	^ self renderer render: (self vectorTileFor: aTileId)
]

{ #category : 'accessing' }
BLSMVectorTileProvider >> renderer [

	^ renderer ifNil: [ renderer := BLSMVectorRenderer new ]
]

{ #category : 'accessing' }
BLSMVectorTileProvider >> style: aVectorStyle [

	self renderer style: aVectorStyle
]

{ #category : 'accessing' }
BLSMVectorTileProvider >> vectorTileFor: aTileId [
	"Decoded tiles are kept so that changing the year only redraws. Safe for the parallel tile loading processes."

	| tile |
	mutex ifNil: [ mutex := Mutex new ].
	mutex critical: [
			decodedTiles ifNil: [ decodedTiles := OrderedDictionary new ].
			decodedTiles at: aTileId ifPresent: [ :cached | ^ cached ] ].
	tile := BLSMVectorTile fromBytes: (self fetchBytes: aTileId).
	mutex critical: [
			decodedTiles at: aTileId put: tile.
			[ decodedTiles size > 64 ] whileTrue: [ decodedTiles removeKey: decodedTiles keys first ] ].
	^ tile
]

{ #category : 'accessing' }
BLSMVectorTileProvider >> year [

	^ self renderer filter year
]

{ #category : 'accessing' }
BLSMVectorTileProvider >> year: aNumberOrNil [

	self renderer filter: (BLSMDateFilter year: aNumberOrNil)
]
