"
I draw a BLSMVectorTile into a Form with Alexandrie/Cairo, using a BLSMVectorStyle and a BLSMDateFilter. Polygons are filled with the even-odd rule (so holes work), lines are stroked; points are not drawn yet.
"
Class {
	#name : 'BLSMVectorRenderer',
	#superclass : 'Object',
	#instVars : [
		'style',
		'filter',
		'size'
	],
	#category : 'Blossom-VectorTiles',
	#package : 'Blossom',
	#tag : 'VectorTiles'
}

{ #category : 'rendering' }
BLSMVectorRenderer >> draw: aFeature with: aRule scale: aNumber on: aContext [

	aFeature isPolygon ifTrue: [
			aRule fillColor ifNotNil: [ :color |
					self
						path: aFeature geometry
						scale: aNumber
						closed: true
						on: aContext.
					aContext
						sourceColor: color;
						fill ] ].
	aRule strokeColor ifNotNil: [ :color |
			self
				path: aFeature geometry
				scale: aNumber
				closed: aFeature isPolygon
				on: aContext.
			aContext
				sourceColor: color;
				strokeSize: aRule strokeWidth;
				stroke ]
]

{ #category : 'rendering' }
BLSMVectorRenderer >> drawablesOf: aTile [
	"Answer triples { rule. scale. feature } in drawing order"

	| result |
	result := OrderedCollection new.
	aTile layers do: [ :layer |
			| scale |
			scale := self size / layer extent.
			layer features do: [ :feature |
					(feature isPoint not and: [ self filter includes: feature ]) ifTrue: [
							(self style ruleFor: feature in: layer name) ifNotNil: [ :rule |
									result add: {
											rule.
											scale.
											feature } ] ] ] ].
	^ result asArray sort: [ :a :b | a first priority <= b first priority ]
]

{ #category : 'accessing' }
BLSMVectorRenderer >> filter [

	^ filter ifNil: [ filter := BLSMDateFilter new ]
]

{ #category : 'accessing' }
BLSMVectorRenderer >> filter: aDateFilter [

	filter := aDateFilter
]

{ #category : 'rendering' }
BLSMVectorRenderer >> path: parts scale: aNumber closed: aBoolean on: aContext [

	parts do: [ :part |
			part ifNotEmpty: [
					aContext moveTo: part first * aNumber.
					part allButFirstDo: [ :p | aContext lineTo: p * aNumber ].
					aBoolean ifTrue: [ aContext closePath ] ] ]
]

{ #category : 'rendering' }
BLSMVectorRenderer >> render: aTile [

	| surface context |
	surface := AeCairoImageSurface extent: self size asPoint.
	context := surface newContext.
	context
		sourceColor: self style background;
		paint.
	context useFillRuleEvenOdd.
	(self drawablesOf: aTile) do: [ :each |
			self
				draw: each third
				with: each first
				scale: each second
				on: context ].
	surface flush.
	^ surface asForm
]

{ #category : 'accessing' }
BLSMVectorRenderer >> size [

	^ size ifNil: [ 256 ]
]

{ #category : 'accessing' }
BLSMVectorRenderer >> size: anInteger [

	size := anInteger
]

{ #category : 'accessing' }
BLSMVectorRenderer >> style [

	^ style ifNil: [ style := BLSMVectorStyle default ]
]

{ #category : 'accessing' }
BLSMVectorRenderer >> style: aStyle [

	style := aStyle
]
