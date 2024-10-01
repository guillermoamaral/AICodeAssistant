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

{ #category : 'intialization' }
AICodeAssistantBenchmark >> initialize [

	super initialize.
	assistant := AICodeAssistant new.
	results := OrderedCollection new
]
