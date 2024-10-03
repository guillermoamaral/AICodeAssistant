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
assistant interface key: '<your mistral key>'.

"Explain a method"
assistant explainMethod: Date >> #addDays:.

"Generate a tests"
assistant beTestsGenerator.
"One test"
assistant writeTestForMethod: Date >> #addDays:.
"Several tests covering different cases" 
assistant writeTestsForMethod: Date >> #addDays:.

"Generate code based on a given test suite"
assistant beCodeFromTestsGenerator.
assistant writeCodeFromTests: RectangleTest buildSuiteFromLocalSelectors.
```

By default, an AICodeAssistant uses OpenAI interface, but it can be told to use a different one (provided it is supported):
```smalltalk
mistral := MistralInterface new.
mistral key: '<your mistral key>'.
assistant := AICodeAssistant new.
assistant interface: mistral.
```

