Class {
	#name : 'BLSMConfigurationTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-Network',
	#package : 'Blossom-Tests',
	#tag : 'Network'
}

{ #category : 'tests' }
BLSMConfigurationTest >> testApiKey [

	| conf |
	conf := BLSMConfiguration urlTemplate: 'https://example.org/{z}/{x}/{y}.png'.
	conf apiKey: 'secret'.
	self assert: (conf urlFor: (BLSMTileId x: 1 y: 2 zoom: 3)) asString equals: 'https://example.org/3/1/2.png?apikey=secret'
]

{ #category : 'tests' }
BLSMConfigurationTest >> testCustomTemplate [

	| conf |
	conf := BLSMConfiguration urlTemplate: 'https://example.org/tiles/{z}/{x}/{y}.png'.
	self assert: (conf urlFor: (BLSMTileId x: 1 y: 2 zoom: 3)) asString equals: 'https://example.org/tiles/3/1/2.png'
]

{ #category : 'tests' }
BLSMConfigurationTest >> testDefaultUrl [

	self
		assert: (BLSMConfiguration default urlFor: (BLSMTileId x: 4149 y: 2818 zoom: 13)) asString
		equals: 'https://tile.openstreetmap.org/13/4149/2818.png'
]

{ #category : 'tests' }
BLSMConfigurationTest >> testDefaultUserAgent [

	self assert: (BLSMConfiguration default userAgent includesSubstring: 'Blossom')
]

{ #category : 'tests' }
BLSMConfigurationTest >> testHeaders [

	| conf |
	conf := BLSMConfiguration default.
	self assert: (conf headers at: 'User-Agent') equals: conf userAgent.
	self deny: (conf headers includesKey: 'Authorization').
	conf accessToken: 'tok'.
	self assert: (conf headers at: 'Authorization') equals: 'Bearer tok'
]

{ #category : 'tests' }
BLSMConfigurationTest >> testWrapsTileX [

	self
		assert: (BLSMConfiguration default urlFor: (BLSMTileId x: 5 y: 1 zoom: 2)) asString
		equals: 'https://tile.openstreetmap.org/2/1/1.png'
]
