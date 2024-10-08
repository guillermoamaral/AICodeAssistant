"
This classes are meant to run some benchmarks on services provided by AICodeAssistant.
"
Class {
	#name : 'AICodeAssistantBenchmark',
	#superclass : 'Object',
	#instVars : [
		'assistant',
		'results',
		'numIterations',
		'maxAttempts'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
AICodeAssistantBenchmark >> addResult: anAICodeAssistantBenchmarkResult [

	results add: anAICodeAssistantBenchmarkResult
]

{ #category : 'accessing' }
AICodeAssistantBenchmark >> assistant [

	^ assistant
]

{ #category : 'accessing' }
AICodeAssistantBenchmark >> assistant: anAICodeAssistant [

	assistant := anAICodeAssistant
]

{ #category : 'private' }
AICodeAssistantBenchmark >> describeError: anError [

	^ String streamContents: [ :strm |
		  anError == MessageNotUnderstood
			  ifTrue: [
				  strm
					  nextPutAll: 'a MessageNotUnderstood as the message ';
					  nextPutAll: anError message selector;
					  nextPutAll: ' was not understood by an instance of ';
					  nextPutAll: anError receiver class name;
					  nextPutAll:
						  '. These are the messages the object actually understands and could be used instead: '.
				  anError receiver class selectors
					  do: [ :s | strm nextPutAll: s ]
					  separatedBy: [ strm nextPut: $, ] ]
			  ifFalse: [
				  strm
					  nextPutAll: 'an error saying: "';
					  nextPutAll: anError description;
					  nextPut: $" ] ]
]

{ #category : 'intialization' }
AICodeAssistantBenchmark >> initialize [

	super initialize.
	assistant := AICodeAssistant new.
	results := OrderedCollection new.
	numIterations := 5.
	maxAttempts := 2
]

{ #category : 'logging' }
AICodeAssistantBenchmark >> log: aString [

	Transcript
		show: aString;
		cr
]

{ #category : 'parameters' }
AICodeAssistantBenchmark >> maxAttempts: aNumber [

	maxAttempts := aNumber
]

{ #category : 'parameters' }
AICodeAssistantBenchmark >> numIterations: aNumber [

	numIterations := aNumber
]

{ #category : 'accessing' }
AICodeAssistantBenchmark >> results [

	^ results
]

{ #category : 'private' }
AICodeAssistantBenchmark >> tryToCompile: aString in: aClass [

	AICodeAssistant compile: aString in: aClass
]
