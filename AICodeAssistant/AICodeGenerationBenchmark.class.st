"
This is a benchmark to measure the efficiency of AI code generation based on test.
"
Class {
	#name : 'AICodeGenerationBenchmark',
	#superclass : 'AICodeAssistantBenchmark',
	#instVars : [
		'targetSuites',
		'testSuite',
		'testResult',
		'generatedCode'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'private' }
AICodeGenerationBenchmark >> describeCompilationError: anError in: anAISuggestedMethod [

	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'This method you have provided <method>';
			  nextPutAll: anAISuggestedMethod sourceCode;
			  nextPutAll: '</method> could not be compiled due to: ';
			  nextPutAll: anError description ]
]

{ #category : 'private' }
AICodeGenerationBenchmark >> generateCodeFor: aTestSuite [

	| code result attempt |
	self log: 'Generating code for: #' , aTestSuite name , '...'.
	assistant clearHistory.
	code := assistant writeCodeFromTests: aTestSuite.
	result := self tryCode: code with: aTestSuite.
	attempt := 1.
	[ result hasPassed not and: [ attempt < maxAttempts ] ] whileTrue: [
		result := self tryToSolve: result.
		attempt := attempt + 1 ].
	result code: code.
	self log: 'Resulted in #' , result status.
	results add: result
]

{ #category : 'testing' }
AICodeGenerationBenchmark >> hasPassedTests [

	^ testResult notNil and: [ testResult hasPassed ]
	
]

{ #category : 'intialization' }
AICodeGenerationBenchmark >> initialize [

	super initialize.
	assistant beCodeFromTestsGenerator
]

{ #category : 'private' }
AICodeGenerationBenchmark >> mentionSuggestedMethod: anAISuggestedMethod [

	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'The suggested method <method>';
			  nextPutAll: anAISuggestedMethod sourceCode;
			  nextPutAll: '</method>']
]

{ #category : 'running' }
AICodeGenerationBenchmark >> run [
	"
	self new run
	"

	numIterations timesRepeat: [
		targetSuites do: [ :suite | self generateCodeFor: suite ] ]
]

{ #category : 'parameters' }
AICodeGenerationBenchmark >> targetSuites: aCollection [

	targetSuites := aCollection
]

{ #category : 'private' }
AICodeGenerationBenchmark >> tryCode: anAICodeGenerationResult with: aTestSuite [

	| result invalid suiteResult description |
	self log: 'Trying generated code...'.
	result := AICodeGenerationBenchmarkResult new.
	result
		conversation: assistant messages copy;
		code: anAICodeGenerationResult;
		testSuite: aTestSuite.
	invalid := anAICodeGenerationResult classes
		           detect: [ :class | class canBeInstalled ]
		           ifNone: [  ].
	invalid ifNotNil: [
		^ result beInvalid:
			  'Class  ' , invalid name , ' cannot be installed.' ].
	anAICodeGenerationResult classes do: #install.
	anAICodeGenerationResult classes do: [ :class |
		class methods do: [ :method |
			[ method install ]
				on: Error
				do: [ :e |
					description := self describeCompilationError: e in: method.
					^ result beInvalid: description ].
			method install ] ].
	suiteResult := aTestSuite run.
	suiteResult hasPassed ifTrue: [ ^ result bePassed ].
	suiteResult hasFailures ifTrue: [
		description := String streamContents: [ :strm |
			               strm nextPutAll:
				               'From the provided tests the following failed: '.
			               suiteResult failures do: [ :t |
				               strm
					               cr;
					               nextPutAll: t selector ] ].
		^ result beFailed: description ].
	description := String streamContents: [ :strm |
		               strm nextPutAll:
			               'From the provided tests the following failed: '.
		               suiteResult errors do: [ :t |
			               strm
				               cr;
				               nextPutAll: t selector ] ].
	^ result beError: description
]

{ #category : 'private' }
AICodeGenerationBenchmark >> tryToSolve: anAICodeGenerationBenchmarkResult [

	| code |
	assistant clearPromptContext.
	code := assistant requestCodeWith:
		        anAICodeGenerationBenchmarkResult description.
	^ self
		  tryCode: code
		  with: anAICodeGenerationBenchmarkResult testSuite
]
