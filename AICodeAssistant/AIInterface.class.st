"
This abstract class respresents an interface with known web AI APIs to interact with LLMs.
"
Class {
	#name : 'AIInterface',
	#superclass : 'Object',
	#instVars : [
		'client',
		'model',
		'key',
		'maxTokens',
		'temperature',
		'tools'
	],
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'accessing' }
AIInterface class >> url [
	self subclassResponsibility 
]

{ #category : 'accessing' }
AIInterface >> addTool: anAIInterfaceTool [

	tools add: anAIInterfaceTool
]

{ #category : 'accessing' }
AIInterface >> defaultModel [

	self subclassResponsibility
]

{ #category : 'messages' }
AIInterface >> get: uri [

	| data |
	data := client
		        setBearerAuthentication: key;
		        get: self url / uri.
	client isSuccess ifFalse: [ self error: client contents asString ].
	^ data
]

{ #category : 'initialization' }
AIInterface >> initialize [

	super initialize.
	self initializeClient.
	maxTokens := 3500.
	temperature := 0.
	model := self defaultModel.
	tools := OrderedCollection new
]

{ #category : 'initialization' }
AIInterface >> initializeClient [
	"Ugly code to ease migration to other dialects."

	client := (Smalltalk at: #ZnClient) new.
	client forJsonREST
]

{ #category : 'accessing' }
AIInterface >> key: anObject [

	key := anObject
]

{ #category : 'accessing' }
AIInterface >> model [

	^ model
]

{ #category : 'accessing' }
AIInterface >> model: aString [

	model := aString
]

{ #category : 'messages' }
AIInterface >> modelWithId: id [

	^ self get: '/models/' , id 
]

{ #category : 'messages' }
AIInterface >> models [

	^ self get: '/models'
]

{ #category : 'accessing' }
AIInterface >> name [
	
	^ self class name withoutSuffix: 'Interface'
]

{ #category : 'private' }
AIInterface >> newJsonObject [
	"Ugly code to ease migration to other dialects."
	
	^ (Smalltalk at: #NeoJSONObject) new
]

{ #category : 'private' }
AIInterface >> parseJson: aString [
	"Ugly code to ease migration to other dialects."

	^ (Smalltalk at: #NeoJSONReader) fromString: aString
]

{ #category : 'messages' }
AIInterface >> post: uri with: json [

	| data |
	data := client
		        setBearerAuthentication: key;
		        post: self url / uri contents: json.
	client isSuccess ifFalse: [ self error: client contents asString ].
	^ data
]

{ #category : 'accessing' }
AIInterface >> removeTools [

	tools removeAll
]

{ #category : 'messages' }
AIInterface >> sendMessages: aCollection [

	| body answer message name tool arguments response call |
	body := self newJsonObject.
	body
		at: 'model' put: model;
		at: 'messages' put: (aCollection collect: #asJsonObject);
		at: 'temperature' put: temperature;
		at: 'max_tokens' put: maxTokens.
	tools notEmpty ifTrue: [
		body at: 'tools' put: (tools collect: #asJsonObject) ].
	answer := self post: 'chat/completions' with: body.
	message := (answer at: 'choices') first at: 'message'.
	response := AICodeAssistantMessage assistantResponse:
		            (message at: 'content').
	((answer at: 'choices') first at: 'finish_reason') = 'tool_calls'
		ifTrue: [
			name := ((message at: 'tool_calls') first at: 'function') at:
				        'name'.
			tool := tools
				        detect: [ :t | t name = name ]
				        ifNone: [ self error: 'tool not found' ].
			arguments := self parseJson:
				             (((message at: 'tool_calls') first at: 'function')
					              at: 'arguments').
			call := AIToolCall new
				        id: ((message at: 'tool_calls') first at: 'id');
				        tool: tool;
				        arguments: arguments.
			response toolCall: call ].
	^ response
]

{ #category : 'messages' }
AIInterface >> sendPrompt: text [
	^self sendPrompt: text as: 'user'
]

{ #category : 'messages' }
AIInterface >> sendPrompt: text as: role [

	| message |
	message := self newJsonObject.
	message
		at: 'role' put: (role ifNil: [ 'user' ]);
		at: 'content' put: text.
	^ self sendMessages: { message }
]

{ #category : 'accessing' }
AIInterface >> url [
	^self class url
]
