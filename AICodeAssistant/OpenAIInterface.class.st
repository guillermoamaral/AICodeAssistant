Class {
	#name : 'OpenAIInterface',
	#superclass : 'AIInterface',
	#instVars : [
		'maxTokens',
		'temperature'
	],
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'accessing' }
OpenAIInterface class >> url [

	^ 'https://api.openai.com/v1' asUrl
]

{ #category : 'initialization' }
OpenAIInterface >> initialize [

	super initialize.
	model := 'chatgpt-4o-latest'.
	maxTokens := 3500.
	temperature := 0
]

{ #category : 'initialization' }
OpenAIInterface >> initializeClient [
	
	super initializeClient.
	client timeout: 30
]

{ #category : 'requests' }
OpenAIInterface >> sendMessages: aCollection [

	| body answer |
	body := NeoJSONObject new.
	body
		at: 'model' put: model;
		at: 'messages' put: aCollection;
		at: 'temperature' put: temperature;
		at: 'max_tokens' put: maxTokens.
	answer := self post: 'chat/completions' with: body.
	^ ((answer at: 'choices') first at: 'message') at: 'content'
]

{ #category : 'requests' }
OpenAIInterface >> sendPrompt: text [
	^self sendPrompt: text as: 'user'
]

{ #category : 'requests' }
OpenAIInterface >> sendPrompt: text as: role [
	| message |
	message := NeoJSONObject new.
	message
		at: 'role' put: (role ifNil: ['user']);
		at: 'content' put: text.
	^self sendMessages: {message}
]
