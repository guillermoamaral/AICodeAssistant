"
This is a benchmark to measure the efficiency of AI test generation based on code.
"
Class {
	#name : 'AITestGenerationBenchmark',
	#superclass : 'AICodeAssistantBenchmark',
	#instVars : [
		'targetMethods',
		'initialHistoryIndex'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'private' }
AITestGenerationBenchmark >> describeCompilationError: anError in: aString [

	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'This test you have provided <test>';
			  nextPutAll: aString;
			  nextPutAll: '</test> could not be compiled due to: ';
			  nextPutAll: anError description ]
]

{ #category : 'private' }
AITestGenerationBenchmark >> describeTestError: anError in: aString [

	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'This test you have provided <test>';
			  nextPutAll: aString;
			  nextPutAll: '</test> resulted in '.
		  anError == MessageNotUnderstood
			  ifTrue: [
				  strm
					  nextPutAll: 'a MessageNotUnderstood exception since ';
					  nextPutAll: anError message selector;
					  nextPutAll: ' is not understood by an instance of ';
					  nextPutAll: anError receiver class name;
					  nextPutAll:
						  '. Provide a version based on the the following messages that object understands: '.
				  anError receiver class selectors
					  do: [ :s | strm nextPutAll: s ]
					  separatedBy: [ strm nextPut: $, ].
				  strm cr ]
			  ifFalse: [
				  strm
					  nextPutAll: 'the following error: ';
					  nextPutAll: anError description;
					  nextPutAll:
						  '. Provide a version that does not fall into this exception.';
					  cr ] ]
]

{ #category : 'private' }
AITestGenerationBenchmark >> describeTestFailure: aTestFailure in: aString [
	"We need to provide better description based on the concrete assertion that triggered the failure..."

	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'This test you have provided <test>';
			  nextPutAll: aString;
			  nextPutAll: '</test> resulted in the following failure: ';
			  cr;
			  nextPutAll: aTestFailure description;
			  nextPutAll: '. Provide a version that does not fail.' ]
]

{ #category : 'private' }
AITestGenerationBenchmark >> generateTestsFor: aCompiledMethod [

	| tests result attempt |
	self log:
		'Generating tests for: #' , aCompiledMethod selector , '...'.
	assistant clearHistory.
	tests := (assistant writeTestsForMethod: aCompiledMethod) methods.
	tests do: [ :test |
		result := self tryTest: test.
		attempt := 1.
		[ result hasPassed not and: [ attempt < maxAttempts ] ] whileTrue: [
			result := self tryToSolve: result.
			attempt := attempt + 1 ].
		result testedMethod: aCompiledMethod.
		self log: 'Resulted in #' , result status.
		self addResult: result ]
]

{ #category : 'initialization' }
AITestGenerationBenchmark >> initialize [

	super initialize.
	assistant beTestsGenerator
]

{ #category : 'running' }
AITestGenerationBenchmark >> run [
	"
	self new run
	"
	numIterations timesRepeat: [
		targetMethods do: [ :method | self generateTestsFor: method ] ]
]

{ #category : 'results' }
AITestGenerationBenchmark >> showPlot [

	| plot categories grouped data cluster methods color k |
	categories := AITestGenerationBenchmarkResult availableStatuses.
	grouped := Dictionary new.
	results do: [ :r |
		(grouped at: r testedMethod ifAbsentPut: [ OrderedCollection new ])
			add: r ].
	methods := grouped keys asArray.
	categories do: [ :status |
		data := methods collect: [ :m |
			        k := (grouped at: m) count: [ :r | r status = status ].
			        k asFloat / (grouped at: m) size ].
		cluster := RSBarPlotNew new data: data.
		color := status = #invalid
			         ifTrue: [ Color black ]
			         ifFalse: [
				         status = #passed
					         ifTrue: [ Color green ]
					         ifFalse: [
						         status = #failed
							         ifTrue: [ Color orange ]
							         ifFalse: [ Color red ] ] ].
		cluster color: color.
		plot := plot ifNil: [ cluster ] ifNotNil: [ plot + cluster ] ].
	plot
		title: 'Test generation benchmark (' , assistant interfaceName , ')';
		xlabel:
			' black = invalid, green = passed, orange = failed, red = error ';
		xTickLabels: (methods collect: #selector).
	^ plot open
]

{ #category : 'parameters' }
AITestGenerationBenchmark >> targetMethods: aCollection [
	
		targetMethods := aCollection

]

{ #category : 'private' }
AITestGenerationBenchmark >> tryTest: anAISuggestedMethod [

	| result code description selector suite testResult exception |
	self log: 'Trying generated test...'.
	result := AITestGenerationBenchmarkResult new.
	result conversation: assistant messages copy.
	anAISuggestedMethod ifNil: [ ^ result beInvalid ].
	code := anAISuggestedMethod sourceCode.
	result testCode: code.
	[ self tryToCompile: code in: AIGeneratedTest ]
		on: Error
		do: [ :e |
			description := self describeCompilationError: e in: code.
			^ result beInvalid: description ].
	selector := AIGeneratedTest compile: code.
	suite := AIGeneratedTest buildSuiteFromMethods: { selector }.
	testResult := suite run.
	(testResult hasErrors or: [ testResult hasFailures ]) ifTrue: [
		[ suite tests anyOne runCase ]
			on: Exception
			do: [ :e | exception := e ] ].
	testResult hasErrors ifTrue: [
		description := self describeTestError: exception in: code.
		^ result beError: description ].
	testResult hasFailures ifTrue: [
		description := self describeTestFailure: exception in: code.
		^ result beFailed: description ].
	^ result bePassed
]

{ #category : 'private' }
AITestGenerationBenchmark >> tryToSolve: anAITestGenerationBenchmarkResult [

	| tests |
	tests := (assistant requestTestsWith:
		          anAITestGenerationBenchmarkResult description) methods.
	^ self tryTest: (tests notEmpty ifTrue: [ tests anyOne ])
]
