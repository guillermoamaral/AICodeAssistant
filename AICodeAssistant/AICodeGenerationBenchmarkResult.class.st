Class {
	#name : 'AICodeGenerationBenchmarkResult',
	#superclass : 'AICodeAssistantBenchmarkResult',
	#instVars : [
		'testSuite'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
AICodeGenerationBenchmarkResult >> testSuite [

	^ testSuite
]

{ #category : 'accessing' }
AICodeGenerationBenchmarkResult >> testSuite: aTestSuite [

	testSuite := aTestSuite
]
