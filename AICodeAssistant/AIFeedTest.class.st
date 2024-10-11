"
This class is just a place holder for a set of test cases for AIAssistant to generate code
"
Class {
	#name : 'AIFeedTest',
	#superclass : 'TestCase',
	#category : 'AICodeAssistant-Tests',
	#package : 'AICodeAssistant',
	#tag : 'Tests'
}

{ #category : 'tests' }
AIFeedTest >> testSomething [

	| object |
	object := FibonacciObject new.
	self
		assert: (object doSomethingWith: 1) = 1;
		assert: (object doSomethingWith: 2) equals: 1;
		assert: (object doSomethingWith: 3) equals: 2;
		assert: (object doSomethingWith: 4) equals: 3;
		assert: (object doSomethingWith: 5) equals: 5;
		assert: (object doSomethingWith: 6) equals: 8
]
