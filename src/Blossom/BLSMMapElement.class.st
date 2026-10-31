"
I display an OpenStreetMap map with Bloc. Drag to pan, mouse wheel to zoom.

Example:
  (BLSMMapElement on: (BLSMCoordinate lat: 48.8566 lon: 2.3522) zoom: 13) openInSpace.

Use #configuration: to change tile server / account, or #provider: to plug any BLSMTileProvider.
"
Class {
	#name : 'BLSMMapElement',
	#superclass : 'BlElement',
	#instVars : [
		'map',
		'provider',
		'tileElements',
		'synchronous',
		'lastDragPosition',
		'markers',
		'attribution'
	],
	#category : 'Blossom-UI',
	#package : 'Blossom',
	#tag : 'UI'
}

{ #category : 'examples' }
BLSMMapElement class >> exampleParisWithMarker [

	<script>
	| paris map space |
	paris := BLSMCoordinate lat: 48.8566 lon: 2.3522.
	map := self on: paris zoom: 13.
	map addMarkerAt: paris.
	space := BlSpace new.
	space title: 'Blossom - Paris'.
	space extent: 800 @ 600.
	space root addChild: map.
	space show.
	^ map
]

{ #category : 'instance creation' }
BLSMMapElement class >> on: aCoordinate [

	^ self on: aCoordinate zoom: 13
]

{ #category : 'instance creation' }
BLSMMapElement class >> on: aCoordinate zoom: aZoom [

	^ self new setMap: (BLSMMap center: aCoordinate zoom: aZoom)
]

{ #category : 'markers' }
BLSMMapElement >> addMarkerAt: aCoordinate [

	| marker |
	marker := BLSMMarkerElement new
		          coordinate: aCoordinate;
		          yourself.
	markers add: marker.
	self addChild: marker at: self children size.
	self placeMarker: marker.
	^ marker
]

{ #category : 'navigation' }
BLSMMapElement >> centerOn: aCoordinate [

	map center: aCoordinate.
	self refreshTiles
]

{ #category : 'accessing' }
BLSMMapElement >> configuration: aConfiguration [

	self provider: (BLSMTileCache on: (BLSMHttpTileProvider configuration: aConfiguration))
]

{ #category : 'private' }
BLSMMapElement >> extentChanged [

	map extent: self extent.
	self refreshTiles
]

{ #category : 'initialization' }
BLSMMapElement >> initialize [

	super initialize.
	tileElements := Dictionary new.
	markers := OrderedCollection new.
	synchronous := false.
	self clipChildren: true.
	self background: (Color r: 0.87 g: 0.87 b: 0.85).
	self constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	self initializeAttribution.
	self addEventHandlerOn: BlElementExtentChangedEvent do: [ :e | self extentChanged ].
	self initializeInteractions
]

{ #category : 'initialization' }
BLSMMapElement >> initializeAttribution [

	attribution := BlTextElement new
		               id: #attribution;
		               text: ('(c) OpenStreetMap contributors' asRopedText fontSize: 10);
		               padding: (BlInsets all: 3);
		               background: (Color white alpha: 0.7);
		               yourself.
	self addChild: attribution
]

{ #category : 'initialization' }
BLSMMapElement >> initializeInteractions [

	self addEventHandlerOn: BlDragStartEvent do: [ :e |
			e consumed: true.
			lastDragPosition := e position ].
	self addEventHandlerOn: BlDragEvent do: [ :e |
			lastDragPosition ifNotNil: [ self panBy: e position - lastDragPosition ].
			lastDragPosition := e position ].
	self addEventHandlerOn: BlDragEndEvent do: [ :e | lastDragPosition := nil ].
	self addEventHandlerOn: BlMouseWheelEvent do: [ :e |
			e isScrollUp ifTrue: [ self zoomIn ].
			e isScrollDown ifTrue: [ self zoomOut ] ]
]

{ #category : 'private' }
BLSMMapElement >> loadTile: aTileId into: aTileElement [

	synchronous ifTrue: [ ^ self setForm: (self provider formFor: aTileId) on: aTileElement ].
	[
		| form |
		form := [ self provider formFor: aTileId ]
			        on: Error
			        do: [ :ex | nil ].
		form ifNotNil: [ self enqueueTask: (BlTaskAction new action: [ self setForm: form on: aTileElement ]) ] ]
		forkAt: Processor userBackgroundPriority
		named: 'Blossom tile ' , aTileId printString
]

{ #category : 'accessing' }
BLSMMapElement >> map [

	^ map
]

{ #category : 'markers' }
BLSMMapElement >> markers [

	^ markers
]

{ #category : 'private' }
BLSMMapElement >> newTileElementFor: aTileId [

	| tile |
	tile := BlElement new
		        extent: map tileSize asPoint;
		        background: (Color r: 0.93 g: 0.93 b: 0.91);
		        yourself.
	self addChild: tile at: 1.
	self loadTile: aTileId into: tile.
	^ tile
]

{ #category : 'navigation' }
BLSMMapElement >> panBy: aDelta [

	map panBy: aDelta.
	self refreshTiles
]

{ #category : 'markers' }
BLSMMapElement >> placeMarker: aMarker [

	aMarker position: (map localPointOf: aMarker coordinate) - aMarker anchor
]

{ #category : 'markers' }
BLSMMapElement >> placeOverlays [

	markers do: [ :m | self placeMarker: m ].
	attribution position: self extent - attribution measuredExtent
]

{ #category : 'accessing' }
BLSMMapElement >> provider [

	^ provider ifNil: [ provider := BLSMTileCache on: BLSMHttpTileProvider default ]
]

{ #category : 'accessing' }
BLSMMapElement >> provider: aTileProvider [
	"Changing the source discards current tiles so they are reloaded from it"

	provider := aTileProvider.
	tileElements valuesDo: [ :e | e removeFromParent ].
	tileElements removeAll.
	self refreshTiles
]

{ #category : 'private' }
BLSMMapElement >> refreshTiles [

	| visible |
	visible := Dictionary new.
	map visibleTiles do: [ :each | visible at: each key put: each value ].
	tileElements keys
		reject: [ :id | visible includesKey: id ]
		thenDo: [ :id | (tileElements removeKey: id) removeFromParent ].
	visible keysAndValuesDo: [ :id :offset | (tileElements at: id ifAbsentPut: [ self newTileElementFor: id ]) position: offset ].
	self placeOverlays
]

{ #category : 'private' }
BLSMMapElement >> setForm: aForm on: aTileElement [

	aTileElement background: (BlImageBackground image: aForm)
]

{ #category : 'initialization' }
BLSMMapElement >> setMap: aMap [

	map := aMap
]

{ #category : 'accessing' }
BLSMMapElement >> synchronous: aBoolean [
	"When true, tiles are loaded in the UI process (used by tests)"

	synchronous := aBoolean
]

{ #category : 'accessing' }
BLSMMapElement >> tileElements [

	^ tileElements
]

{ #category : 'navigation' }
BLSMMapElement >> zoom: anInteger [

	map zoom: anInteger.
	self refreshTiles
]

{ #category : 'navigation' }
BLSMMapElement >> zoomIn [

	map zoomIn.
	self refreshTiles
]

{ #category : 'navigation' }
BLSMMapElement >> zoomOut [

	map zoomOut.
	self refreshTiles
]
