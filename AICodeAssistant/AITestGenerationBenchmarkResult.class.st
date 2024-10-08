"
Handy holder for AITestGenerationBenchmarkResults.
"
Class {
	#name : 'AITestGenerationBenchmarkResult',
	#superclass : 'AICodeAssistantBenchmarkResult',
	#instVars : [
		'testedMethod',
		'error',
		'failure',
		'covered'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
AITestGenerationBenchmarkResult >> covered [

	^ covered
]

{ #category : 'accessing' }
AITestGenerationBenchmarkResult >> covered: aBoolean [

	covered := aBoolean
]

{ #category : 'initalize' }
AITestGenerationBenchmarkResult >> initialize [

	super initialize.
	covered := false
]

{ #category : 'accessing' }
AITestGenerationBenchmarkResult >> testCode [

	^ code
]

{ #category : 'accessing' }
AITestGenerationBenchmarkResult >> testCode: aString [

	code := aString
]

{ #category : 'accessing' }
AITestGenerationBenchmarkResult >> testedMethod [

	^ testedMethod
]

{ #category : 'accessing' }
AITestGenerationBenchmarkResult >> testedMethod: aCompiledMethod [

	testedMethod := aCompiledMethod
]

{ #category : 'testing' }
AITestGenerationBenchmarkResult >> wasCovered [

	^covered
]
