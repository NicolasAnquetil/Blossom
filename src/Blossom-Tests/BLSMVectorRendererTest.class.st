Class {
	#name : 'BLSMVectorRendererTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-VectorTiles',
	#package : 'Blossom-Tests',
	#tag : 'VectorTiles'
}

{ #category : 'tests' }
BLSMVectorRendererTest >> assertColorOf: aForm at: aPoint is: aColor [

	| c |
	c := aForm colorAt: aPoint.
	self assert: (c red - aColor red) abs + (c green - aColor green) abs + (c blue - aColor blue) abs < 0.05
]

{ #category : 'tests' }
BLSMVectorRendererTest >> render: aTile [

	^ BLSMVectorRenderer new
		  style: self style;
		  render: aTile
]

{ #category : 'tests' }
BLSMVectorRendererTest >> square [

	^ BLSMVectorFeature type: 3 attributes: Dictionary new geometry: { {
			  (1024 @ 1024).
			  (3072 @ 1024).
			  (3072 @ 3072).
			  (1024 @ 3072) } }
]

{ #category : 'tests' }
BLSMVectorRendererTest >> style [

	^ BLSMVectorStyle new
		  background: Color white;
		  addRule: (BLSMStyleRule layer: 'water' where: nil fill: Color blue);
		  addRule: (BLSMStyleRule
				   layer: 'roads'
				   where: nil
				   stroke: Color red
				   width: 4);
		  yourself
]

{ #category : 'tests' }
BLSMVectorRendererTest >> testDateFilterHidesFeatures [

	| feature form |
	feature := self square.
	feature attributes at: 'start_decdate' put: 1900.0.
	form := BLSMVectorRenderer new
		        style: self style;
		        filter: (BLSMDateFilter year: 1800);
		        render: (self tileWith: feature in: 'water').
	self assertColorOf: form at: 128 @ 128 is: Color white
]

{ #category : 'tests' }
BLSMVectorRendererTest >> testFormSize [

	self assert: (self render: (BLSMVectorTile layers: #(  ))) extent equals: 256 @ 256
]

{ #category : 'tests' }
BLSMVectorRendererTest >> testHoleInPolygon [

	| feature form |
	feature := BLSMVectorFeature type: 3 attributes: Dictionary new geometry: {
			           {
				           (0 @ 0).
				           (4096 @ 0).
				           (4096 @ 4096).
				           (0 @ 4096) }.
			           {
				           (1024 @ 1024).
				           (1024 @ 3072).
				           (3072 @ 3072).
				           (3072 @ 1024) } }.
	form := self render: (self tileWith: feature in: 'water').
	self assertColorOf: form at: 128 @ 128 is: Color white.
	self assertColorOf: form at: 10 @ 10 is: Color blue
]

{ #category : 'tests' }
BLSMVectorRendererTest >> testLineIsStroked [

	| form line |
	line := BLSMVectorFeature type: 2 attributes: Dictionary new geometry: { {
			        (0 @ 2048).
			        (4096 @ 2048) } }.
	form := self render: (self tileWith: line in: 'roads').
	self assertColorOf: form at: 100 @ 128 is: Color red.
	self assertColorOf: form at: 100 @ 100 is: Color white
]

{ #category : 'tests' }
BLSMVectorRendererTest >> testPolygonIsFilled [

	| form |
	form := self render: (self tileWith: self square in: 'water').
	self assertColorOf: form at: 128 @ 128 is: Color blue.
	self assertColorOf: form at: 10 @ 10 is: Color white
]

{ #category : 'tests' }
BLSMVectorRendererTest >> testUnstyledLayerIsIgnored [

	| form |
	form := self render: (self tileWith: self square in: 'buildings').
	self assertColorOf: form at: 128 @ 128 is: Color white
]

{ #category : 'tests' }
BLSMVectorRendererTest >> tileWith: aFeature in: aLayerName [

	^ BLSMVectorTile layers: { (BLSMVectorLayer name: aLayerName extent: 4096 features: { aFeature }) }
]
