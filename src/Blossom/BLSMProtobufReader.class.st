"
I read the Protocol Buffers wire format from a ByteArray. Wire types: 0 varint (answered as Integer), 1 fixed64 and 5 fixed32 (answered as ByteArray), 2 length-delimited (answered as ByteArray, to be read again with another reader).

  (BLSMProtobufReader on: bytes) fieldsDo: [ :field :wireType :value | ... ]
"
Class {
	#name : 'BLSMProtobufReader',
	#superclass : 'Object',
	#instVars : [
		'bytes',
		'position'
	],
	#category : 'Blossom-VectorTiles',
	#package : 'Blossom',
	#tag : 'VectorTiles'
}

{ #category : 'decoding' }
BLSMProtobufReader class >> double: aByteArray [

	| bits |
	bits := 0.
	8 to: 1 by: -1 do: [ :i | bits := (bits bitShift: 8) + (aByteArray at: i) ].
	^ Float fromIEEE64Bit: bits
]

{ #category : 'decoding' }
BLSMProtobufReader class >> float: aByteArray [

	^ Float fromIEEE32Bit: (aByteArray unsignedLongAt: 1 bigEndian: false)
]

{ #category : 'decoding' }
BLSMProtobufReader class >> on: aByteArray [

	^ self new setBytes: aByteArray
]

{ #category : 'decoding' }
BLSMProtobufReader class >> packedVarints: aByteArray [

	| reader result |
	reader := self on: aByteArray.
	result := OrderedCollection new.
	[ reader atEnd ] whileFalse: [ result add: reader nextVarint ].
	^ result asArray
]

{ #category : 'decoding' }
BLSMProtobufReader class >> zigZag: anInteger [

	^ (anInteger bitShift: -1) bitXor: (anInteger bitAnd: 1) negated
]

{ #category : 'reading' }
BLSMProtobufReader >> atEnd [

	^ position > bytes size
]

{ #category : 'reading' }
BLSMProtobufReader >> fieldsDo: aBlock [

	[ self atEnd ] whileFalse: [
			| key wireType value |
			key := self nextVarint.
			wireType := key bitAnd: 7.
			value := wireType = 0
				         ifTrue: [ self nextVarint ]
				         ifFalse: [
						         wireType = 2
							         ifTrue: [ self nextBytes: self nextVarint ]
							         ifFalse: [
									         wireType = 5
										         ifTrue: [ self nextBytes: 4 ]
										         ifFalse: [
												         wireType = 1
													         ifTrue: [ self nextBytes: 8 ]
													         ifFalse: [ ^ self error: 'Unsupported protobuf wire type ' , wireType printString ] ] ] ].
			aBlock value: (key bitShift: -3) value: wireType value: value ]
]

{ #category : 'reading' }
BLSMProtobufReader >> nextBytes: anInteger [

	| result |
	result := bytes copyFrom: position to: position + anInteger - 1.
	position := position + anInteger.
	^ result
]

{ #category : 'reading' }
BLSMProtobufReader >> nextVarint [

	| result shift byte |
	result := 0.
	shift := 0.
	[
		byte := bytes at: position.
		position := position + 1.
		result := result + ((byte bitAnd: 16r7F) bitShift: shift).
		shift := shift + 7.
		byte >= 16r80 ] whileTrue.
	^ result
]

{ #category : 'reading' }
BLSMProtobufReader >> setBytes: aByteArray [

	bytes := aByteArray.
	position := 1
]
