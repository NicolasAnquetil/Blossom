Class {
	#name : 'BLSMProtobufReaderTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-VectorTiles',
	#package : 'Blossom-Tests',
	#tag : 'VectorTiles'
}

{ #category : 'tests' }
BLSMProtobufReaderTest >> fieldsOf: aByteArray [

	| result |
	result := OrderedCollection new.
	(BLSMProtobufReader on: aByteArray) fieldsDo: [ :f :w :v |
			result add: {
					f.
					w.
					v } ].
	^ result asArray
]

{ #category : 'tests' }
BLSMProtobufReaderTest >> testFixed32 [

	self
		assert: (self fieldsOf: #[ 16r25 1 2 3 4 ])
		equals: { { 4 . 5 . #[1 2 3 4] } }
]

{ #category : 'tests' }
BLSMProtobufReaderTest >> testFloatAndDouble [

	self assert: (BLSMProtobufReader float: #[ 0 0 16r80 16r3F ]) equals: 1.0.
	self assert: (BLSMProtobufReader double: #[ 0 0 0 0 0 0 16rF8 16r3F ]) equals: 1.5
]

{ #category : 'tests' }
BLSMProtobufReaderTest >> testLengthDelimited [

	self
		assert: (self fieldsOf: #[ 16r1A 3 97 98 99 ])
		equals: { { 3 . 2 . #[97 98 99] } }
]

{ #category : 'tests' }
BLSMProtobufReaderTest >> testMultiByteVarint [
	"300 = 0xAC 0x02"

	self assert: (self fieldsOf: #[ 16 16rAC 16r02 ]) equals: { { 2. 0. 300 } }
]

{ #category : 'tests' }
BLSMProtobufReaderTest >> testPackedVarints [

	self assert: (BLSMProtobufReader packedVarints: #[ 1 16rAC 16r02 9 ]) equals: #( 1 300 9 )
]

{ #category : 'tests' }
BLSMProtobufReaderTest >> testSeveralFields [

	self assert: ((self fieldsOf: #[ 8 1 16r1A 1 7 16 5 ]) collect: #first) equals: #( 1 3 2 )
]

{ #category : 'tests' }
BLSMProtobufReaderTest >> testSingleByteVarint [

	self assert: (self fieldsOf: #[ 8 1 ]) equals: { { 1. 0. 1 } }
]

{ #category : 'tests' }
BLSMProtobufReaderTest >> testZigZag [

	self assert: (BLSMProtobufReader zigZag: 0) equals: 0.
	self assert: (BLSMProtobufReader zigZag: 1) equals: -1.
	self assert: (BLSMProtobufReader zigZag: 2) equals: 1.
	self assert: (BLSMProtobufReader zigZag: 3) equals: -2
]
