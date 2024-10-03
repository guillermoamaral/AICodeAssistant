Class {
	#name : 'OpenAIInterface',
	#superclass : 'AIInterface',
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'accessing' }
OpenAIInterface class >> url [

	^ 'https://api.openai.com/v1' asUrl
]

{ #category : 'acccessing' }
OpenAIInterface >> defaultModel [

	^ 'chatgpt-4o-latest'
]

{ #category : 'initialization' }
OpenAIInterface >> initializeClient [
	
	super initializeClient.
	client timeout: 120
]
