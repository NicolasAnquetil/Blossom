Class {
	#name : 'BLSMTileCacheTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-Network',
	#package : 'Blossom-Tests',
	#tag : 'Network'
}

{ #category : 'tests' }
BLSMTileCacheTest >> testEvictsLeastRecentlyUsed [

	| fake cache |
	fake := BLSMFakeTileProvider new.
	cache := (BLSMTileCache on: fake)
		         maxSize: 2;
		         yourself.
	cache
		formFor: (self tile: 1);
		formFor: (self tile: 2);
		formFor: (self tile: 1);
		formFor: (self tile: 3).
	self assert: cache size equals: 2.
	self assert: (cache includes: (self tile: 1)).
	self deny: (cache includes: (self tile: 2))
]

{ #category : 'tests' }
BLSMTileCacheTest >> testSecondFetchHitsCache [

	| fake cache f1 f2 |
	fake := BLSMFakeTileProvider new.
	cache := BLSMTileCache on: fake.
	f1 := cache formFor: (self tile: 1).
	f2 := cache formFor: (self tile: 1).
	self assert: f1 identicalTo: f2.
	self assert: fake requested size equals: 1
]

{ #category : 'tests' }
BLSMTileCacheTest >> tile: x [

	^ BLSMTileId x: x y: 0 zoom: 3
]
