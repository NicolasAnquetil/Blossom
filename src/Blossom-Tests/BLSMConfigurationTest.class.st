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
BLSMConfigurationTest >> testCyclOSMPreset [

	self
		assert: (BLSMConfiguration cyclOSM urlFor: (BLSMTileId x: 0 y: 0 zoom: 1)) asString
		equals: 'https://a.tile-cyclosm.openstreetmap.fr/cyclosm/1/0/0.png'
]

{ #category : 'tests' }
BLSMConfigurationTest >> testDefaultAttributionAndMaxZoom [

	self assert: (BLSMConfiguration default attribution includesSubstring: 'OpenStreetMap contributors').
	self assert: BLSMConfiguration default maxZoom equals: 19
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
BLSMConfigurationTest >> testHumanitarianPreset [

	self
		assert: (BLSMConfiguration humanitarian urlFor: (BLSMTileId x: 0 y: 0 zoom: 1)) asString
		equals: 'https://a.tile.openstreetmap.fr/hot/1/0/0.png'
]

{ #category : 'tests' }
BLSMConfigurationTest >> testNewProviderMatchesKind [

	self assert: (BLSMConfiguration default newProvider isKindOf: BLSMHttpTileProvider).
	self deny: (BLSMConfiguration default newProvider isKindOf: BLSMVectorTileProvider).
	self assert: (BLSMConfiguration openHistoricalMap newProvider isKindOf: BLSMVectorTileProvider)
]

{ #category : 'tests' }
BLSMConfigurationTest >> testOpenHistoricalMapPreset [

	| conf |
	conf := BLSMConfiguration openHistoricalMap.
	self assert: conf isVector.
	self deny: BLSMConfiguration default isVector.
	self assert: (conf attribution includesSubstring: 'OpenHistoricalMap').
	self
		assert: (conf urlFor: (BLSMTileId x: 1 y: 2 zoom: 3)) asString
		equals: 'https://vtiles.openhistoricalmap.org/maps/osm/3/1/2.pbf'.
	self assert: (BLSMConfiguration presets includesKey: 'OpenHistoricalMap')
]

{ #category : 'tests' }
BLSMConfigurationTest >> testOpenStreetMapFrancePreset [

	self
		assert: (BLSMConfiguration openStreetMapFrance urlFor: (BLSMTileId x: 0 y: 0 zoom: 1)) asString
		equals: 'https://a.tile.openstreetmap.fr/osmfr/1/0/0.png'
]

{ #category : 'tests' }
BLSMConfigurationTest >> testOpenTopoMapPreset [

	| conf |
	conf := BLSMConfiguration openTopoMap.
	self assert: (conf urlFor: (BLSMTileId x: 1 y: 2 zoom: 3)) asString equals: 'https://tile.opentopomap.org/3/1/2.png'.
	self assert: conf maxZoom equals: 17.
	self assert: (conf attribution includesSubstring: 'OpenTopoMap')
]

{ #category : 'tests' }
BLSMConfigurationTest >> testPresetsCatalog [

	| presets |
	presets := BLSMConfiguration presets.
	self
		assert: presets keys asSet
		equals: #( 'OpenStreetMap' 'OpenStreetMap France' 'Humanitarian' 'OpenTopoMap' 'CyclOSM' 'OpenHistoricalMap' ) asSet.
	presets valuesDo: [ :c | self assert: (c isKindOf: BLSMConfiguration) ]
]

{ #category : 'tests' }
BLSMConfigurationTest >> testSubdomains [

	| conf |
	conf := BLSMConfiguration urlTemplate: 'https://{s}.example.org/{z}/{x}/{y}.png'.
	self assert: (conf urlFor: (BLSMTileId x: 0 y: 0 zoom: 3)) asString equals: 'https://a.example.org/3/0/0.png'.
	self assert: (conf urlFor: (BLSMTileId x: 1 y: 0 zoom: 3)) asString equals: 'https://b.example.org/3/1/0.png'.
	self assert: (conf urlFor: (BLSMTileId x: 1 y: 2 zoom: 3)) asString equals: 'https://a.example.org/3/1/2.png'
]

{ #category : 'tests' }
BLSMConfigurationTest >> testWrapsTileX [

	self
		assert: (BLSMConfiguration default urlFor: (BLSMTileId x: 5 y: 1 zoom: 2)) asString
		equals: 'https://tile.openstreetmap.org/2/1/1.png'
]
