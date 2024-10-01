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

{ #category : 'services' }
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

{ #category : 'services' }
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

{ #category : 'services' }
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

{ #category : 'services' }
AICodeAssistant >> useCodeContext: aString [

	promptContext := String streamContents: [ :strm |
		                 strm
			                 nextPutAll:
				                 'Consider a the follwing Smalltalk code:';
			                 cr;
			                 nextPutAll: aString ] 
]

{ #category : 'services' }
AICodeAssistant >> useMethodContext: aCompiledMethod [

	promptContext := String streamContents: [ :strm |
		                 strm
			                 nextPutAll:
				                 'Consider a the follwing Smalltalk method in class ';
			                 nextPutAll: aCompiledMethod classBinding name;
			                 cr;
			                 nextPutAll: aCompiledMethod sourceCode ]
]

{ #category : 'services' }
AICodeAssistant >> writeTestForCode: aString [

	self useCodeContext: aString.
	^ self sendPrompt:
		  'Write a unit test for the given code. Do use testX for test selector.
Your answer should be in correct Smalltalk in the following format:
<bug>if you think there iss a problem, describe it here</bug>
<thinking>your rational and explanation here, be brief</thinking>
<code>pure Smalltalk code for the test case</code>'
]

{ #category : 'services' }
AICodeAssistant >> writeTestForMethod: aCompiledMethod [

	self useMethodContext: aCompiledMethod.
	^ self sendPrompt:
		  'Write a unit test for the given method. Do use testX for test selector.
Your answer should be in correct Smalltalk in the following format:
<bug>if you think there is a problem, describe it here</bug>
<thinking>your rational and explanation here, be brief</thinking>
<code>pure Smalltalk code for the test case</code>'
]

{ #category : 'services' }
AICodeAssistant >> writeTestsForMethod: aCompiledMethod [

	self useMethodContext: aCompiledMethod.
	^ self sendPrompt:
		  'Write as many tests as you can for the given method. Do use testX for test selectors.
It is a good idea to generate one test cases for simple use cases, border conditions, different argument classes, etc.
Your answer should be in correct Smalltalk in the following format:
<bug>if you think there is a problem, describe it here</bug>
<thinking>your rational and explanation here, be brief</thinking>
<code>pure Smalltalk code for the test case</code> and enclose each particular test between <test> and </test>'
]
