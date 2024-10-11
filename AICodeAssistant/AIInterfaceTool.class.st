Class {
	#name : 'AIInterfaceTool',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'converting' }
AIInterfaceTool >> asJsonObject [

	^ self newJsonObject
		  at: 'type' put: self type;
		  yourself
]

{ #category : 'private' }
AIInterfaceTool >> newJsonObject [
	"Ugly code to ease migration to other dialects."

	^ (Smalltalk at: #NeoJSONObject) new 
]

{ #category : 'printing' }
AIInterfaceTool >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPut: $:;
		space;
		nextPutAll: name
]

{ #category : 'accessing' }
AIInterfaceTool >> type [
	self subclassResponsibility 
]
