Class {
	#name : 'TaggedTextParserTest',
	#superclass : 'AIFeedTest',
	#category : 'AICodeAssistant-Tests',
	#package : 'AICodeAssistant',
	#tag : 'Tests'
}

{ #category : 'tests' }
TaggedTextParserTest >> test0 [

	| text parser elements |
	text := '<a>test</a>'.
	parser := HtmlParser new.
	elements := parser parse: text.
	self
		assert: elements isCollection;
		assert: elements size equals: 1;
		assert: elements first tag equals: 'a';
		assert: elements first content equals: 'test';
		assert: elements first children isEmpty
]

{ #category : 'tests' }
TaggedTextParserTest >> test1 [

	| text parser elements |
	text := '<a>a node</a><b>another node</b>'.
	parser := HtmlParser new.
	elements := parser parse: text.
	self
		assert: elements isCollection;
		assert: elements size equals: 2;
		assert: elements first tag equals: 'a';
		assert: elements first content equals: 'a node';
		assert: elements first children isEmpty;
		assert: elements second tag equals: 'b';
		assert: elements second content equals: 'another node';
		assert: elements second children isEmpty
]

{ #category : 'tests' }
TaggedTextParserTest >> test3 [

	| text parser elements |
	text := '<a><b>nested node</b></a>'.
	parser := HtmlParser new.
	elements := parser parse: text.
	self
		assert: elements isCollection;
		assert: elements size equals: 1;
		assert: elements first tag equals: 'a';
		assert: elements first children size equals: 1;
		assert: elements first children first tag equals: 'b';
		assert: elements first children first content equals: 'nested node';
		assert: elements first children first children isEmpty
]

{ #category : 'tests' }
TaggedTextParserTest >> test4 [

	| text parser |
	text := '<a>test'.
	parser := HtmlParser new.
	self should: [ parser parse: text ] raise: Error
]

{ #category : 'tests' }
TaggedTextParserTest >> test5 [

	| text parser elements |
	text := ''.
	parser := HtmlParser new.
	elements := parser parse: text.
	self assert: elements isEmpty
]
