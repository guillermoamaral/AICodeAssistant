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
AITestGenerationBenchmark >> colorForStatus: aSymbol [

	^ aSymbol = #invalid
		  ifTrue: [ Color black ]
		  ifFalse: [
			  aSymbol = #passed
				  ifTrue: [ Color green ]
				  ifFalse: [
					  aSymbol = #failed
						  ifTrue: [ Color orange ]
						  ifFalse: [ Color red ] ] ]
]

{ #category : 'private' }
AITestGenerationBenchmark >> describeCompilationError: anError in: aString [

	| mention |
	^ String streamContents: [ :strm |
		  mention := self mentionTestCode: aString.
		  strm
			  nextPutAll: mention;
			  nextPutAll: ' could not be compiled due to this error: "';
			  nextPutAll: anError description;
			  nextPut: $" ]
]

{ #category : 'private' }
AITestGenerationBenchmark >> describeTestError: anError in: aString [

	| mention description |
	^ String streamContents: [ :strm |
		  mention := self mentionTestCode: aString.
		  description := self describeError: anError.
		  strm
			  nextPutAll: mention;
			  nextPutAll: ' resulted in ';
			  nextPutAll: description;
			  cr;
			  nextPutAll:
				  'Provide a version that does not fall into this error.' ]
]

{ #category : 'private' }
AITestGenerationBenchmark >> describeTestFailure: aTestFailure in: aString [
	"We need to provide better description based on the concrete assertion that triggered the failure..."

	| mention |
	^ String streamContents: [ :strm |
		  mention := self mentionTestCode: aString.
		  strm
			  nextPutAll: mention;
			  nextPutAll: ' resulted in the following failure: ';
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

{ #category : 'private' }
AITestGenerationBenchmark >> mentionTestCode: aString [

	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'The suggested test <test>';
			  nextPutAll: aString;
			  nextPutAll: '</test>' ]
]

{ #category : 'results' }
AITestGenerationBenchmark >> recoveryPercentage [
	"Returns the percentage of results that passed after failing
	(i.e., the AI could recover itself and propose a better version)."

	| recovered |
	recovered := results count: [ :r |
		             r hasPassed and: [ r conversation size > 3 ] ].
	^ recovered / results size asFloat
]

{ #category : 'results' }
AITestGenerationBenchmark >> recoveryPlot [
	"This plot shows the percentage of results that passed after failing
	(i.e., the AI could recover itself and propose a better version).
	There is no pie plots!"

	
]

{ #category : 'results' }
AITestGenerationBenchmark >> report [

	| statuses percentages |
	statuses := AITestGenerationBenchmarkResult availableStatuses.
	percentages := self statusPercentages.
	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'Test generation benchmark report';
			  cr;
			  nextPutAll: 'Overall status percentages:'.
		  statuses do: [ :s |
			  strm
				  crtab;
				  nextPutAll: s;
				  nextPutAll: ': ';
				  nextPutAll:
					  ((percentages at: s ifAbsent: [ 0 ]) * 100) rounded asString;
				  nextPut: $% ] ]
]

{ #category : 'results' }
AITestGenerationBenchmark >> reportByMethod [

	| statuses percentages |
	statuses := AITestGenerationBenchmarkResult availableStatuses.
	percentages := self statusPercentagesByMethod.
	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'Detailed status percentages by tested method';
			  cr.
		  targetMethods do: [ :m |
			  strm
				  cr;
				  nextPutAll: m methodClass name;
				  nextPutAll: ' >> #';
				  nextPutAll: m selector;
				  cr.
			  statuses do: [ :s |
				  strm
					  crtab;
					  nextPutAll: s;
					  nextPutAll: ': ';
					  nextPutAll:
						  (((percentages at: m) at: s ifAbsent: [ 0 ]) * 100) rounded
							  asString;
					  nextPut: $% ].
			  strm cr ] ]
]

{ #category : 'results' }
AITestGenerationBenchmark >> reportOf: aCompiledMethod [

	| separation index conversation |
	separation := '===================================================================================================='.
	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'Conversations around method ';
			  nextPutAll: aCompiledMethod methodClass name;
			  nextPutAll: ' >> #';
			  nextPutAll: aCompiledMethod selector;
			  cr;
			  nextPutAll:
				  'To reduce the length of the resport, system prompt and first user prompt are only shown in the first conversation.'.
		  index := 1.
		  results
			  select: [ :r | r testedMethod = aCompiledMethod ]
			  thenDo: [ :r |
				  strm
					  cr;
					  cr;
					  nextPutAll: separation;
					  cr;
					  nextPutAll: 'Conversation #';
					  nextPutAll: index asString;
					  cr;
					  nextPutAll: separation.
				  conversation := r conversation.
				  index > 1 ifTrue: [
					  conversation := conversation copyFrom: 3 to: conversation size ].
				  conversation do: [ :m |
					  strm cr.
					  m printOn: strm ].
				  strm
					  cr;
					  nextPutAll: 'Result of conversation #';
					  nextPutAll: index asString;
					  nextPutAll: ': ';
					  nextPutAll: r status;
					  cr;
					  nextPutAll: separation.
				  index := index + 1 ] ]
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
AITestGenerationBenchmark >> showPlots [

	self statusPercentagesPlot open.
	self statusPercentagesByMethodPlot open
]

{ #category : 'results' }
AITestGenerationBenchmark >> statusPercentages [
	"Returns the percentages of invalid, passed, failed and error results."

	| efficiency k |
	efficiency := Dictionary new.
	AITestGenerationBenchmarkResult availableStatuses do: [ :s |
		k := results count: [ :r | r status = s ].
		efficiency at: s put: k asFloat / results size ].
	^ efficiency
]

{ #category : 'results' }
AITestGenerationBenchmark >> statusPercentagesByMethod [
	"Returns the percentages of invalid, passed, failed and error result
	grouped by target method"

	| statuses grouped percentages set k |
	statuses := AITestGenerationBenchmarkResult availableStatuses.
	grouped := Dictionary new.
	targetMethods do: [ :m |
		percentages := Dictionary new.
		set := results select: [ :r | r testedMethod = m ].
		statuses do: [ :s |
			k := set count: [ :r | r status = s ].
			percentages at: s put: k asFloat / set size ].
		grouped at: m put: percentages ].
	^ grouped
]

{ #category : 'results' }
AITestGenerationBenchmark >> statusPercentagesByMethodPlot [
	"This plot shows how generated tests, grouped by target method,
	distribute among invalid, passed, failed and error categories.
	Ugly code to ease migration to other dialects."

	| percentages data cluster color plot |
	percentages := self statusPercentagesByMethod.
	AITestGenerationBenchmarkResult availableStatuses do: [ :s |
		data := targetMethods collect: [ :m | (percentages at: m) at: s ].
		cluster := (Smalltalk at: #RSBarPlotNew) new data: data.
		color := self colorForStatus: s.
		cluster color: color.
		plot := plot ifNil: [ cluster ] ifNotNil: [ plot + cluster ] ].
	plot
		title: 'Test generation efficiency by method (using '
			, assistant interfaceName , ')';
		xlabel:
			' black = invalid, green = passed, orange = failed, red = error ';
		xTickLabels: (targetMethods collect: #selector).
	^ plot
]

{ #category : 'results' }
AITestGenerationBenchmark >> statusPercentagesPlot [
	"This plot shows how generated tests distribute among invalid,
	passed, failed and error categories.
	Ugly code to ease migration to other dialects."

	| percentages cluster color plot |
	percentages := self statusPercentages.
	percentages keysAndValuesDo: [ :s :p |
		cluster := (Smalltalk at: #RSBarPlotNew) new data: { p }.
		color := self colorForStatus: s.
		cluster color: color.
		plot := plot ifNil: [ cluster ] ifNotNil: [ plot + cluster ] ].
	plot
		title:
			'Test generation efficiency (using ' , assistant interfaceName
			, ')';
		xlabel:
			' black = invalid, green = passed, orange = failed, red = error '.
	^ plot
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
	testResult hasPassed ifTrue: [ ^ result bePassed ].
	[ suite tests first runCase ]
		on: Exception
		do: [ :e | exception := e ].
	testResult hasErrors ifTrue: [
		description := self describeTestError: exception in: code.
		^ result beError: description ].
	description := self describeTestFailure: exception in: code.
	^ result beFailed: description
]

{ #category : 'private' }
AITestGenerationBenchmark >> tryToSolve: anAITestGenerationBenchmarkResult [

	| tests |
	assistant clearPromptContext.
	tests := (assistant requestTestsWith:
		          anAITestGenerationBenchmarkResult description) methods.
	^ self tryTest: (tests notEmpty ifTrue: [ tests first ])
]
