"
I am an Earth coordinate in degrees (WGS84). Latitude in [-90,90], longitude in [-180,180].
"
Class {
	#name : 'BLSMCoordinate',
	#superclass : 'Object',
	#instVars : [
		'latitude',
		'longitude'
	],
	#category : 'Blossom-Core',
	#package : 'Blossom',
	#tag : 'Core'
}

{ #category : 'instance creation' }
BLSMCoordinate class >> lat: aLatitude lon: aLongitude [

	(aLatitude between: -90 and: 90) ifFalse: [ ^ self error: 'Latitude must be in [-90, 90]' ].
	(aLongitude between: -180 and: 180) ifFalse: [ ^ self error: 'Longitude must be in [-180, 180]' ].
	^ self new setLatitude: aLatitude longitude: aLongitude
]

{ #category : 'comparing' }
BLSMCoordinate >> = other [

	^ self class = other class and: [ latitude = other latitude and: [ longitude = other longitude ] ]
]

{ #category : 'comparing' }
BLSMCoordinate >> hash [

	^ latitude hash bitXor: longitude hash
]

{ #category : 'accessing' }
BLSMCoordinate >> latitude [

	^ latitude
]

{ #category : 'accessing' }
BLSMCoordinate >> longitude [

	^ longitude
]

{ #category : 'printing' }
BLSMCoordinate >> printOn: aStream [

	aStream
		nextPutAll: 'BLSMCoordinate lat: ';
		print: latitude;
		nextPutAll: ' lon: ';
		print: longitude
]

{ #category : 'accessing' }
BLSMCoordinate >> setLatitude: aLatitude longitude: aLongitude [

	latitude := aLatitude.
	longitude := aLongitude
]
