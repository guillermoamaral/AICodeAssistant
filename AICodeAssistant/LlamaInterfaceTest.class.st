Class {
	#name : 'LlamaInterfaceTest',
	#superclass : 'AIInterfaceTest',
	#category : 'AICodeAssistant-Tests',
	#package : 'AICodeAssistant',
	#tag : 'Tests'
}

{ #category : 'acccessing' }
LlamaInterfaceTest >> interfaceClass [

	^LlamaInterface
]

{ #category : 'tests' }
LlamaInterfaceTest >> testDummy [

	| answer |
	answer := interface sendPrompt: 'Say this is a test'.
	self assert: answer equals: 'This is a test.'
]
