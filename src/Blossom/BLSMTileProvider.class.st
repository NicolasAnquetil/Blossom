"
I am the abstract source of tile images. Subclasses answer a Form for a BLSMTileId with #formFor:.
"
Class {
	#name : 'BLSMTileProvider',
	#superclass : 'Object',
	#category : 'Blossom-Network',
	#package : 'Blossom',
	#tag : 'Network'
}

{ #category : 'fetching' }
BLSMTileProvider >> formFor: aTileId [

	^ self subclassResponsibility
]
