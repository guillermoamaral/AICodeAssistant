Class {
	#name : 'AICodeFromTestGenerationBenchmark',
	#superclass : 'AICodeAssistantBenchmark',
	#instVars : [
		'testSuite',
		'testResult',
		'code',
		'maxAttempts'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

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
	[ self hasPassed not and: [ attempt < maxAttempts ] ] whileTrue: [
		attempt := attempt + 1.
		code := assistant
			writeCodeFromTests: testSuite.
		self testCode ]
]
