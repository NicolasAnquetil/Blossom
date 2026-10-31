"
I am a feature of a vector tile layer. type is 1 point, 2 line, 3 polygon. geometry is an Array of parts (points, line strings or polygon rings), each an Array of Points in tile units.
"
Class {
	#name : 'BLSMVectorFeature',
	#superclass : 'Object',
	#instVars : [
		'id',
		'type',
		'attributes',
		'geometry'
	],
	#category : 'Blossom-VectorTiles',
	#package : 'Blossom',
	#tag : 'VectorTiles'
}

{ #category : 'instance creation' }
BLSMVectorFeature class >> decodeGeometry: commands [
	"MVT commands: id 1 MoveTo, 2 LineTo, 7 ClosePath; count in the upper bits; zigzag deltas from a cursor"

	| parts current cursor i |
	parts := OrderedCollection new.
	cursor := 0 @ 0.
	i := 1.
	[ i <= commands size ] whileTrue: [
			| command id count |
			command := commands at: i.
			i := i + 1.
			id := command bitAnd: 7.
			count := command bitShift: -3.
			id = 7 ifFalse: [
					count timesRepeat: [
							cursor := cursor + ((BLSMProtobufReader zigZag: (commands at: i)) @ (BLSMProtobufReader zigZag: (commands at: i + 1))).
							i := i + 2.
							id = 1 ifTrue: [
									current := OrderedCollection new.
									parts add: current ].
							current add: cursor ] ] ].
	^ parts collect: [ :each | each asArray ] as: Array
]

{ #category : 'instance creation' }
BLSMVectorFeature class >> fromBytes: aByteArray keys: keys values: values [

	^ self new decode: aByteArray keys: keys values: values
]

{ #category : 'instance creation' }
BLSMVectorFeature class >> type: anInteger attributes: aDictionary geometry: parts [

	^ self new setType: anInteger attributes: aDictionary geometry: parts
]

{ #category : 'accessing' }
BLSMVectorFeature >> at: aKey [

	^ attributes at: aKey ifAbsent: [ nil ]
]

{ #category : 'accessing' }
BLSMVectorFeature >> attributes [

	^ attributes
]

{ #category : 'accessing' }
BLSMVectorFeature >> decode: aByteArray keys: keys values: values [

	attributes := Dictionary new.
	geometry := #(  ).
	(BLSMProtobufReader on: aByteArray) fieldsDo: [ :field :wire :value |
			field = 1 ifTrue: [ id := value ].
			field = 2 ifTrue: [
				(BLSMProtobufReader packedVarints: value) pairsDo: [ :k :v | attributes at: (keys at: k + 1) put: (values at: v + 1) ] ].
			field = 3 ifTrue: [ type := value ].
			field = 4 ifTrue: [ geometry := self class decodeGeometry: (BLSMProtobufReader packedVarints: value) ] ]
]

{ #category : 'accessing' }
BLSMVectorFeature >> geometry [

	^ geometry
]

{ #category : 'accessing' }
BLSMVectorFeature >> id [

	^ id
]

{ #category : 'accessing' }
BLSMVectorFeature >> isLine [

	^ type = 2
]

{ #category : 'testing' }
BLSMVectorFeature >> isPoint [

	^ type = 1
]

{ #category : 'accessing' }
BLSMVectorFeature >> isPolygon [

	^ type = 3
]

{ #category : 'accessing' }
BLSMVectorFeature >> setType: anInteger attributes: aDictionary geometry: parts [

	type := anInteger.
	attributes := aDictionary.
	geometry := parts
]

{ #category : 'accessing' }
BLSMVectorFeature >> type [

	^ type
]
