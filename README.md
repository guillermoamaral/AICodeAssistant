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

You can creat a new AICodeAssistant and start talking to it like this:
```smalltalk

assistant := AICodeAssistant new.
assistant interface key: "your service key".

"Generate a test for a method"
answer := assistant writeTestForMethod: Date >> #addDays:.
answer partsTaggedWith: 'test'. "To get test code from the answer"

"Explain a method"
assistant explainMethod: Date >> #addDays:.
```
