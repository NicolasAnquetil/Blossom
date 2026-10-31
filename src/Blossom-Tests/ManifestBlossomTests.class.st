"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestBlossomTests',
	#superclass : 'PackageManifest',
	#category : 'Blossom-Tests-Manifest',
	#package : 'Blossom-Tests',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestBlossomTests class >> ruleTempsReadBeforeWrittenRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#BLSMHttpTileProviderTest #testFormForDecodesTransportBytes #false)) #'2026-10-31T13:10:28.902112+01:00') )
]
