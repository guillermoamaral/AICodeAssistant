Class {
	#name : 'MistralInterfaceTest',
	#superclass : 'AIInterfaceTest',
	#category : 'AICodeAssistant-Tests',
	#package : 'AICodeAssistant',
	#tag : 'Tests'
}

{ #category : 'acccessing' }
MistralInterfaceTest >> interfaceClass [

	^ MistralInterface 
]

{ #category : 'tests' }
MistralInterfaceTest >> testDummy [

	| answer |
	answer := interface sendPrompt: 'Say this is a test'.
	self assert: answer equals: 'This is a test.'
]
