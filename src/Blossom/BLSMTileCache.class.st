"
I wrap another tile provider and keep the most recently used tiles in memory (LRU, bounded by maxSize).
"
Class {
	#name : 'BLSMTileCache',
	#superclass : 'BLSMTileProvider',
	#instVars : [
		'provider',
		'maxSize',
		'tiles',
		'mutex'
	],
	#category : 'Blossom-Network',
	#package : 'Blossom',
	#tag : 'Network'
}

{ #category : 'instance creation' }
BLSMTileCache class >> on: aProvider [

	^ self new setProvider: aProvider
]

{ #category : 'fetching' }
BLSMTileCache >> formFor: aTileId [

	| form |
	(mutex critical: [ tiles removeKey: aTileId ifAbsent: [ nil ] ]) ifNotNil: [ :cached |
			mutex critical: [ tiles at: aTileId put: cached ].
			^ cached ].
	form := provider formFor: aTileId.
	mutex critical: [
			tiles at: aTileId put: form.
			[ tiles size > maxSize ] whileTrue: [ tiles removeKey: tiles keys first ] ].
	^ form
]

{ #category : 'accessing' }
BLSMTileCache >> includes: aTileId [

	^ mutex critical: [ tiles includesKey: aTileId ]
]

{ #category : 'accessing' }
BLSMTileCache >> maxSize: anInteger [

	maxSize := anInteger
]

{ #category : 'accessing' }
BLSMTileCache >> provider [

	^ provider
]

{ #category : 'accessing' }
BLSMTileCache >> setProvider: aProvider [

	provider := aProvider.
	maxSize := 256.
	tiles := OrderedDictionary new.
	mutex := Mutex new
]

{ #category : 'accessing' }
BLSMTileCache >> size [

	^ tiles size
]
