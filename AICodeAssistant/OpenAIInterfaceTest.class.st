Class {
	#name : 'OpenAIInterfaceTest',
	#superclass : 'TestCase',
	#instVars : [
		'interface'
	],
	#category : 'AICodeAssistant-Tests',
	#package : 'AICodeAssistant',
	#tag : 'Tests'
}

{ #category : 'running' }
OpenAIInterfaceTest >> setUp [

	super setUp.
	interface := OpenAIInterface new.
	interface key: '<your OpenAI key>'
]

{ #category : 'tests' }
OpenAIInterfaceTest >> testDummy [

	| answer |
	answer := interface sendPrompt: 'Say this is a test'.
	self assert: answer equals: 'This is a test.'
]

{ #category : 'tests' }
OpenAIInterfaceTest >> testModel [

	| model |
	model := interface modelWithId: 'gpt-3.5-turbo'.
	self assert: (model at: 'id') equals: 'gpt-3.5-turbo'
]

{ #category : 'tests' }
OpenAIInterfaceTest >> testModels [

	| answer |
	answer := interface models.
	self assert: answer notEmpty
]
