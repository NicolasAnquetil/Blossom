"
I download tiles over HTTP according to a BLSMConfiguration. My transport is a block taking a ZnRequest and answering the response bytes; it defaults to ZnClient and can be replaced in tests.
"
Class {
	#name : 'BLSMHttpTileProvider',
	#superclass : 'BLSMTileProvider',
	#instVars : [
		'configuration',
		'transport'
	],
	#category : 'Blossom-Network',
	#package : 'Blossom',
	#tag : 'Network'
}

{ #category : 'instance creation' }
BLSMHttpTileProvider class >> configuration: aConfiguration [

	^ self new
		  configuration: aConfiguration;
		  yourself
]

{ #category : 'instance creation' }
BLSMHttpTileProvider class >> default [

	^ self configuration: BLSMConfiguration default
]

{ #category : 'accessing' }
BLSMHttpTileProvider >> configuration [

	^ configuration
]

{ #category : 'accessing' }
BLSMHttpTileProvider >> configuration: aConfiguration [

	configuration := aConfiguration
]

{ #category : 'accessing' }
BLSMHttpTileProvider >> fetchBytes: aTileId [

	| result |
	result := self transport value: (self requestFor: aTileId).
	(result isKindOf: ZnResponse) ifFalse: [ ^ result ].
	result isSuccess ifFalse: [ ^ self error: 'Tile download failed: ' , result statusLine printString ].
	^ result contents
]

{ #category : 'fetching' }
BLSMHttpTileProvider >> formFor: aTileId [

	^ ImageReadWriter formFromStream: (self fetchBytes: aTileId) readStream
]

{ #category : 'accessing' }
BLSMHttpTileProvider >> requestFor: aTileId [

	| request |
	request := ZnRequest get: (configuration urlFor: aTileId).
	configuration headers keysAndValuesDo: [ :k :v | request headers at: k put: v ].
	^ request
]

{ #category : 'accessing' }
BLSMHttpTileProvider >> transport [

	^ transport ifNil: [
			  [ :request |
				  ZnClient new
					  request: request;
					  execute;
					  response ] ]
]

{ #category : 'accessing' }
BLSMHttpTileProvider >> transport: aBlock [

	transport := aBlock
]
