Class {
	#name : 'AIInterface',
	#superclass : 'Object',
	#instVars : [
		'client',
		'model',
		'key'
	],
	#category : 'AICodeAssistant-Interfaces',
	#package : 'AICodeAssistant',
	#tag : 'Interfaces'
}

{ #category : 'accessing' }
AIInterface class >> url [
	self subclassResponsibility 
]

{ #category : 'requests' }
AIInterface >> get: uri [

	| data |
	data := client
		        setBearerAuthentication: key;
		        get: self url / uri.
	client isSuccess ifFalse: [ self error: client contents asString ].
	^ data
]

{ #category : 'initialization' }
AIInterface >> initialize [

	super initialize.
	self initializeClient

]

{ #category : 'initialization' }
AIInterface >> initializeClient [

	client := ZnClient new.
	client
		forJsonREST
]

{ #category : 'accessing' }
AIInterface >> key: anObject [

	key := anObject
]

{ #category : 'accessing' }
AIInterface >> model [

	^ model
]

{ #category : 'accessing' }
AIInterface >> model: aString [

	model := aString
]

{ #category : 'requests' }
AIInterface >> modelWithId: id [

	^ self get: '/models/' , id 
]

{ #category : 'requests' }
AIInterface >> models [

	^ self get: '/models'
]

{ #category : 'requests' }
AIInterface >> post: uri with: json [

	| data |
	data := client
		        setBearerAuthentication: key;
		        post: self url / uri contents: json.
	client isSuccess ifFalse: [ self error: client contents asString ].
	^ data
]

{ #category : 'accessing' }
AIInterface >> url [
	^self class url
]
