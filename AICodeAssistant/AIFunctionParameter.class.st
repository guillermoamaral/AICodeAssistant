Class {
	#name : 'AIFunctionParameter',
	#superclass : 'Object',
	#instVars : [
		'name',
		'type',
		'description',
		'required'
	],
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'instance creation' }
AIFunctionParameter class >> name: aString type: anotherString description: otherString [

	^ self new
		  name: aString;
		  type: anotherString;
		  description: otherString;
		  yourself
]

{ #category : 'converting' }
AIFunctionParameter >> asJsonObject [

	^ self newJsonObject
		  at: 'type' put: type;
		  at: 'description' put: description;
		  yourself
]

{ #category : 'accessing' }
AIFunctionParameter >> description [

	^ description
]

{ #category : 'accessing' }
AIFunctionParameter >> description: aString [

	description := aString
]

{ #category : 'initialization' }
AIFunctionParameter >> initialize [

	super initialize.
	description := ''.
	required := false
]

{ #category : 'testing' }
AIFunctionParameter >> isRequired [

	^ required
]

{ #category : 'accessing' }
AIFunctionParameter >> name [

	^ name
]

{ #category : 'accessing' }
AIFunctionParameter >> name: aString [

	name := aString
]

{ #category : 'private' }
AIFunctionParameter >> newJsonObject [
	"Ugly code to ease migration to other dialects."

	^ (Smalltalk at: #NeoJSONObject) new
]

{ #category : 'accessing' }
AIFunctionParameter >> type [

	^ type
]

{ #category : 'accessing' }
AIFunctionParameter >> type: aString [

	type := aString
]
