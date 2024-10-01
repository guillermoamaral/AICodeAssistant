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
AITestGenerationEffectiveness >> generateTestFor: aCompiledMethod [

	| result attempt |
	assistant clearHistory; writeTestForMethod: aCompiledMethod.
	result := self tryToUseGeneratedTest.
	attempt := 1.
	[ result hasError and: [ attempt < maxAttempts ] ] whileTrue: [
		result := self tryToOvercomeError: result.
		attempt := attempt + 1 ].
	(results at: aCompiledMethod ifAbsentPut: [ OrderedCollection new ])
		add: result
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

	numIterations timesRepeat: [
	targetMethods do: [ :method | self generateTestFor: method ] ]
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
AITestGenerationEffectiveness >> testClassFor: aCompiledMethod [

	| class classname |
	class := aCompiledMethod methodClass.
	[ class == Object ] whileFalse: [
		| tc |
		classname := class name , 'Test'.
		tc := Smalltalk classNamed: classname.
		tc ifNotNil: [ ^ tc ].
		class := class superclass ].
	^ TestCase
]

{ #category : 'private' }
AITestGenerationEffectiveness >> tryToUseGeneratedTestOn: aClass [
	| result parts code class method suite test |
	result := AITestGenerationResult new conversation: assistant messages copy.
	parts := assistant lastMessage partsTaggedWith: 'code'.
	code := parts notEmpty ifTrue: [ parts anyOne ] ifFalse: [^result beInvalid ].
	class := self testClassFor: aClass.
	(self canCompile: code in: class) ifFalse: [^result beInvalid].
	method := class compile: 'test_AiGenerated_' , code.
	result test: method.
	suite := TestSuite named: method selector.
	test := class selector: method selector.
	suite addTest: test.
	result := suite run.
	result hasErrors
		ifTrue: [^result beError: nil].
	result hasFailures ifTrue: [result beFailed] ifFalse: [result bePassed].
	^result
]
