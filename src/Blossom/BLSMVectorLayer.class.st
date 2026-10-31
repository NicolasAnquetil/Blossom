"
I am one layer of a vector tile. Feature coordinates are in tile units from 0 to my extent (usually 4096); features may extend a little outside (buffer).
"
Class {
	#name : 'BLSMVectorLayer',
	#superclass : 'Object',
	#instVars : [
		'name',
		'extent',
		'features'
	],
	#category : 'Blossom-VectorTiles',
	#package : 'Blossom',
	#tag : 'VectorTiles'
}

{ #category : 'instance creation' }
BLSMVectorLayer class >> decodeValue: aByteArray [
	"MVT Value message: 1 string, 2 float, 3 double, 4 int64, 5 uint64, 6 sint64, 7 bool"

	(BLSMProtobufReader on: aByteArray) fieldsDo: [ :field :wire :value |
			field = 1 ifTrue: [ ^ value utf8Decoded ].
			field = 2 ifTrue: [ ^ BLSMProtobufReader float: value ].
			field = 3 ifTrue: [ ^ BLSMProtobufReader double: value ].
			field = 4 ifTrue: [
					^ value >= (1 bitShift: 63)
						  ifTrue: [ value - (1 bitShift: 64) ]
						  ifFalse: [ value ] ].
			field = 5 ifTrue: [ ^ value ].
			field = 6 ifTrue: [ ^ BLSMProtobufReader zigZag: value ].
			field = 7 ifTrue: [ ^ value ~= 0 ] ].
	^ nil
]

{ #category : 'instance creation' }
BLSMVectorLayer class >> fromBytes: aByteArray [

	^ self new decode: aByteArray
]

{ #category : 'instance creation' }
BLSMVectorLayer class >> name: aString extent: anInteger features: aCollection [

	^ self new setName: aString extent: anInteger features: aCollection
]

{ #category : 'accessing' }
BLSMVectorLayer >> decode: aByteArray [

	| keys values rawFeatures |
	extent := 4096.
	keys := OrderedCollection new.
	values := OrderedCollection new.
	rawFeatures := OrderedCollection new.
	(BLSMProtobufReader on: aByteArray) fieldsDo: [ :field :wire :value |
			field = 1 ifTrue: [ name := value utf8Decoded ].
			field = 2 ifTrue: [ rawFeatures add: value ].
			field = 3 ifTrue: [ keys add: value utf8Decoded ].
			field = 4 ifTrue: [ values add: (self class decodeValue: value) ].
			field = 5 ifTrue: [ extent := value ] ].
	features := rawFeatures collect: [ :each | BLSMVectorFeature fromBytes: each keys: keys values: values ] as: Array
]

{ #category : 'accessing' }
BLSMVectorLayer >> extent [

	^ extent
]

{ #category : 'accessing' }
BLSMVectorLayer >> features [

	^ features
]

{ #category : 'accessing' }
BLSMVectorLayer >> name [

	^ name
]

{ #category : 'printing' }
BLSMVectorLayer >> printOn: aStream [

	aStream
		nextPutAll: 'BLSMVectorLayer ';
		nextPutAll: name;
		nextPutAll: ' (';
		print: features size;
		nextPutAll: ' features)'
]

{ #category : 'accessing' }
BLSMVectorLayer >> setName: aString extent: anInteger features: aCollection [

	name := aString.
	extent := anInteger.
	features := aCollection asArray
]
