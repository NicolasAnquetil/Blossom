"
I load Blossom, an OpenStreetMap viewer for Pharo built on Bloc.

Metacello new
  baseline: 'Blossom';
  repository: 'github://NicolasAnquetil/Blossom:main/src';
  load.

Groups: 'Core' (library only), 'Tests', 'default' (everything).
"
Class {
	#name : 'BaselineOfBlossom',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfBlossom',
	#package : 'BaselineOfBlossom'
}

{ #category : 'baselines' }
BaselineOfBlossom >> baseline: spec [

	<baseline>
	self defineDependencies: spec.
	self definePackages: spec.
	self defineGroups: spec
]

{ #category : 'baselines' }
BaselineOfBlossom >> defineDependencies: spec [

	spec baseline: 'Bloc' with: [ spec repository: 'github://pharo-graphics/Bloc:v2.9.0/src' ]
]

{ #category : 'baselines' }
BaselineOfBlossom >> defineGroups: spec [
	"common"

	spec
		group: 'Core' with: #( 'Blossom' );
		group: 'Tests' with: #( 'Blossom-Tests' );
		group: 'default' with: #( 'Core' 'Tests' )
]

{ #category : 'baselines' }
BaselineOfBlossom >> definePackages: spec [
	"common"

	spec
		package: 'Blossom' with: [ spec requires: #( 'Bloc' ) ];
		package: 'Blossom-Tests' with: [ spec requires: #( 'Blossom' ) ].

]
