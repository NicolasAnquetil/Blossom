Class {
	#name : 'BLSMDateFilterTest',
	#superclass : 'TestCase',
	#category : 'Blossom-Tests-VectorTiles',
	#package : 'Blossom-Tests',
	#tag : 'VectorTiles'
}

{ #category : 'tests' }
BLSMDateFilterTest >> featureFrom: start to: end [

	| f |
	f := BLSMVectorFeature new.
	f decode: #[  ] keys: #(  ) values: #(  ).
	start ifNotNil: [ f attributes at: 'start_decdate' put: start ].
	end ifNotNil: [ f attributes at: 'end_decdate' put: end ].
	^ f
]

{ #category : 'tests' }
BLSMDateFilterTest >> testBeforeAndAfter [

	| f |
	f := self featureFrom: 1754.00137 to: 1850.99863.
	self deny: ((BLSMDateFilter year: 1700) includes: f).
	self deny: ((BLSMDateFilter year: 1900) includes: f)
]

{ #category : 'tests' }
BLSMDateFilterTest >> testInsideRange [

	self assert: ((BLSMDateFilter year: 1800) includes: (self featureFrom: 1754.00137 to: 1850.99863))
]

{ #category : 'tests' }
BLSMDateFilterTest >> testIntegerYearIsWholeYear [

	self assert: ((BLSMDateFilter year: 1850) includes: (self featureFrom: 1754.00137 to: 1850.99863)).
	self assert: ((BLSMDateFilter year: 1754) includes: (self featureFrom: 1754.00137 to: 1850.99863))
]

{ #category : 'tests' }
BLSMDateFilterTest >> testNoYearKeepsEverything [

	self assert: (BLSMDateFilter new includes: (self featureFrom: 1754.00137 to: 1850.99863))
]

{ #category : 'tests' }
BLSMDateFilterTest >> testOpenBounds [

	self assert: ((BLSMDateFilter year: 2020) includes: (self featureFrom: 1529.00137 to: nil)).
	self deny: ((BLSMDateFilter year: 1500) includes: (self featureFrom: 1529.00137 to: nil)).
	self assert: ((BLSMDateFilter year: 1000) includes: (self featureFrom: nil to: 1422.99863)).
	self assert: ((BLSMDateFilter year: 1000) includes: (self featureFrom: nil to: nil))
]
