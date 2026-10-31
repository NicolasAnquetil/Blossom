"
I identify a slippy-map tile by its x, y and zoom level.
"
Class {
	#name : 'BLSMTileId',
	#superclass : 'Object',
	#instVars : [
		'x',
		'y',
		'zoom'
	],
	#category : 'Blossom-Core',
	#package : 'Blossom',
	#tag : 'Core'
}

{ #category : 'instance creation' }
BLSMTileId class >> x: anX y: anY zoom: aZoom [

	^ self new setX: anX y: anY zoom: aZoom
]

{ #category : 'comparing' }
BLSMTileId >> = other [

	^ self class = other class and: [ x = other x and: [ y = other y and: [ zoom = other zoom ] ] ]
]

{ #category : 'comparing' }
BLSMTileId >> hash [

	^ (x hash bitXor: y hash * 31) bitXor: zoom hash * 961
]

{ #category : 'accessing' }
BLSMTileId >> isValid [

	^ y between: 0 and: self tilesPerSide - 1
]

{ #category : 'printing' }
BLSMTileId >> printOn: aStream [

	aStream
		nextPutAll: 'BLSMTileId ';
		print: zoom;
		nextPut: $/;
		print: x;
		nextPut: $/;
		print: y
]

{ #category : 'accessing' }
BLSMTileId >> setX: anX y: anY zoom: aZoom [

	x := anX.
	y := anY.
	zoom := aZoom
]

{ #category : 'accessing' }
BLSMTileId >> tilesPerSide [

	^ 2 raisedTo: zoom
]

{ #category : 'accessing' }
BLSMTileId >> wrapped [
	"Answer the equivalent tile with x wrapped around the antimeridian"

	^ self class x: x \\ self tilesPerSide y: y zoom: zoom
]

{ #category : 'accessing' }
BLSMTileId >> x [

	^ x
]

{ #category : 'accessing' }
BLSMTileId >> y [

	^ y
]

{ #category : 'accessing' }
BLSMTileId >> zoom [

	^ zoom
]
