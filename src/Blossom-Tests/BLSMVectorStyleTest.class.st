Class {
	#name : 'BLSMVectorStyleTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-VectorTiles',
	#package : 'Blossom-Tests',
	#tag : 'VectorTiles'
}

{ #category : 'tests' }
BLSMVectorStyleTest >> feature: type attributes: aDictionary [

	| f |
	f := BLSMVectorFeature new.
	f decode: (ByteArray with: 24 with: type) keys: #(  ) values: #(  ).
	aDictionary keysAndValuesDo: [ :k :v | f attributes at: k put: v ].
	^ f
]

{ #category : 'tests' }
BLSMVectorStyleTest >> road: aType [

	^ self feature: 2 attributes: {
			  ('class' -> 'highway').
			  ('type' -> aType) } asDictionary
]

{ #category : 'tests' }
BLSMVectorStyleTest >> testAreasAreDrawnBeforeLines [

	| style |
	style := BLSMVectorStyle default.
	self assert: (style ruleFor: (self feature: 3 attributes: Dictionary new) in: 'water_areas') priority
		< (style ruleFor: (self road: 'tertiary') in: 'transport_lines') priority
]

{ #category : 'tests' }
BLSMVectorStyleTest >> testCustomRule [

	| style rule |
	style := BLSMVectorStyle new.
	style background: Color white.
	style addRule: (BLSMStyleRule
			 layer: 'roads'
			 where: [ :f | (f at: 'kind') = 'big' ]
			 stroke: Color red
			 width: 4).
	rule := style ruleFor: (self feature: 2 attributes: { ('kind' -> 'big') } asDictionary) in: 'roads'.
	self assert: rule strokeColor equals: Color red.
	self assert: (style ruleFor: (self feature: 2 attributes: { ('kind' -> 'small') } asDictionary) in: 'roads') isNil
]

{ #category : 'tests' }
BLSMVectorStyleTest >> testMajorRoadsAreWider [

	| style |
	style := BLSMVectorStyle default.
	self assert: (style ruleFor: (self road: 'primary') in: 'transport_lines') strokeWidth
		> (style ruleFor: (self road: 'tertiary') in: 'transport_lines') strokeWidth.
	self assert: (style ruleFor: (self road: 'tertiary') in: 'transport_lines') strokeWidth
		> (style ruleFor: (self road: 'footway') in: 'transport_lines') strokeWidth
]

{ #category : 'tests' }
BLSMVectorStyleTest >> testUnstyledLayerIsNotDrawn [

	self assert: (BLSMVectorStyle default ruleFor: (self road: 'tertiary') in: 'route_lines') isNil
]

{ #category : 'tests' }
BLSMVectorStyleTest >> testWaterAreaIsFilledBlue [

	| rule |
	rule := BLSMVectorStyle default ruleFor: (self feature: 3 attributes: { ('type' -> 'water') } asDictionary) in: 'water_areas'.
	self assert: rule isNotNil.
	self assert: rule fillColor blue > rule fillColor red
]
