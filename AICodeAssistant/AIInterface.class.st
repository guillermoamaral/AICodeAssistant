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
		'temperature'
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
AIInterface >> defaultModel [

	self subclassResponsibility
]

{ #category : 'requests' }
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
	model := self defaultModel
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

{ #category : 'requests' }
AIInterface >> modelWithId: id [

	^ self get: '/models/' , id 
]

{ #category : 'requests' }
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

{ #category : 'requests' }
AIInterface >> post: uri with: json [

	| data |
	data := client
		        setBearerAuthentication: key;
		        post: self url / uri contents: json.
	client isSuccess ifFalse: [ self error: client contents asString ].
	^ data
]

{ #category : 'requests' }
AIInterface >> sendMessages: aCollection [

	| body answer |
	body := self newJsonObject.
	body
		at: 'model' put: model;
		at: 'messages' put: aCollection;
		at: 'temperature' put: temperature;
		at: 'max_tokens' put: maxTokens.
	answer := self post: 'chat/completions' with: body.
	^ ((answer at: 'choices') first at: 'message') at: 'content'
]

{ #category : 'requests' }
AIInterface >> sendPrompt: text [
	^self sendPrompt: text as: 'user'
]

{ #category : 'requests' }
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
