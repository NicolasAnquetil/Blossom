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
		'accessToken'
	],
	#category : 'Blossom-Network',
	#package : 'Blossom',
	#tag : 'Network'
}

{ #category : 'instance creation' }
BLSMConfiguration class >> default [

	^ self urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
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

{ #category : 'requests' }
BLSMConfiguration >> headers [

	| headers |
	headers := Dictionary new.
	headers at: 'User-Agent' put: self userAgent.
	accessToken ifNotNil: [ headers at: 'Authorization' put: 'Bearer ' , accessToken ].
	^ headers
]

{ #category : 'requests' }
BLSMConfiguration >> urlFor: aTileId [

	| tile url |
	tile := aTileId wrapped.
	url := (urlTemplate copyReplaceAll: '{z}' with: tile zoom printString) copyReplaceAll: '{x}' with: tile x printString.
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
