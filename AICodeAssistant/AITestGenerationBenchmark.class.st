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
AITestGenerationBenchmark >> describeCompilationError: anError in: anAISuggestedMethod [

	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'Suggested test <test>';
			  nextPutAll: anAISuggestedMethod sourceCode;
			  nextPutAll: '</test>';
			  nextPutAll: ' could not be compiled due to this error: "';
			  nextPutAll: anError description;
			  nextPut: $" ]
]

{ #category : 'results' }
AITestGenerationBenchmark >> detailReportOfMethod: aCompiledMethod [

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
		self log: result status.
		self addResult: result ]
]

{ #category : 'initialization' }
AITestGenerationBenchmark >> initialize [

	super initialize.
	assistant beTestsGenerator
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

	| statuses counts n c p |
	statuses := AITestGenerationBenchmarkResult availableStatuses.
	counts := self statusCounts.
	n := results size.
	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'Test generation benchmark report';
			  cr;
			  cr;
			  nextPutAll: 'Tests generated: ';
			  nextPutAll: n asString;
			  cr;
			  nextPutAll: 'Result status distribution:'.
		  statuses do: [ :s |
			  c := counts at: s ifAbsent: [ 0 ].
			  p := (c / n * 100.0) rounded.
			  strm
				  crtab;
				  nextPutAll: s;
				  nextPutAll: ': ';
				  nextPutAll: c asString;
				  nextPutAll: ' (';
				  nextPutAll: p asString;
				  nextPutAll: '%)' ] ]
]

{ #category : 'results' }
AITestGenerationBenchmark >> reportByMethod [

	| statuses counts c n p |
	statuses := AITestGenerationBenchmarkResult availableStatuses.
	counts := self statusCountByMethod.
	^ String streamContents: [ :strm |
		  strm
			  nextPutAll: 'Detailed status by tested method';
			  cr.
		  targetMethods do: [ :m |
			  n := (counts at: m) at: #total.
			  strm
				  cr;
				  nextPutAll: m methodClass name;
				  nextPutAll: ' >> #';
				  nextPutAll: m selector;
				  cr;
				  nextPutAll: 'Tests generated: ';
				  nextPutAll: n asString.
			  statuses do: [ :s |
				  c := (counts at: m) at: s ifAbsent: [ 0 ].
				  p := (c / n * 100.0) rounded.
				  strm
					  crtab;
					  nextPutAll: s;
					  nextPutAll: ': ';
					  nextPutAll: c asString;
					  nextPutAll: ' (';
					  nextPutAll: p asString;
					  nextPutAll: '%)' ].
			  strm cr ].
		  strm cr ]
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
AITestGenerationBenchmark >> statusCountByMethod [
	"Returns the number of invalid, passed, failed and error result
	grouped by target method"

	| statuses grouped counts set k |
	statuses := AITestGenerationBenchmarkResult availableStatuses.
	grouped := Dictionary new.
	targetMethods do: [ :m |
		counts := Dictionary new.
		set := results select: [ :r | r testedMethod = m ].
		statuses do: [ :s |
			k := set count: [ :r | r status = s ].
			counts at: s put: k ].
		counts at: #total put: set size.
		grouped at: m put: counts ].
	^ grouped
]

{ #category : 'results' }
AITestGenerationBenchmark >> statusCounts [
	"Returns the number of invalid, passed, failed and error results."

	| counts k |
	counts := Dictionary new.
	AITestGenerationBenchmarkResult availableStatuses do: [ :s |
		k := results count: [ :r | r status = s ].
		counts at: s put: k ].
	^ counts
]

{ #category : 'results' }
AITestGenerationBenchmark >> statusPercentagesByMethodPlot [
	"This plot shows how generated tests, grouped by target method,
	distribute among invalid, passed, failed and error categories.
	Ugly code to ease migration to other dialects."

	| counts data cluster color plot c k |
	counts := self statusCountByMethod.
	AITestGenerationBenchmarkResult availableStatuses do: [ :s |
		data := targetMethods collect: [ :m |
			        c := (counts at: m) at: s.
			        k := (counts at: m) at: #total.
			        c * 100.0 / k ].
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

	| counts n cluster color plot |
	counts := self statusCounts.
	n := results size.
	counts keysAndValuesDo: [ :s :c |
		cluster := (Smalltalk at: #RSBarPlotNew) new data:
			           { (c / n * 100.0) }.
		color := self colorForStatus: s.
		cluster color: color.
		plot := plot ifNil: [ cluster ] ifNotNil: [ plot + cluster ] ].
	plot
		title:
			'Test generation efficiency (using ' , assistant interfaceName
			, ')';
		xlabel:
			' black = invalid, green = passed, orange = failed, red = error ';
		ylabel: '%'.
	^ plot
]

{ #category : 'parameters' }
AITestGenerationBenchmark >> targetMethods: aCollection [
	
		targetMethods := aCollection

]

{ #category : 'private' }
AITestGenerationBenchmark >> tryTest: anAISuggestedMethod [

	| result description suite testResult test |
	result := AITestGenerationBenchmarkResult new.
	result
		conversation: assistant messages copy;
		code: anAISuggestedMethod.
	anAISuggestedMethod ifNil: [ ^ result beInvalid ].
	self log:
		'Trying generated test #' , anAISuggestedMethod selector , '...'.
	[ anAISuggestedMethod install ]
		on: Error
		do: [ :e |
			description := self
				               describeCompilationError: e
				               in: anAISuggestedMethod.
			^ result beInvalid: description ].
	suite := anAISuggestedMethod realClass buildSuiteFromMethods:
		         { anAISuggestedMethod selector }.
	testResult := suite run.
	testResult hasPassed ifTrue: [ ^ result bePassed ].
	test := suite tests first.
	description := testResult hasErrors
		               ifTrue: [ assistant describeTestError: test ]
		               ifFalse: [ assistant describeTestFailure: test ].
	testResult hasErrors
		ifTrue: [ result beError: description ]
		ifFalse: [ result beFailed: description ].
	^ result
]

{ #category : 'private' }
AITestGenerationBenchmark >> tryToSolve: anAITestGenerationBenchmarkResult [

	| prompt tests |
	assistant clearPromptContext.
	prompt := anAITestGenerationBenchmarkResult description
	          , '. Provide another version that solves this.'.
	tests := (assistant requestTestsWith: prompt) methods.
	^ self tryTest: (tests notEmpty ifTrue: [ tests first ])
]
