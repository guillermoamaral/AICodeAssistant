Class {
	#name : 'AICodeAssistantBenchmark',
	#superclass : 'Object',
	#instVars : [
		'assistant',
		'results'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
AICodeAssistantBenchmark >> assistant [

	^ assistant
]

{ #category : 'accessing' }
AICodeAssistantBenchmark >> assistant: anAICodeAssistant [

	assistant := anAICodeAssistant
]

{ #category : 'intialization' }
AICodeAssistantBenchmark >> initialize [

	super initialize.
	assistant := AICodeAssistant new.
	results := OrderedCollection new
]
