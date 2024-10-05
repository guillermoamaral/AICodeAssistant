Class {
	#name : 'AISuggestedClass',
	#superclass : 'Object',
	#instVars : [
		'superclassName',
		'name',
		'instanceVariableNames',
		'classVariableNames',
		'methods'
	],
	#category : 'AICodeAssistant-Base',
	#package : 'AICodeAssistant',
	#tag : 'Base'
}

{ #category : 'instance creation' }
AISuggestedClass class >> named: aString [
	
	^ self new name: aString
]

{ #category : 'accessing' }
AISuggestedClass >> addMethod: anAISuggestedMethod [

	methods add: anAISuggestedMethod.
	anAISuggestedMethod suggestedClass: self
]

{ #category : 'accessing' }
AISuggestedClass >> classVariableNames [

	^ classVariableNames
]

{ #category : 'accessing' }
AISuggestedClass >> classVariableNames: aCollection [

	classVariableNames := aCollection
]

{ #category : 'testing' }
AISuggestedClass >> exists [

	^ self realClass notNil
]

{ #category : 'initialization' }
AISuggestedClass >> initialize [

	super initialize.
	instanceVariableNames := #(  ).
	classVariableNames := #(  ).
	methods := OrderedCollection new
]

{ #category : 'accessing' }
AISuggestedClass >> instanceVariableNames [

	^ instanceVariableNames
]

{ #category : 'accessing' }
AISuggestedClass >> instanceVariableNames: aCollection [

	instanceVariableNames := aCollection
]

{ #category : 'accessing' }
AISuggestedClass >> methods [

	^ methods
]

{ #category : 'accessing' }
AISuggestedClass >> methods: aCollection [

	methods := aCollection
]

{ #category : 'accessing' }
AISuggestedClass >> name [

	^ name
]

{ #category : 'accessing' }
AISuggestedClass >> name: aString [

	name := aString
]

{ #category : 'printing' }
AISuggestedClass >> printOn: aStream [

	aStream nextPutAll: name
]

{ #category : 'accessing' }
AISuggestedClass >> realClass [

	^ Smalltalk globals at: name asSymbol ifAbsent: [  ]
]

{ #category : 'accessing' }
AISuggestedClass >> superclassName [

	^ superclassName
]

{ #category : 'accessing' }
AISuggestedClass >> superclassName: aString [

	superclassName := aString
]
