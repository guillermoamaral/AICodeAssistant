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

"Generate a test for a method"
assistant writeTestForMethod: Date >> #addDays:.
"'  
testAddDays  
	| date result expected |  
	date := Date year: 2018 month: 9 day: 28.  
	result := date addDays: 3.  
	expected := Date year: 2018 month: 10 day: 1.  
	self assert: result = expected.  
'"

"Explain a method"
assistant explainMethod: Date >> #addDays:.

"assistant: The method `addDays:` in the `Date` class is designed to add a specified number of days to the current date and return the resulting date. Here's a breakdown of how it works:

1. **Input Parameter**:  
   The method takes one argument, `dayCount`, which represents the number of days to add (or subtract, if negative) to the current date (`self`).

2. **Conversion to DateAndTime**:  
   The method first converts the current `Date` object (`self`) into a `DateAndTime` object using the `asDateAndTime` message. This is necessary because `Date` objects represent only the date (year, month, day), while `DateAndTime` objects represent both the date and time, which allows for more flexible arithmetic operations.

3. **Adding Days**:  
   The expression `(dayCount days)` creates a `Duration` object representing the number of days to add. The `+` operator is then used to add this duration to the `DateAndTime` object. This results in a new `DateAndTime` object that represents the date and time after the specified number of days have been added.

4. **Conversion Back to Date**:  
   After the addition, the resulting `DateAndTime` object is converted back to a `Date` object using the `asDate` message. This ensures that the result is a `Date` object, not a `DateAndTime` object, since the method is expected to return only the date part.

5. **Return Value**:  
   The method returns the new `Date` object, which represents the date after adding (or subtracting) the specified number of days.

### Example:
For the expression:
```smalltalk
(Date year: 2018 month: 9 day: 28) addDays: 3
```
- The method converts `28 September 2018` to a `DateAndTime` object.
- It adds 3 days to this `DateAndTime`, resulting in `1 October 2018`.
- Finally, it converts the result back to a `Date` and returns `1 October 2018`.

### Key Points:
- The method handles both positive and negative values for `dayCount`.
- It uses `DateAndTime` for the arithmetic because `Date` alone does not support direct addition of days.
- The result is always a `Date` object, even though the intermediate calculation involves `DateAndTime`.
"
```
