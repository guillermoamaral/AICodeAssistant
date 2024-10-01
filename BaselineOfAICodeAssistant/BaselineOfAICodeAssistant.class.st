Class {
	#name : 'BaselineOfAICodeAssistant',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfAICodeAssistant',
	#package : 'BaselineOfAICodeAssistant'
}

{ #category : 'baselines' }
BaselineOfAICodeAssistant >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self setUpDependencies: spec.
		spec
			package: 'AICodeAssistant'
			with: [ spec requires: #( 'Teapot' 'NeoJSON' ) ] ]
]

{ #category : 'accessing' }
BaselineOfAICodeAssistant >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : 'accessing' }
BaselineOfAICodeAssistant >> setUpDependencies: spec [

	spec
		baseline: 'Teapot'
		with: [ spec repository: 'github://zeroflag/Teapot:v2.7.0/source' ].

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]
