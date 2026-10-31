Class {
	#name : 'BLSMVectorTileProviderTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-VectorTiles',
	#package : 'Blossom-Tests',
	#tag : 'VectorTiles'
}

{ #category : 'tests' }
BLSMVectorTileProviderTest >> paris [

	^ BLSMTileId x: 4149 y: 2818 zoom: 13
]

{ #category : 'tests' }
BLSMVectorTileProviderTest >> parisBytes [

	^ BLSMVectorTileTest new parisFixture
]

{ #category : 'tests' }
BLSMVectorTileProviderTest >> provider [

	^ (BLSMVectorTileProvider configuration: BLSMConfiguration openHistoricalMap)
		  transport: [ :request | self parisBytes ];
		  yourself
]

{ #category : 'tests' }
BLSMVectorTileProviderTest >> testAnswersARenderedForm [

	self assert: (self provider formFor: self paris) extent equals: 256 @ 256
]

{ #category : 'tests' }
BLSMVectorTileProviderTest >> testDecodedTilesAreReusedAcrossYears [

	| p downloads |
	downloads := 0.
	p := self provider.
	p transport: [ :request |
			downloads := downloads + 1.
			self parisBytes ].
	p
		year: 1500;
		formFor: self paris.
	p
		year: 2020;
		formFor: self paris.
	self assert: downloads equals: 1
]

{ #category : 'tests' }
BLSMVectorTileProviderTest >> testRequestUsesVectorUrl [

	| received |
	(self provider
		 transport: [ :request |
				 received := request.
				 self parisBytes ];
		 yourself) formFor: self paris.
	self assert: received url asString equals: 'https://vtiles.openhistoricalmap.org/maps/osm/13/4149/2818.pbf'
]

{ #category : 'tests' }
BLSMVectorTileProviderTest >> testYearChangesResult [

	| p f1 f2 |
	p := self provider.
	f1 := (p
		       year: 1500;
		       formFor: self paris) bits copy.
	f2 := (p
		       year: 2020;
		       formFor: self paris) bits copy.
	self deny: f1 equals: f2
]

{ #category : 'tests' }
BLSMVectorTileProviderTest >> testYearDefaultsToNil [

	self assert: self provider year isNil
]
