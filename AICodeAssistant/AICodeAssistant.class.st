"
This is the main object of the framework and it is aimed at providing handy AI-based services such as:

- Explain a given piece of code (source, method)
- Categorize methods
- Generate tests from a given piece of code (source, method, class)
- Generate code from a given test suite (that honors such tests)
- more
"
Class {
	#name : 'AICodeAssistant',
	#superclass : 'Object',
	#instVars : [
		'interface',
		'messages',
		'systemPrompt',
		'promptContext'
	],
	#category : 'AICodeAssistant-Base',
	#package : 'AICodeAssistant',
	#tag : 'Base'
}

{ #category : 'context' }
AICodeAssistant >> addClassContext: aClass [
	| context |
	context := String streamContents: [:strm | 
		strm nextPutAll: 'Consider a class named '; nextPutAll: aClass name.
		aClass comment notEmpty
			ifTrue: [strm
				nextPutAll: ' with this comment:';
				cr;
				nextPutAll: aClass comment].
		strm
			nextPutAll: ' and the following definition';
			cr;
			nextPutAll: aClass definitionString].
	promptContext := promptContext , context
]

{ #category : 'initialization' }
AICodeAssistant >> addContextsFrom: aString [
	"the idea here is to extend promptContext with:
		- class definitions from @[classname]
		- methods from @[classname]#selector
	found in aString"
]

{ #category : 'context' }
AICodeAssistant >> addMethodContext: aCompiledMethod [

	| context |
	context := String streamContents: [ :strm |
		           strm
			           nextPutAll: 'Consider a method in a class ';
			           nextPutAll: aCompiledMethod classBinding name;
			           nextPutAll: ' with selector #';
			           nextPutAll: aCompiledMethod selector;
			           nextPutAll: ' and with the follwing code:';
			           cr;
			           nextPutAll: aCompiledMethod sourceCode ].
	promptContext := promptContext , context
]

{ #category : 'context' }
AICodeAssistant >> addMethodsContext: aClass [

	| context |
	context := String streamContents: [ :strm |
		           strm
			           nextPutAll: 'Consider the class ';
			           nextPutAll: aClass name;
			           nextPutAll: ' which defines the following methods: ';
			           cr.
		           aClass methodDictionary
			           do: [ :m | strm nextPutAll: m sourceCode ]
			           separatedBy: [ strm cr ] ].
	promptContext := promptContext , context
]

{ #category : 'accessing' }
AICodeAssistant >> beCodeFromTestsGenerator [
	self systemPrompt: self systemPromptForCodeFromTestGeneration 
]

{ #category : 'accessing' }
AICodeAssistant >> beTestsGenerator [

	self systemPrompt: self systemPromptForTestGeneration
]

{ #category : 'actions' }
AICodeAssistant >> clearHistory [
	self initializeMessages
]

{ #category : 'accessing' }
AICodeAssistant >> clearPromptContext [
	promptContext := ''
]

{ #category : 'initialization' }
AICodeAssistant >> defaultInterface [

	^OpenAIInterface new model: 'chatgpt-4o-latest'
]

{ #category : 'accessing' }
AICodeAssistant >> defaultSystemPrompt [

	^ 'You are an expert Smalltalk programmer.
When I ask for help to analyze, explain or write Smalltalk code, you will reply accordingly.
In your response you will avoid using the words ''Smalltalk'' and ''snippet''.'
]

{ #category : 'services' }
AICodeAssistant >> explainCode: aString [

	self useCodeContext: aString.
	^ self sendPrompt: 'Explain the given code.'
]

{ #category : 'services' }
AICodeAssistant >> explainMethod: aCompiledMethod [

	self useMethodContext: aCompiledMethod.
	^ self sendPrompt:
		  'Explain the given method'
]

{ #category : 'services' }
AICodeAssistant >> improveCode: aString [

	self useCodeContext: aString.
	^ self sendPrompt: 'Improve the given code.'
]

{ #category : 'services' }
AICodeAssistant >> improveMethod: aCompiledMethod [
	
	self useMethodContext: aCompiledMethod.
	^ self sendPrompt: 'Improve the given method'
]

{ #category : 'initialization' }
AICodeAssistant >> initialize [

	super initialize.
	interface := self defaultInterface.
	systemPrompt := self defaultSystemPrompt.
	self initializeMessages.
	promptContext := ''
]

{ #category : 'initialization' }
AICodeAssistant >> initializeInterface [
 	interface := OpenAIInterface new.
	interface model: 'chatgpt-4o-latest'.
	
]

{ #category : 'initialization' }
AICodeAssistant >> initializeMessages [

	| message |
	message := AICodeAssistantMessage systemPrompt: systemPrompt.
	messages := OrderedCollection with: message
]

{ #category : 'accessing' }
AICodeAssistant >> interface [

	^ interface
]

{ #category : 'accessing' }
AICodeAssistant >> interface: anAIInterface [

	interface := anAIInterface
]

{ #category : 'accessing' }
AICodeAssistant >> interfaceName [

	^ interface name
]

{ #category : 'accessing' }
AICodeAssistant >> lastMessage [

	^ messages last
]

{ #category : 'accessing' }
AICodeAssistant >> messages [
	^messages
]

{ #category : 'accessing' }
AICodeAssistant >> promptContext: aString [
	promptContext := aString
]

{ #category : 'private' }
AICodeAssistant >> sendMessage: aCodeAssistantMessage [

	| answer response |
	messages add: aCodeAssistantMessage.
	answer := interface sendMessages: (messages collect: #asJsonObject).
	response := AICodeAssistantMessage assistantResponse: answer.
	messages add: response.
	^ response
]

{ #category : 'actions' }
AICodeAssistant >> sendPrompt: aString [

	| message prompt |
	self addContextsFrom: aString.
	prompt := String streamContents: [ :strm |
		          strm
			          nextPutAll: promptContext;
			          cr;
			          nextPutAll: aString ].
	message := AICodeAssistantMessage userPrompt: prompt.
	^ self sendMessage: message
]

{ #category : 'accessing' }
AICodeAssistant >> systemPrompt [

	^ systemPrompt
]

{ #category : 'accessing' }
AICodeAssistant >> systemPrompt: aString [

	systemPrompt := aString
]

{ #category : 'private' }
AICodeAssistant >> systemPromptForCodeFromTestGeneration [

	^ 'You are helping a user create Smalltalk code based on a given set of test cases the class should honor.
Your task is to generate one or more classes with their methods such that the provided tests pass.
If you find any issue when generating code do say it.'
]

{ #category : 'private' }
AICodeAssistant >> systemPromptForTestGeneration [

	^ 'You are helping a user create test cases for a Smalltalk system.
Your task is to generate a test cases for the provided code.'
]

{ #category : 'context' }
AICodeAssistant >> useCodeContext: aString [

	promptContext := String streamContents: [ :strm |
		                 strm
			                 nextPutAll:
				                 'Consider a the follwing Smalltalk code:';
			                 cr;
			                 nextPutAll: aString ] 
]

{ #category : 'context' }
AICodeAssistant >> useMethodContext: aCompiledMethod [

	promptContext := String streamContents: [ :strm |
		                 strm
			                 nextPutAll:
				                 'Consider a the follwing Smalltalk method in class ';
			                 nextPutAll: aCompiledMethod classBinding name;
			                 cr;
			                 nextPutAll: aCompiledMethod sourceCode ]
]

{ #category : 'context' }
AICodeAssistant >> useTestsContext: aTestSuite [

	promptContext := String streamContents: [ :strm |
		                 strm
			                 nextPutAll:
				                 'Consider the following tests in the form: <test>test code here</test>.';
			                 cr.
		                 aTestSuite tests
			                 do: [ :test |
				                 strm
					                 nextPutAll: '<test>';
					                 nextPutAll:
						                 (test class >> test selector) sourceCode;
					                 nextPutAll: '</test>' ]
			                 separatedBy: [ strm cr ] ]
]

{ #category : 'services' }
AICodeAssistant >> writeCodeFromTests: aTestSuite [

	| answer parts name class |
	self useTestsContext: aTestSuite.
	answer := self sendPrompt:
		          'Provide Smalltalk code that passes given tests.
You answer should be in correct Smalltalk in the following format:
<issue>if you think there''''s a problem, describe it here</issue>
<thinking>your rational and explanation here, be brief</thinking>
<code>
	<class>
		<superclass>Smalltalk superclass name here</superclass>
		<name>Smalltalk class name here</name>
		<instanceVariables>Instance variables here, space-separated</instanceVariables>
		<classVariables>Class variables here, space-separated</instanceVariables>
		<method>Smalltalk method code here; avoid including the class and >> before the selector</method>
		<method>Smalltalk method code here; avoid including the class and >> before the selector</method>
		<method>Smalltalk method code here; avoid including the class and >> before the selector</method>
		...
	</class>
</code>
repeating <class> for each class you define, and <method> for every method you define in every class'''.
	parts := answer partsTaggedWith: 'class'.
	parts notEmpty ifTrue: [
		^ parts collect: [ :body |
			  name := answer partTaggedWith: 'name' in: body.
			  class := AISuggestedClass named: name.
			  (answer partTaggedWith: 'superclass' in: body) ifNotNil: [ :n |
				  class superclassName: n ].
			  (answer partTaggedWith: 'instanceVariables' in: body) ifNotNil: [
				  :vars | class instanceVariableNames: (vars substrings: ' ') ].
			  (answer partsTaggedWith: 'method' in: body) do: [ :code |
				  class addMethod: (AISuggestedMethod new sourceCode: code trim) ].
			  class ] ].
	(answer partTaggedWith: 'issue') ifNotNil: [ :issue | ^ issue ].
	^ (answer partTaggedWith: 'thinking') ifNil: [ answer content ]
]

{ #category : 'services' }
AICodeAssistant >> writeTestForCode: aString [

	| answer class |
	self useCodeContext: aString.
	answer := self sendPrompt: 'Write a unit test for the given code.
Do use testX for test selector and avoid including the class and >> before the selector. 
Your answer should be in correct Smalltalk in the following format:
<bug>if you think there iss a problem, describe it here</bug>
<thinking>your rational and explanation here, be brief</thinking>
<test>pure Smalltalk code for the test case</test>'.
	(answer partTaggedWith: 'test') ifNotNil: [ :test |
		class := AISuggestedClass named: 'TestCase'.
		^ AISuggestedMethod new
			  suggestedClass: class;
			  sourceCode: test trim ].
	(answer partTaggedWith: 'bug') ifNotNil: [ :bug | ^ bug ].
	^ (answer partTaggedWith: 'thinking') ifNil: [ answer content ]
]

{ #category : 'services' }
AICodeAssistant >> writeTestForMethod: aCompiledMethod [

	| answer class |
	self useMethodContext: aCompiledMethod.
	answer := self sendPrompt:
		          'Write a unit test, only one unit test, for the given method.
Do use testX for test selector and avoid including the class and >> before the selector. 
Your answer should be in correct Smalltalk in the following format:
<bug>if you think there is a problem, describe it here</bug>
<thinking>your rational and explanation here, be brief</thinking>
<test>pure Smalltalk code for the test case, without any ```marks</test>'.
	(answer partTaggedWith: 'test') ifNotNil: [ :test |
		class := AISuggestedClass named: 'TestCase'.
		^ AISuggestedMethod new
			  suggestedClass: class;
			  sourceCode: test trim ].
	(answer partTaggedWith: 'bug') ifNotNil: [ :bug | ^ bug ].
	^ (answer partTaggedWith: 'thinking') ifNil: [ answer content ]
]

{ #category : 'services' }
AICodeAssistant >> writeTestsForMethod: aCompiledMethod [

	| answer class parts |
	self useMethodContext: aCompiledMethod.
	answer := self sendPrompt:
		          'Write as many tests as you can for the given method.
Do use testX for test selector and avoid including the class and >> before the selector.
It is a good idea to generate one test cases for simple use cases, border conditions, different argument classes, etc.
Your answer should be in correct Smalltalk in the following format:
<bug>if you think there is a problem, describe it here</bug>
<thinking>your rational and explanation here, be brief</thinking>
Enclose each test between <test> and </test>, just pure Smalltalk code without any ``` marks.'.
	parts := answer partsTaggedWith: 'test'.
	parts notEmpty ifTrue: [
		class := AISuggestedClass named: 'TestCase'.
		^ parts collect: [ :test |
			  AISuggestedMethod new
				  suggestedClass: class;
				  sourceCode: test trim ] ].
	(answer partTaggedWith: 'bug') ifNotNil: [ :bug | ^ bug ].
	^ (answer partTaggedWith: 'thinking') ifNil: [ answer content ]
]
