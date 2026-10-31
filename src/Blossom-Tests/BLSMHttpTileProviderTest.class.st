Class {
	#name : 'BLSMHttpTileProviderTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-Network',
	#package : 'Blossom-Tests',
	#tag : 'Network'
}

{ #category : 'tests' }
BLSMHttpTileProviderTest >> pngBytes [

	| stream |
	stream := ByteArray new writeStream.
	PNGReadWriter putForm: (Form extent: 256 @ 256 depth: 32) onStream: stream.
	^ stream contents
]

{ #category : 'tests' }
BLSMHttpTileProviderTest >> testFakeProviderRecordsRequests [

	| fake form |
	fake := BLSMFakeTileProvider new.
	form := fake formFor: (BLSMTileId x: 0 y: 0 zoom: 0).
	self assert: form extent equals: 256 @ 256.
	self assert: fake requested asArray equals: { (BLSMTileId x: 0 y: 0 zoom: 0) }
]

{ #category : 'tests' }
BLSMHttpTileProviderTest >> testFormForDecodesTransportBytes [

	| provider received form |
	provider := BLSMHttpTileProvider configuration: BLSMConfiguration default.
	provider transport: [ :req |
			received := req.
			self pngBytes ].
	form := provider formFor: (BLSMTileId x: 0 y: 0 zoom: 0).
	self assert: form extent equals: 256 @ 256.
	self assert: received isNotNil.
	self assert: received url asString equals: 'https://tile.openstreetmap.org/0/0/0.png'
]

{ #category : 'tests' }
BLSMHttpTileProviderTest >> testRequestUsesConfiguration [

	| conf request |
	conf := BLSMConfiguration default.
	conf accessToken: 'tok'.
	request := (BLSMHttpTileProvider configuration: conf) requestFor: (BLSMTileId x: 1 y: 2 zoom: 3).
	self assert: request url asString equals: 'https://tile.openstreetmap.org/3/1/2.png'.
	self assert: (request headers at: 'User-Agent') equals: conf userAgent.
	self assert: (request headers at: 'Authorization') equals: 'Bearer tok'
]
