Class {
	#name : 'AITestGenerationEffectiveness',
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
AITestGenerationEffectiveness >> canCompile: aString in: aClass [
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

{ #category : 'private' }
AITestGenerationEffectiveness >> generateTestsFor: aCompiledMethod [

	| result attempt answer |
	answer := assistant
		          clearHistory;
		          writeTestForMethod: aCompiledMethod.
	(answer partsTaggedWith: 'test') do: [ :code |
		result := self tryTestCode: code trim.
		result testedMethod: aCompiledMethod.
		attempt := 1.
		[ result hasError and: [ attempt < maxAttempts ] ] whileTrue: [
			result := self tryToOvercomeError: result.
			attempt := attempt + 1 ].
		results add: result ]
]

{ #category : 'initialization' }
AITestGenerationEffectiveness >> initialize [
	super initialize.
	numIterations := 5.
	maxAttempts := 2.
	assistant systemPrompt: self systemPrompt
]

{ #category : 'parameters' }
AITestGenerationEffectiveness >> maxAttempts: aNumber [

	maxAttempts := aNumber
]

{ #category : 'parameters' }
AITestGenerationEffectiveness >> numIterations: aNumber [

	numIterations := aNumber
]

{ #category : 'running' }
AITestGenerationEffectiveness >> run [
	"
	self new run
	"
	numIterations timesRepeat: [
		targetMethods do: [ :method | self generateTestsFor: method ] ]
]

{ #category : 'parameters' }
AITestGenerationEffectiveness >> systemPrompt [
	^'You are helping a user create test cases for a Smalltalk system.
Your task is to generate a test cases for the provided code.'
]

{ #category : 'parameters' }
AITestGenerationEffectiveness >> targetMethods: aCollection [
	
		targetMethods := aCollection

]

{ #category : 'private' }
AITestGenerationEffectiveness >> tryTestCode: aString [

	| result selector suite test testResult |
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
	testResult hasErrors ifTrue: [ ^ result halt beError: nil ].
	testResult hasFailures
		ifTrue: [ result beFailed ]
		ifFalse: [ result bePassed ]. 
	^ result
]

{ #category : 'private' }
AITestGenerationEffectiveness >> tryToOvercomeError: anAITestAssistantResult [

	| error prompt answer parts code |
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
	parts := answer partsTaggedWith: 'test'.
	code := parts notEmpty ifTrue: [ parts anyOne ]. 
	^ self tryTestCode: code
]
