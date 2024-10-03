Class {
	#name : 'AIInterfaceTest',
	#superclass : 'TestCase',
	#instVars : [
		'interface'
	],
	#category : 'AICodeAssistant-Tests',
	#package : 'AICodeAssistant',
	#tag : 'Tests'
}

{ #category : 'set up' }
AIInterfaceTest >> initializeInterface [

	interface := self interfaceClass new.
	interface key: self key
]

{ #category : 'acccessing' }
AIInterfaceTest >> interfaceClass [
	
	self subclassResponsibility
]

{ #category : 'acccessing' }
AIInterfaceTest >> key [
	
	self subclassResponsibility
]

{ #category : 'set up' }
AIInterfaceTest >> setUp [

	super setUp.
	self initializeInterface 
]
