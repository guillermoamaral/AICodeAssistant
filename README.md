# AICodeAssistant
AI-based code assistant for Pharo (currently supported version: Pharo 12).

## Installation

You can load **AICodeAssistant** evaluating:
```smalltalk
Metacello new
	baseline: 'AICodeAssistant';
	repository: 'github://guillermoamaral/AICodeAssistant:main';
	load
```

## Usage

You can create a new AICodeAssistant and start talking to it like this:
```smalltalk
assistant := AICodeAssistant new.
assistant interface key: '<your AI API key>'.

"Explain a method"
assistant explainMethod: Date >> #addDays:.

"Generate a tests"
assistant beTestsGenerator.
assistant writeTestForMethod: Date >> #addDays:.
assistant writeTestsForMethod: Date >> #addDays:.

"Generate code based on a given test suite"
assistant beCodeFromTestsGenerator.
assistant writeCodeFromTests: RectangleTest buildSuiteFromLocalSelectors.

"Deduce type of an expression"
assistant deduceTypeOfExpression: '1 = 2 ifTrue: [2] ifFalse: [''a'']'.

"Use tools"
interface model: 'gpt-4o'; removeTools.
assistant useTool: AIFunction searchImplementors.
assistant clearHistory; sendPrompt: 'What are the implementors of clearHistory?'.```

By default, an AICodeAssistant uses OpenAI interface, but it can be told to use a different one (provided it is supported):

mistral := MistralInterface new.
mistral key: '<your Mistral API key>'.
assistant := AICodeAssistant new.
assistant interface: mistral.
```

