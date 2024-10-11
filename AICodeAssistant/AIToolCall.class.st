Class {
	#name : 'AIToolCall',
	#superclass : 'Object',
	#instVars : [
		'id',
		'tool',
		'arguments'
	],
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'accessing' }
AIToolCall >> arguments [

	^ arguments
]

{ #category : 'accessing' }
AIToolCall >> arguments: anObject [

	arguments := anObject
]

{ #category : 'converting' }
AIToolCall >> asJsonObject [

	^ self newJsonObject
		  at: 'id' put: id;
		  at: 'type' put: tool type;
		  at: tool type put: (self newJsonObject
				   at: 'name' put: tool name;
				   at: 'arguments' put: arguments asString;
				   yourself);
		  yourself
]

{ #category : 'accessing' }
AIToolCall >> id [

	^ id
]

{ #category : 'accessing' }
AIToolCall >> id: anObject [

	id := anObject
]

{ #category : 'services' }
AIToolCall >> invoke [
	
	^ tool handler value: arguments 
]

{ #category : 'converting' }
AIToolCall >> newJsonObject [
	"Ugly code to ease migration to other dialects."

	^ (Smalltalk at: #NeoJSONObject) new
]

{ #category : 'accessing' }
AIToolCall >> tool [

	^ tool
]

{ #category : 'accessing' }
AIToolCall >> tool: anAIInterfaceTool [

	tool := anAIInterfaceTool
]
