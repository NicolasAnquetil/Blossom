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
		'attribution',
		'transport'
	],
	#category : 'Blossom-UI',
	#package : 'Blossom',
	#tag : 'UI'
}

{ #category : 'examples' }
BLSMMapElement class >> exampleHistoricalParis [
	"Paris in 1750 from OpenHistoricalMap. Try: map year: 1900, map year: 2020, map year: nil"

	<script>
	| map space |
	map := self on: (BLSMCoordinate lat: 48.8566 lon: 2.3522) zoom: 14.
	map configuration: BLSMConfiguration openHistoricalMap.
	map year: 1750.
	space := BlSpace new.
	space title: 'Blossom - OpenHistoricalMap'.
	space extent: 800 @ 600.
	space root addChild: map.
	space show.
	^ map
]

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

{ #category : 'examples' }
BLSMMapElement class >> exampleTopoMap [

	<script>
	| grenoble map space |
	grenoble := BLSMCoordinate lat: 45.1885 lon: 5.7245.
	map := self on: grenoble zoom: 12.
	map configuration: BLSMConfiguration openTopoMap.
	space := BlSpace new.
	space title: 'Blossom - OpenTopoMap'.
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

	| tileProvider |
	map maxZoom: aConfiguration maxZoom.
	attribution text: (aConfiguration attribution asRopedText fontSize: 10).
	tileProvider := aConfiguration newProvider.
	transport ifNotNil: [ tileProvider transport: transport ].
	self provider: (BLSMTileCache on: tileProvider)
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
		               text: (BLSMConfiguration default attribution asRopedText fontSize: 10);
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
	"Tiles are placed on whole pixels so that no hairline gaps show between them"

	| visible |
	visible := Dictionary new.
	map visibleTiles do: [ :each | visible at: each key put: each value ].
	(tileElements keys reject: [ :id | visible includesKey: id ]) do: [ :id | (tileElements removeKey: id) removeFromParent ].
	visible keysAndValuesDo: [ :id :offset |
		(tileElements at: id ifAbsentPut: [ self newTileElementFor: id ]) position: offset rounded ].
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

{ #category : 'accessing' }
BLSMMapElement >> transport: aBlock [
	"Download block given to the providers this element builds (see BLSMHttpTileProvider>>transport:). Used by tests to avoid the network."

	transport := aBlock
]

{ #category : 'accessing' }
BLSMMapElement >> vectorProvider [
	"The vector tile provider behind the cache, or nil for an image tile server"

	| p |
	p := self provider.
	(p isKindOf: BLSMTileCache) ifTrue: [ p := p provider ].
	^ (p isKindOf: BLSMVectorTileProvider)
		  ifTrue: [ p ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
BLSMMapElement >> year [

	^ self vectorProvider ifNotNil: [ :p | p year ]
]

{ #category : 'accessing' }
BLSMMapElement >> year: aNumberOrNil [
	"Show the map as it was at that year (vector tile servers such as OpenHistoricalMap only)"

	self vectorProvider ifNotNil: [ :p |
			p year: aNumberOrNil.
			self provider: (BLSMTileCache on: p) ]
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
