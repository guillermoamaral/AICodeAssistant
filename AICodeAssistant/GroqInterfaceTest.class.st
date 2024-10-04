Class {
	#name : 'GroqInterfaceTest',
	#superclass : 'AIInterfaceTest',
	#category : 'AICodeAssistant-Tests',
	#package : 'AICodeAssistant',
	#tag : 'Tests'
}

{ #category : 'acccessing' }
GroqInterfaceTest >> interfaceClass [

	^ GroqInterface
]

{ #category : 'tests' }
GroqInterfaceTest >> testModels [

	| answer |
	answer := interface models.
	self assert: answer notEmpty
]
