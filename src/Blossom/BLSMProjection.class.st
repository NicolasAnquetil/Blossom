"
I implement the Web Mercator (EPSG:3857) projection used by OpenStreetMap tiles: coordinates to global pixels and tile ids, and back.
"
Class {
	#name : 'BLSMProjection',
	#superclass : 'Object',
	#instVars : [
		'tileSize'
	],
	#category : 'Blossom-Core',
	#package : 'Blossom',
	#tag : 'Core'
}

{ #category : 'projecting' }
BLSMProjection >> coordinateForPixel: aPoint zoom: aZoom [

	| size lon n lat |
	size := self mapSizeAt: aZoom.
	lon := aPoint x / size * 360 - 180.
	n := Float pi * (1 - (2 * aPoint y / size)).
	lat := (n exp - n negated exp / 2) arcTan radiansToDegrees.
	^ BLSMCoordinate lat: lat lon: lon
]

{ #category : 'projecting' }
BLSMProjection >> mapSizeAt: aZoom [

	^ self tileSize * (2 raisedTo: aZoom)
]

{ #category : 'projecting' }
BLSMProjection >> northWestOf: aTileId [

	^ self coordinateForPixel: aTileId x @ aTileId y * self tileSize zoom: aTileId zoom
]

{ #category : 'projecting' }
BLSMProjection >> pixelFor: aCoordinate zoom: aZoom [
	"Global pixel position of aCoordinate in the world map at aZoom"

	| size latRad lat |
	size := self mapSizeAt: aZoom.
	lat := (aCoordinate latitude max: -85.05112878) min: 85.05112878.
	latRad := lat degreesToRadians.
	^ aCoordinate longitude + 180 / 360 * size @ (1 - ((latRad tan + (1 / latRad cos)) ln / Float pi) / 2 * size)
]

{ #category : 'projecting' }
BLSMProjection >> tileIdFor: aCoordinate zoom: aZoom [

	| p |
	p := (self pixelFor: aCoordinate zoom: aZoom) / self tileSize.
	^ BLSMTileId x: p x floor y: p y floor zoom: aZoom
]

{ #category : 'projecting' }
BLSMProjection >> tileSize [

	^ tileSize ifNil: [ 256 ]
]

{ #category : 'projecting' }
BLSMProjection >> tileSize: anInteger [

	tileSize := anInteger
]
