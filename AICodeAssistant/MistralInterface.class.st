Class {
	#name : 'MistralInterface',
	#superclass : 'AIInterface',
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'acccessing' }
MistralInterface class >> url [

	^ 'https://api.mistral.ai/v1' asUrl
]

{ #category : 'accessing' }
MistralInterface >> defaultModel [

	 ^'pixtral-12b-latest'
]

{ #category : 'initialization' }
MistralInterface >> initializeClient [
	
	super initializeClient.
	client timeout: 120
]
