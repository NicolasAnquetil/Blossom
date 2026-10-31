"
I generate plain tiles locally without network access and remember which tiles were requested. Useful for tests and offline demos.
"
Class {
	#name : 'BLSMFakeTileProvider',
	#superclass : 'BLSMTileProvider',
	#instVars : [
		'requested'
	],
	#category : 'Blossom-Network',
	#package : 'Blossom',
	#tag : 'Network'
}

{ #category : 'fetching' }
BLSMFakeTileProvider >> formFor: aTileId [

	| form |
	self requested add: aTileId.
	form := Form extent: 256 @ 256 depth: 32.
	form fillColor: (Color h: aTileId x * 47 + (aTileId y * 91) \\ 360 s: 0.3 v: 0.95).
	^ form
]

{ #category : 'fetching' }
BLSMFakeTileProvider >> requested [

	^ requested ifNil: [ requested := OrderedCollection new ]
]
