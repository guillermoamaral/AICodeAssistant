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
	assistant systemPrompt: self systemPrompt
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

{ #category : 'parameters' }
AICodeFromTestGenerationBenchmark >> systemPrompt [

	^ 'You are helping a user create Smalltalk code based on a given set of test cases the class should honor.
Your task is to generate one or more classes with their methods such that the provided tests pass.
If you find any issue when generating code do say it.'
]
