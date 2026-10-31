"
I am a pin drawn on a BLSMMapElement, centered on my coordinate.
"
Class {
	#name : 'BLSMMarkerElement',
	#superclass : 'BlElement',
	#instVars : [
		'coordinate'
	],
	#category : 'Blossom-UI',
	#package : 'Blossom',
	#tag : 'UI'
}

{ #category : 'accessing' }
BLSMMarkerElement >> anchor [
	"Offset from my top-left to the point that sits on my coordinate"

	^ self radius asPoint
]

{ #category : 'accessing' }
BLSMMarkerElement >> coordinate [

	^ coordinate
]

{ #category : 'accessing' }
BLSMMarkerElement >> coordinate: aCoordinate [

	coordinate := aCoordinate
]

{ #category : 'initialization' }
BLSMMarkerElement >> initialize [

	super initialize.
	self extent: (self radius * 2) asPoint.
	self geometry: BlEllipseGeometry new.
	self background: (Color r: 0.85 g: 0.15 b: 0.15).
	self border: (BlBorder paint: Color white width: 2)
]

{ #category : 'accessing' }
BLSMMarkerElement >> radius [

	^ 8
]
