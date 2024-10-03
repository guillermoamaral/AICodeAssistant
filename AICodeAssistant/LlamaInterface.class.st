Class {
	#name : 'LlamaInterface',
	#superclass : 'AIInterface',
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'accessing' }
LlamaInterface class >> url [

	^ 'https://api.llama-api.com' asUrl
]

{ #category : 'accessing' }
LlamaInterface >> defaultModel [

	^'llama3.2-3b'
]

{ #category : 'requests' }
LlamaInterface >> sendMessages: aCollection [

	| body answer |
	body := NeoJSONObject new.
	body
		at: 'model' put: model;
		at: 'messages' put: aCollection.
	answer := self post: 'chat/completions' with: body.
	^ ((answer at: 'choices') first at: 'message') at: 'content'
]
