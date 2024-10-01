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

{ #category : 'services' }
AICodeAssistantMessage >> partsTaggedWith: tag [

	| parts stream opening closing i j |
	parts := OrderedCollection new.
	stream := content readStream.
	opening := '<' , tag , '>'.
	closing := '</' , tag , '>'.
	i := content indexOfSubCollection: opening startingAt: 1.
	[ i > 0 ] whileTrue: [
		i := i + opening size.
		j := content indexOfSubCollection: closing startingAt: i.
		j > 0
			ifTrue: [
				parts add: (content copyFrom: i to: j - 1).
				i := content
					     indexOfSubCollection: opening
					     startingAt: j + closing size ]
			ifFalse: [ i := 0 ] ].
	^ parts
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
