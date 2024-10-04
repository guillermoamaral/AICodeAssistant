Class {
	#name : 'GroqInterface',
	#superclass : 'AIInterface',
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'accessing' }
GroqInterface class >> url [

	^ 'https://api.groq.com/openai/v1' asUrl
]

{ #category : 'accessing' }
GroqInterface >> defaultModel [

	^ 'llama-3.1-70b-versatile'
]
