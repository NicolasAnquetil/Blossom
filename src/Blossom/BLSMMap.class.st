"
I am the model of a map viewport: a center coordinate, a zoom level and a pixel extent. I compute which tiles are visible and where (in local pixels) they must be drawn, and support panning and zooming.
"
Class {
	#name : 'BLSMMap',
	#superclass : 'Object',
	#instVars : [
		'center',
		'zoom',
		'extent',
		'projection',
		'maxZoom'
	],
	#category : 'Blossom-Core',
	#package : 'Blossom',
	#tag : 'Core'
}

{ #category : 'instance creation' }
BLSMMap class >> center: aCoordinate zoom: aZoom [

	^ self new
		  center: aCoordinate;
		  zoom: aZoom;
		  yourself
]

{ #category : 'accessing' }
BLSMMap >> center [

	^ center
]

{ #category : 'accessing' }
BLSMMap >> center: aCoordinate [

	center := aCoordinate
]

{ #category : 'geometry' }
BLSMMap >> centerPixel [

	^ self projection pixelFor: center zoom: zoom
]

{ #category : 'geometry' }
BLSMMap >> coordinateAt: aLocalPoint [

	^ self coordinateForGlobalPixel: self topLeftPixel + aLocalPoint
]

{ #category : 'geometry' }
BLSMMap >> coordinateForGlobalPixel: aPoint [

	| size p |
	size := self projection mapSizeAt: zoom.
	p := aPoint x \\ size @ ((aPoint y max: 0) min: size).
	^ self projection coordinateForPixel: p zoom: zoom
]

{ #category : 'accessing' }
BLSMMap >> extent [

	^ extent ifNil: [ 256 @ 256 ]
]

{ #category : 'accessing' }
BLSMMap >> extent: aPoint [

	extent := aPoint
]

{ #category : 'geometry' }
BLSMMap >> localPointOf: aCoordinate [

	^ (self projection pixelFor: aCoordinate zoom: zoom) - self topLeftPixel
]

{ #category : 'accessing' }
BLSMMap >> maxZoom [

	^ maxZoom ifNil: [ 19 ]
]

{ #category : 'accessing' }
BLSMMap >> maxZoom: anInteger [

	maxZoom := anInteger.
	zoom ifNotNil: [ self zoom: zoom ]
]

{ #category : 'accessing' }
BLSMMap >> minZoom [

	^ 0
]

{ #category : 'navigation' }
BLSMMap >> panBy: aDelta [
	"Dragging the content by aDelta pixels moves the center the opposite way"

	center := self coordinateForGlobalPixel: self centerPixel - aDelta
]

{ #category : 'accessing' }
BLSMMap >> projection [

	^ projection ifNil: [ projection := BLSMProjection new ]
]

{ #category : 'accessing' }
BLSMMap >> tileSize [

	^ self projection tileSize
]

{ #category : 'geometry' }
BLSMMap >> topLeftPixel [
	"Global pixel shown at the top-left corner of the viewport"

	^ self centerPixel - (self extent / 2)
]

{ #category : 'geometry' }
BLSMMap >> visibleTiles [
	"Answer associations tileId -> local offset (top-left of the tile in viewport pixels)"

	| ts topLeft first last result |
	ts := self tileSize.
	topLeft := self topLeftPixel.
	first := (topLeft / ts) floor.
	last := (topLeft + self extent / ts) ceiling - 1.
	result := OrderedCollection new.
	first y to: last y do: [ :ty |
			first x to: last x do: [ :tx |
					| id |
					id := BLSMTileId x: tx y: ty zoom: zoom.
					id isValid ifTrue: [ result add: id -> (tx @ ty * ts - topLeft) ] ] ].
	^ result
]

{ #category : 'accessing' }
BLSMMap >> zoom [

	^ zoom
]

{ #category : 'accessing' }
BLSMMap >> zoom: anInteger [

	zoom := (anInteger max: self minZoom) min: self maxZoom
]

{ #category : 'navigation' }
BLSMMap >> zoomBy: aDelta around: aLocalPoint [
	"Change the zoom by aDelta levels, keeping the coordinate under aLocalPoint at the same place in the viewport"

	| anchor oldZoom newCenterPixel |
	anchor := self coordinateAt: aLocalPoint.
	oldZoom := zoom.
	self zoom: zoom + aDelta.
	zoom = oldZoom ifTrue: [ ^ self ].
	newCenterPixel := (self projection pixelFor: anchor zoom: zoom) - aLocalPoint + (self extent / 2).
	center := self coordinateForGlobalPixel: newCenterPixel
]

{ #category : 'navigation' }
BLSMMap >> zoomIn [

	self zoom: zoom + 1
]

{ #category : 'navigation' }
BLSMMap >> zoomInAround: aLocalPoint [

	self zoomBy: 1 around: aLocalPoint
]

{ #category : 'navigation' }
BLSMMap >> zoomOut [

	self zoom: zoom - 1
]

{ #category : 'navigation' }
BLSMMap >> zoomOutAround: aLocalPoint [

	self zoomBy: -1 around: aLocalPoint
]
