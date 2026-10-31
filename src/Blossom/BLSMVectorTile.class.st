"
I am a decoded Mapbox Vector Tile (MVT 2.x): an ordered collection of BLSMVectorLayer.

  BLSMVectorTile fromBytes: aByteArray
"
Class {
	#name : 'BLSMVectorTile',
	#superclass : 'Object',
	#instVars : [
		'layers'
	],
	#category : 'Blossom-VectorTiles',
	#package : 'Blossom',
	#tag : 'VectorTiles'
}

{ #category : 'instance creation' }
BLSMVectorTile class >> fromBytes: aByteArray [

	| layers |
	layers := OrderedCollection new.
	(BLSMProtobufReader on: aByteArray) fieldsDo: [ :field :wire :value |
		field = 3 ifTrue: [ layers add: (BLSMVectorLayer fromBytes: value) ] ].
	^ self new setLayers: layers
]

{ #category : 'instance creation' }
BLSMVectorTile class >> layers: aCollection [

	^ self new setLayers: aCollection
]

{ #category : 'accessing' }
BLSMVectorTile >> layerNamed: aString [

	^ layers detect: [ :each | each name = aString ] ifNone: [ nil ]
]

{ #category : 'accessing' }
BLSMVectorTile >> layerNames [

	^ layers collect: [ :each | each name ]
]

{ #category : 'accessing' }
BLSMVectorTile >> layers [

	^ layers
]

{ #category : 'accessing' }
BLSMVectorTile >> setLayers: aCollection [

	layers := aCollection
]
