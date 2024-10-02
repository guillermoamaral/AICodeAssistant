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
assistant interface key: "your service key".

"Generate a test for a given method"
assistant writeTestForMethod: Date >> #addDays:.

"Generate several tests for a given method"
assistant writeTestsForMethod: Date >> #addDays:.

"Explain a method"
assistant explainMethod: Date >> #addDays:.

"Generate code based on a given test suite"
suite := RectangleTest buildSuiteFromLocalSelectors. 
assistant writeCodeFromTests: suite.

```

