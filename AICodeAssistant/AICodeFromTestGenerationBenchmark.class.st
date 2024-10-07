Class {
	#name : 'AICodeFromTestGenerationBenchmark',
	#superclass : 'AICodeAssistantBenchmark',
	#instVars : [
		'testSuite',
		'testResult',
		'generatedCode',
		'maxAttempts'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'private' }
AICodeFromTestGenerationBenchmark >> generateCode [

	generatedCode := testResult
		                 ifNil: [ assistant writeCodeFromTests: testSuite ]
		                 ifNotNil: [
			                 assistant sendPrompt:
				                 'The code you suggested makes test fail saying: ' ].
	generatedCode isString ifTrue: [ ^ self inform ].
	generatedCode
		do: [ :class | class install ];
		do: [ :class | class methods do: [ :method | method install ] ]
]

{ #category : 'testing' }
AICodeFromTestGenerationBenchmark >> hasPassedTests [

	^ testResult notNil and: [ testResult hasPassed ]
	
]

{ #category : 'intialization' }
AICodeFromTestGenerationBenchmark >> initialize [

	super initialize.
	maxAttempts := 2.
	assistant beCodeFromTestsGenerator 
]

{ #category : 'parameters' }
AICodeFromTestGenerationBenchmark >> maxAttempts: aNumber [

	maxAttempts := aNumber
]

{ #category : 'running' }
AICodeFromTestGenerationBenchmark >> run [
	"
	self new run
	"

	| attempt |
	attempt := 1.
	[ self hasPassedTests not and: [ attempt < maxAttempts ] ]
		whileTrue: [
			attempt := attempt + 1.
			self
				generateCode;
				testCode ]
]

{ #category : 'private' }
AICodeFromTestGenerationBenchmark >> testCode [

	testResult := testSuite run
]
