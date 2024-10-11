"
This object represents the messages exchanged between an AICodeAssistant and the underliing AIInterface.
"
Class {
	#name : 'AICodeAssistantMessage',
	#superclass : 'Object',
	#instVars : [
		'role',
		'content',
		'tags',
		'toolCall'
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
AICodeAssistantMessage class >> toolResult: aString [

	^ self new
		  content: aString;
		  role: 'tool'
]

{ #category : 'instance creation' }
AICodeAssistantMessage class >> userPrompt: aString [

	^ self new
		  content: aString;
		  role: 'user'
]

{ #category : 'converting' }
AICodeAssistantMessage >> asJsonObject [

	| json |
	json := self newJsonObject.
	json
		at: 'role' put: role;
		at: 'content' put: self content.
	toolCall ifNotNil: [
		role = 'tool'
			ifTrue: [ json at: 'tool_call_id' put: toolCall id ]
			ifFalse: [ json at: 'tool_calls' put: { toolCall asJsonObject } ] ].
	^ json
]

{ #category : 'accessing' }
AICodeAssistantMessage >> content [

	(content isNil and: [ toolCall notNil ]) ifTrue: [
		^ 'Tool call: ' , toolCall tool name ].
	^ content
]

{ #category : 'accessing' }
AICodeAssistantMessage >> content: aString [

	content := aString
]

{ #category : 'testing' }
AICodeAssistantMessage >> hasToolCall [

	^ toolCall notNil	
]

{ #category : 'initialization' }
AICodeAssistantMessage >> initialize [

	super initialize.
	role := 'user'.
	tags := OrderedCollection new
]

{ #category : 'services' }
AICodeAssistantMessage >> invokeTool [

	^ toolCall invoke
]

{ #category : 'private' }
AICodeAssistantMessage >> newJsonObject [
	"Ugly code to ease migration to other dialects."

	^ (Smalltalk at: #NeoJSONObject) new
]

{ #category : 'services' }
AICodeAssistantMessage >> partTaggedWith: tag [

	| parts |
	parts := self partsTaggedWith: tag.
	^ parts notEmpty ifTrue: [ parts first ]
]

{ #category : 'services' }
AICodeAssistantMessage >> partTaggedWith: tag in: aString [

	| parts |
	parts := self partsTaggedWith: tag in: aString.
	^ parts notEmpty ifTrue: [ parts first ]
]

{ #category : 'services' }
AICodeAssistantMessage >> partsTaggedWith: tag [

	^ self partsTaggedWith: tag in: content
]

{ #category : 'services' }
AICodeAssistantMessage >> partsTaggedWith: tag in: aString [

	| parts opening closing i j |
	parts := OrderedCollection new.
	opening := '<' , tag , '>'.
	closing := '</' , tag , '>'.
	i := aString indexOfSubCollection: opening startingAt: 1.
	[ i > 0 ] whileTrue: [
		i := i + opening size.
		j := aString indexOfSubCollection: closing startingAt: i.
		j > 0
			ifTrue: [
				parts add: (aString copyFrom: i to: j - 1).
				i := aString
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
		nextPutAll: self content
]

{ #category : 'accessing' }
AICodeAssistantMessage >> role [

	^ role
]

{ #category : 'accessing' }
AICodeAssistantMessage >> role: aString [

	role := aString
]

{ #category : 'services' }
AICodeAssistantMessage >> taggedContent [

	| tagged parts |
	tagged := Dictionary new.
	tags do: [ :tag |
		parts := self partsTaggedWith: tag.
		tagged at: tag put: parts ].
	^ tagged
]

{ #category : 'accessing' }
AICodeAssistantMessage >> tags [

	^ tags 
]

{ #category : 'accessing' }
AICodeAssistantMessage >> tags: aCollection [

	tags := aCollection
]

{ #category : 'accessing' }
AICodeAssistantMessage >> toolCall [

	^ toolCall
]

{ #category : 'accessing' }
AICodeAssistantMessage >> toolCall: anAIToolCall [

	toolCall := anAIToolCall
]
