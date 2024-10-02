"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestAICodeAssistant',
	#superclass : 'PackageManifest',
	#category : 'AICodeAssistant-Manifest',
	#package : 'AICodeAssistant',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestAICodeAssistant class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#AITestGenerationBenchmark #generateTestsFor: #false)) #'2024-10-02T00:07:32.056-03:00') )
]
