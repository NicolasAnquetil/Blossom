"
I am an ordered list of BLSMStyleRule and a background colour. The first rule matching a feature decides how it is drawn; features without a rule are not drawn. #default is a simple style for the OpenHistoricalMap layers.
"
Class {
	#name : 'BLSMVectorStyle',
	#superclass : 'Object',
	#instVars : [
		'background',
		'rules'
	],
	#category : 'Blossom-VectorTiles',
	#package : 'Blossom',
	#tag : 'VectorTiles'
}

{ #category : 'instance creation' }
BLSMVectorStyle class >> default [
	"A simple style for the OpenHistoricalMap vector layers. Rules are listed in drawing order."

	| style isType |
	isType := [ :types | [ :f | types includes: (f at: 'type') ] ].
	style := self new.
	style
		addRule: (BLSMStyleRule
				 layer: 'landuse_areas'
				 where: (isType value: #( 'park' 'garden' 'grass' 'meadow' 'forest' 'wood' 'cemetery' 'recreation_ground' ))
				 fill: (Color r: 0.78 g: 0.89 b: 0.72));
		addRule: (BLSMStyleRule layer: 'landuse_areas' where: nil fill: (Color r: 0.91 g: 0.89 b: 0.86));
		addRule: (BLSMStyleRule layer: 'water_areas' where: nil fill: (Color r: 0.67 g: 0.83 b: 0.93));
		addRule: (BLSMStyleRule
				 layer: 'other_areas'
				 where: [ :f | (f at: 'class') = 'historic' ]
				 fill: (Color r: 0.89 g: 0.82 b: 0.74)
				 stroke: (Color r: 0.6 g: 0.45 b: 0.3)
				 width: 0.6);
		addRule: (BLSMStyleRule
				 layer: 'transport_areas'
				 where: nil
				 fill: (Color r: 0.98 g: 0.98 b: 0.97)
				 stroke: (Color r: 0.8 g: 0.8 b: 0.8)
				 width: 0.5);
		addRule: (BLSMStyleRule
				 layer: 'water_lines'
				 where: nil
				 stroke: (Color r: 0.45 g: 0.68 b: 0.86)
				 width: 1.5);
		addRule: (BLSMStyleRule
				 layer: 'transport_lines'
				 where: [ :f | (f at: 'class') = 'railway' ]
				 stroke: (Color r: 0.45 g: 0.45 b: 0.5)
				 width: 1);
		addRule: (BLSMStyleRule
				 layer: 'transport_lines'
				 where: (isType value: #( 'footway' 'path' 'steps' 'cycleway' 'track' 'bridleway' ))
				 stroke: (Color r: 0.6 g: 0.55 b: 0.5)
				 width: 0.6);
		addRule: (BLSMStyleRule
				 layer: 'transport_lines'
				 where: (isType value: #( 'motorway' 'trunk' 'primary' ))
				 stroke: (Color r: 0.96 g: 0.66 b: 0.4)
				 width: 3);
		addRule: (BLSMStyleRule
				 layer: 'transport_lines'
				 where: (isType value: #( 'secondary' ))
				 stroke: (Color r: 0.98 g: 0.87 b: 0.55)
				 width: 2.5);
		addRule: (BLSMStyleRule
				 layer: 'transport_lines'
				 where: [ :f | (f at: 'class') = 'highway' ]
				 stroke: Color white
				 width: 1.8);
		addRule: (BLSMStyleRule
				 layer: 'land_ohm_lines'
				 where: nil
				 stroke: (Color r: 0.6 g: 0.4 b: 0.7)
				 width: 1.2).
	^ style
]

{ #category : 'accessing' }
BLSMVectorStyle >> addRule: aRule [

	self rules add: aRule.
	aRule priority: self rules size.
	^ aRule
]

{ #category : 'accessing' }
BLSMVectorStyle >> background [

	^ background ifNil: [ Color r: 0.95 g: 0.94 b: 0.91 ]
]

{ #category : 'accessing' }
BLSMVectorStyle >> background: aColor [

	background := aColor
]

{ #category : 'accessing' }
BLSMVectorStyle >> ruleFor: aFeature in: aLayerName [

	^ self rules detect: [ :each | each matches: aFeature in: aLayerName ] ifNone: [ nil ]
]

{ #category : 'accessing' }
BLSMVectorStyle >> rules [

	^ rules ifNil: [ rules := OrderedCollection new ]
]
