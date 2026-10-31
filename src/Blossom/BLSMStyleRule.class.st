"
I say how to draw the features of one layer that satisfy my condition (a one-argument block on the feature, or nil for all): fill colour for polygons, stroke colour and width (in pixels on a 256 pixel tile). Rules with a lower priority are drawn first.
"
Class {
	#name : 'BLSMStyleRule',
	#superclass : 'Object',
	#instVars : [
		'layerName',
		'condition',
		'fillColor',
		'strokeColor',
		'strokeWidth',
		'priority'
	],
	#category : 'Blossom-VectorTiles',
	#package : 'Blossom',
	#tag : 'VectorTiles'
}

{ #category : 'instance creation' }
BLSMStyleRule class >> layer: aName where: aBlockOrNil fill: aFillColor [

	^ self
		  layer: aName
		  where: aBlockOrNil
		  fill: aFillColor
		  stroke: nil
		  width: 0
]

{ #category : 'instance creation' }
BLSMStyleRule class >> layer: aName where: aBlockOrNil fill: aFillColor stroke: aStrokeColor width: aNumber [

	^ self new
		  setLayer: aName
		  condition: aBlockOrNil
		  fill: aFillColor
		  stroke: aStrokeColor
		  width: aNumber
]

{ #category : 'instance creation' }
BLSMStyleRule class >> layer: aName where: aBlockOrNil stroke: aStrokeColor width: aNumber [

	^ self
		  layer: aName
		  where: aBlockOrNil
		  fill: nil
		  stroke: aStrokeColor
		  width: aNumber
]

{ #category : 'accessing' }
BLSMStyleRule >> fillColor [

	^ fillColor
]

{ #category : 'accessing' }
BLSMStyleRule >> layerName [

	^ layerName
]

{ #category : 'accessing' }
BLSMStyleRule >> matches: aFeature in: aLayerName [

	^ layerName = aLayerName and: [ condition isNil or: [ condition value: aFeature ] ]
]

{ #category : 'accessing' }
BLSMStyleRule >> priority [

	^ priority
]

{ #category : 'accessing' }
BLSMStyleRule >> priority: anInteger [

	priority := anInteger
]

{ #category : 'accessing' }
BLSMStyleRule >> setLayer: aName condition: aBlockOrNil fill: aFillColor stroke: aStrokeColor width: aNumber [

	layerName := aName.
	condition := aBlockOrNil.
	fillColor := aFillColor.
	strokeColor := aStrokeColor.
	strokeWidth := aNumber
]

{ #category : 'accessing' }
BLSMStyleRule >> strokeColor [

	^ strokeColor
]

{ #category : 'accessing' }
BLSMStyleRule >> strokeWidth [

	^ strokeWidth
]
