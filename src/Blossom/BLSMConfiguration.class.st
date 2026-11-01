"
I describe how to reach a tile server: URL template with {z} {x} {y} placeholders, the User-Agent required by the OSM tile usage policy, and optional account credentials (apiKey appended as ?apikey=, accessToken sent as a Bearer Authorization header).

Example:
  BLSMConfiguration default.
  (BLSMConfiguration urlTemplate: 'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png') apiKey: 'xxx'; yourself
"
Class {
	#name : 'BLSMConfiguration',
	#superclass : 'Object',
	#instVars : [
		'urlTemplate',
		'userAgent',
		'apiKey',
		'accessToken',
		'subdomains',
		'attribution',
		'maxZoom',
		'isVector'
	],
	#category : 'Blossom-Core',
	#package : 'Blossom',
	#tag : 'Core'
}

{ #category : 'presets' }
BLSMConfiguration class >> cyclOSM [

	^ (self urlTemplate: 'https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png')
		  attribution: '© OpenStreetMap contributors, CyclOSM';
		  yourself
]

{ #category : 'presets' }
BLSMConfiguration class >> default [

	^ self openStreetMap
]

{ #category : 'presets' }
BLSMConfiguration class >> humanitarian [

	^ (self urlTemplate: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png')
		  attribution: '© OpenStreetMap contributors, tiles HOT / OSM France';
		  yourself
]

{ #category : 'presets' }
BLSMConfiguration class >> openHistoricalMap [
	"Vector tiles: drawn locally by BLSMVectorTileProvider, filtered by year"

	^ (self urlTemplate: 'https://vtiles.openhistoricalmap.org/maps/osm/{z}/{x}/{y}.pbf')
		  attribution: '© OpenHistoricalMap contributors';
		  beVector;
		  yourself
]

{ #category : 'presets' }
BLSMConfiguration class >> openStreetMap [

	^ self urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
]

{ #category : 'presets' }
BLSMConfiguration class >> openTopoMap [

	^ (self urlTemplate: 'https://tile.opentopomap.org/{z}/{x}/{y}.png')
		  attribution: '© OpenStreetMap contributors, SRTM | style © OpenTopoMap (CC-BY-SA)';
		  maxZoom: 17;
		  yourself
]

{ #category : 'presets' }
BLSMConfiguration class >> presets [
	"Answer the ready-made configurations by display name"

	^ OrderedDictionary new
		  at: 'OpenStreetMap' put: self openStreetMap;
		  at: 'Humanitarian' put: self humanitarian;
		  at: 'OpenTopoMap' put: self openTopoMap;
		  at: 'CyclOSM' put: self cyclOSM;
		  at: 'OpenHistoricalMap' put: self openHistoricalMap;
		  yourself
]

{ #category : 'instance creation' }
BLSMConfiguration class >> urlTemplate: aString [

	^ self new
		  urlTemplate: aString;
		  yourself
]

{ #category : 'accessing' }
BLSMConfiguration >> accessToken [

	^ accessToken
]

{ #category : 'accessing' }
BLSMConfiguration >> accessToken: aString [

	accessToken := aString
]

{ #category : 'accessing' }
BLSMConfiguration >> apiKey [

	^ apiKey
]

{ #category : 'accessing' }
BLSMConfiguration >> apiKey: aString [

	apiKey := aString
]

{ #category : 'accessing' }
BLSMConfiguration >> attribution [

	^ attribution ifNil: [ '© OpenStreetMap contributors' ]
]

{ #category : 'accessing' }
BLSMConfiguration >> attribution: aString [

	attribution := aString
]

{ #category : 'accessing' }
BLSMConfiguration >> beVector [

	isVector := true
]

{ #category : 'requests' }
BLSMConfiguration >> headers [

	| headers |
	headers := Dictionary new.
	headers at: 'User-Agent' put: self userAgent.
	accessToken ifNotNil: [ headers at: 'Authorization' put: 'Bearer ' , accessToken ].
	^ headers
]

{ #category : 'accessing' }
BLSMConfiguration >> isVector [
	"True when the server sends Mapbox Vector Tiles instead of images"

	^ isVector ifNil: [ false ]
]

{ #category : 'accessing' }
BLSMConfiguration >> maxZoom [

	^ maxZoom ifNil: [ 19 ]
]

{ #category : 'accessing' }
BLSMConfiguration >> maxZoom: anInteger [

	maxZoom := anInteger
]

{ #category : 'accessing' }
BLSMConfiguration >> newProvider [

	^ self isVector
		  ifTrue: [ BLSMVectorTileProvider configuration: self ]
		  ifFalse: [ BLSMHttpTileProvider configuration: self ]
]

{ #category : 'requests' }
BLSMConfiguration >> subdomainFor: aTileId [
	"Stable choice per tile, spreading requests over the servers"

	^ self subdomains at: aTileId x + aTileId y \\ self subdomains size + 1
]

{ #category : 'accessing' }
BLSMConfiguration >> subdomains [

	^ subdomains ifNil: [ #( 'a' 'b' 'c' ) ]
]

{ #category : 'accessing' }
BLSMConfiguration >> subdomains: anArray [

	subdomains := anArray
]

{ #category : 'requests' }
BLSMConfiguration >> urlFor: aTileId [

	| tile url |
	tile := aTileId wrapped.
	url := urlTemplate copyReplaceAll: '{s}' with: (self subdomainFor: tile).
	url := url copyReplaceAll: '{z}' with: tile zoom printString.
	url := url copyReplaceAll: '{x}' with: tile x printString.
	url := url copyReplaceAll: '{y}' with: tile y printString.
	url := url asZnUrl.
	apiKey ifNotNil: [ url := url withQuery: 'apikey' -> apiKey ].
	^ url
]

{ #category : 'accessing' }
BLSMConfiguration >> urlTemplate [

	^ urlTemplate
]

{ #category : 'accessing' }
BLSMConfiguration >> urlTemplate: aString [

	urlTemplate := aString
]

{ #category : 'accessing' }
BLSMConfiguration >> userAgent [

	^ userAgent ifNil: [ 'Blossom/0.1 (Pharo OpenStreetMap viewer)' ]
]

{ #category : 'accessing' }
BLSMConfiguration >> userAgent: aString [

	userAgent := aString
]
