Class {
	#name : 'AICodeAssistantBenchmarkResult',
	#superclass : 'Object',
	#instVars : [
		'conversation',
		'code',
		'status',
		'description'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'acccessing' }
AICodeAssistantBenchmarkResult class >> availableStatuses [
	^{ #invalid. #passed. #failed. #error }
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> beError: aString [

	status := #error.
	description := aString
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> beFailed [

	status := #failed
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> beFailed: aString [

	status := #failed.
	description := aString
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> beInvalid [

	status := #invalid
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> beInvalid: aString [

	status := #invalid.
	description := aString
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> bePassed [

	status := #passed
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> code [

	^ code
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> code: anObject [

	code := anObject
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> conversation [

	^ conversation
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> conversation: aCollection [

	conversation := aCollection
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> description [

	^ description
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> description: aString [

	description := aString
]

{ #category : 'testing' }
AICodeAssistantBenchmarkResult >> hasFailed [

	^ status == #failed
]

{ #category : 'testing' }
AICodeAssistantBenchmarkResult >> hasPassed [

	^ status == #passed
]

{ #category : 'initialization' }
AICodeAssistantBenchmarkResult >> initialize [

	super initialize.
	description := ''.
	status := #unkown
]

{ #category : 'testing' }
AICodeAssistantBenchmarkResult >> isError [

	^ status == #error
]

{ #category : 'testing' }
AICodeAssistantBenchmarkResult >> isInvalid [

	^ status == #invalid
]

{ #category : 'printing' }
AICodeAssistantBenchmarkResult >> printOn: aStream [

	aStream nextPutAll: status; space; nextPutAll: description
]

{ #category : 'accessing' }
AICodeAssistantBenchmarkResult >> status [

	^ status
]
