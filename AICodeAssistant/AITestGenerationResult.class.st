Class {
	#name : 'AITestGenerationResult',
	#superclass : 'Object',
	#instVars : [
		'conversation',
		'test',
		'error',
		'covered',
		'status'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
AITestGenerationResult >> beError: anError [

	status := #error.
	error := anError
]

{ #category : 'accessing' }
AITestGenerationResult >> beFailed [

	status := #failed
]

{ #category : 'accessing' }
AITestGenerationResult >> beInvalid [

	status := #invalid
]

{ #category : 'accessing' }
AITestGenerationResult >> bePassed [

	status := #passed
]

{ #category : 'accessing' }
AITestGenerationResult >> conversation [

	^ conversation
]

{ #category : 'accessing' }
AITestGenerationResult >> conversation: aCollection [

	conversation := aCollection
]

{ #category : 'accessing' }
AITestGenerationResult >> covered [

	^ covered
]

{ #category : 'accessing' }
AITestGenerationResult >> covered: aBoolean [

	covered := aBoolean
]

{ #category : 'accessing' }
AITestGenerationResult >> error [

	^ error
]

{ #category : 'testing' }
AITestGenerationResult >> hasError [
	^status == #error and: [error notNil]
]

{ #category : 'testing' }
AITestGenerationResult >> hasFailed [

	^ status == #failed
]

{ #category : 'testing' }
AITestGenerationResult >> hasPassed [

	^ status == #passed
]

{ #category : 'initalize' }
AITestGenerationResult >> initialize [
	super initialize.
	status := #none.
	covered := false
]

{ #category : 'printing' }
AITestGenerationResult >> printOn: aStream [

	aStream nextPutAll: status.
	test ifNotNil: [
		aStream
			space;
			nextPutAll: test selector ]
]

{ #category : 'accessing' }
AITestGenerationResult >> result [

	^ status
]

{ #category : 'accessing' }
AITestGenerationResult >> test [

	^ test
]

{ #category : 'accessing' }
AITestGenerationResult >> test: aCompiledMethod [

	test := aCompiledMethod
]

{ #category : 'testing' }
AITestGenerationResult >> wasCovered [

	^covered
]
