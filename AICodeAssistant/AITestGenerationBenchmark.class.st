Class {
	#name : 'AITestGenerationBenchmark',
	#superclass : 'AICodeAssistantBenchmark',
	#instVars : [
		'numIterations',
		'maxAttempts',
		'targetMethods'
	],
	#category : 'AICodeAssistant-Benchmarks',
	#package : 'AICodeAssistant',
	#tag : 'Benchmarks'
}

{ #category : 'private' }
AITestGenerationBenchmark >> canCompile: aString in: aClass [
	"
	self new canCompile: 'm ^' in: Class
	"

	| result |
	result := [
	          OpalCompiler new
		          source: aString;
		          class: aClass;
		          compile ]
		          on: Error
		          do: [  ].
	^ result notNil
]

{ #category : 'results' }
AITestGenerationBenchmark >> clusterBarPlot [

	| plot categories grouped data cluster methods color |
	categories := AITestGenerationResult availableStatuses.
	grouped := Dictionary new.
	results do: [ :r |
		(grouped at: r testedMethod ifAbsentPut: [ OrderedCollection new ])
			add: r ].
	methods := grouped keys asArray.
	categories do: [ :status |
		data := methods collect: [ :m |
			        (grouped at: m) count: [ :r | r status = status ] ].
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
		title: 'Test generation benchmark (', assistant interfaceName, ')';
		xlabel:
			' black = invalid, green = passed, orange = failed, red = error ';
		xTickLabels: (methods collect: #selector).
	^ plot open
]

{ #category : 'private' }
AITestGenerationBenchmark >> generateTestsFor: aCompiledMethod [

	| tests result attempt |
	tests := assistant
		         clearHistory;
		         writeTestsForMethod: aCompiledMethod.
	tests do: [ :code |
		result := self tryTestCode: code trim.
		attempt := 1.
		[ result hasError and: [ attempt < maxAttempts ] ] whileTrue: [
			result := self tryToOvercomeError: result.
			attempt := attempt + 1 ].
		result testedMethod: aCompiledMethod.
		results add: result ]
]

{ #category : 'initialization' }
AITestGenerationBenchmark >> initialize [

	super initialize.
	numIterations := 5.
	maxAttempts := 2.
	assistant beTestsGenerator
]

{ #category : 'parameters' }
AITestGenerationBenchmark >> maxAttempts: aNumber [

	maxAttempts := aNumber
]

{ #category : 'parameters' }
AITestGenerationBenchmark >> numIterations: aNumber [

	numIterations := aNumber
]

{ #category : 'running' }
AITestGenerationBenchmark >> run [
	"
	self new run
	"
	numIterations timesRepeat: [
		targetMethods do: [ :method | self generateTestsFor: method ] ]
]

{ #category : 'parameters' }
AITestGenerationBenchmark >> targetMethods: aCollection [
	
		targetMethods := aCollection

]

{ #category : 'private' }
AITestGenerationBenchmark >> tryTestCode: aString [

	| result selector suite test testResult error |
	result := AITestGenerationResult new
		          conversation: assistant messages copy;
		          testCode: aString.
	(self canCompile: aString in: TestCase) ifFalse: [
		^ result beInvalid ].
	selector := TestCase compile: 'test_AiGenerated_' , aString.
	suite := TestSuite named: selector.
	test := TestCase selector: selector.
	suite addTest: test.
	testResult := suite run.
	testResult hasErrors ifTrue: [
		[ test runCase ]
			on: Error
			do: [ :e | error := e ].
		^ result beError: error ].
	testResult hasFailures
		ifTrue: [ result beFailed ]
		ifFalse: [ result bePassed ].
	^ result
]

{ #category : 'private' }
AITestGenerationBenchmark >> tryToOvercomeError: anAITestAssistantResult [

	| error prompt answer code |
	error := anAITestAssistantResult error.
	prompt := error class == MessageNotUnderstood
		          ifTrue: [
			          String streamContents: [ :strm |
				          strm
					          nextPutAll: 'This code you have provided ';
					          nextPutAll: anAITestAssistantResult testCode;
					          nextPutAll:
						          ' resulted in a MessageNotUnderstood exception since ';
					          nextPutAll: error message selector;
					          nextPutAll: ' is not understood by an instance of ';
					          nextPutAll: error receiver class name;
					          nextPutAll:
						          '. Provide a better version based on the messages that object understands: '.
				          error receiver class selectors
					          do: [ :s | strm nextPutAll: s ]
					          separatedBy: [ strm nextPut: $, ] ] ]
		          ifFalse: [
			          String streamContents: [ :strm |
				          strm
					          nextPutAll:
						          'The code you have provided resulted in a the exception: ';
					          nextPutAll: error description;
					          nextPutAll: '. Provide a version that does not fail.' ] ].
	answer := assistant
		          clearPromptContext;
		          sendPrompt:
			          prompt
			          , ' Enclose the code between <test> and </test> tags'.
	code := (answer partTaggedWith: 'test') ifNil: [''].
	^ self tryTestCode: code trim
]
