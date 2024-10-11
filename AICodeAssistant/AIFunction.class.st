Class {
	#name : 'AIFunction',
	#superclass : 'AIInterfaceTool',
	#instVars : [
		'description',
		'parameters',
		'unit',
		'handler'
	],
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'instance creation' }
AIFunction class >> searchImplementors [
	"
	AIFunction searchImplementors
	"

	^ self new
		  name: 'search_implementors';
		  description:
			  'Search implementors of a given selector. Call this whenever you need to know what are the methods implementing a given message, for example when a customer asks ''What are the implementors of <selector>''';
		  addStringParameter: 'selector'
		  description:
			  'The selector that the user would like to search implementors for';
		  handler: [ :args |
			  String streamContents: [ :strm |
					  (args at: 'selector') asSymbol implementors do: [ :m |
							  strm nextPutAll: m asString ] ] ];
		  yourself
]

{ #category : 'accessing' }
AIFunction >> addParameter: anAIFunctionParameter [

	parameters add: anAIFunctionParameter
]

{ #category : 'services' }
AIFunction >> addStringParameter: aString description: anotherString [

	| parameter |
	parameter := AIFunctionParameter name: aString type: 'string' description: anotherString.
	self addParameter: parameter
]

{ #category : 'converting' }
AIFunction >> asJsonObject [

	| params properties function |
	params := self newJsonObject.
	parameters notEmpty ifTrue: [
		properties := self newJsonObject.
		parameters do: [ :p | properties at: p name put: p asJsonObject ].
		params
			at: 'type' put: 'object';
			at: 'properties' put: properties;
			at: 'required'
			put: (parameters select: #isRequired thenCollect: #name) ].
	function := self newJsonObject.
	function
		at: 'name' put: name;
		at: 'description' put: description;
		at: 'parameters' put: params.
	unit ifNotNil: [ function at: 'unit' put: unit asJsonObject ].
	^ super asJsonObject
		  at: 'function' put: function;
		  yourself
]

{ #category : 'accessing' }
AIFunction >> description [

	^ description
]

{ #category : 'accessing' }
AIFunction >> description: aString [

	description := aString
]

{ #category : 'accessing' }
AIFunction >> handler [

	^ handler
]

{ #category : 'accessing' }
AIFunction >> handler: anObject [

	handler := anObject
]

{ #category : 'initialization' }
AIFunction >> initialize [

	super initialize.
	parameters := OrderedCollection new.
	handler := [ :args | ]
]

{ #category : 'accessing' }
AIFunction >> name [

	^ name
]

{ #category : 'accessing' }
AIFunction >> name: aString [

	name := aString
]

{ #category : 'accessing' }
AIFunction >> parameters [

	^ parameters
]

{ #category : 'accessing' }
AIFunction >> type [

	^ 'function'
]

{ #category : 'accessing' }
AIFunction >> unit [

	^ unit
]

{ #category : 'accessing' }
AIFunction >> unit: anObject [

	unit := anObject
]
