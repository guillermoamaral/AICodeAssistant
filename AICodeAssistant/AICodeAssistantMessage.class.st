Class {
	#name : 'AICodeAssistantMessage',
	#superclass : 'Object',
	#instVars : [
		'content',
		'role'
	],
	#category : 'AICodeAssistant-Base',
	#package : 'AICodeAssistant',
	#tag : 'Base'
}

{ #category : 'instance creation' }
AICodeAssistantMessage class >> assistantResponse: aString [

	^ self new
		  content: aString;
		  role: 'assistant'
]

{ #category : 'instance creation' }
AICodeAssistantMessage class >> systemPrompt: aString [

	^ self new
		  content: aString;
		  role: 'system'
]

{ #category : 'instance creation' }
AICodeAssistantMessage class >> userPrompt: aString [

	^ self new
		  content: aString;
		  role: 'user'
]

{ #category : 'converting' }
AICodeAssistantMessage >> asJsonObject [
	^NeoJSONObject new
		at: 'role' put: role;
		at: 'content' put: content;
		yourself
]

{ #category : 'accessing' }
AICodeAssistantMessage >> content [

	^ content
]

{ #category : 'accessing' }
AICodeAssistantMessage >> content: aString [

	content := aString
]

{ #category : 'initialization' }
AICodeAssistantMessage >> initialize [
	super initialize.
	role := 'user'
]

{ #category : 'printing' }
AICodeAssistantMessage >> printOn: aStream [
	aStream
		nextPutAll: role;
		nextPut: $:;
		space;
		nextPutAll: content
]

{ #category : 'accessing' }
AICodeAssistantMessage >> role [

	^ role
]

{ #category : 'accessing' }
AICodeAssistantMessage >> role: aString [

	role := aString
]
