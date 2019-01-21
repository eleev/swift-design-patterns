# Identifier Pattern
`Identifier` pattern allows to match any value and bind it to a variable or constant through type inference capability. The pattern, as its name suggests, identifies the matched value, infers its type and binds it. 

Consider the following example:

```swift
var message = "Hello World"
```
Here, the property `message` is of type `String`.

```swift
var age = 23
```

And here the `age` property is of type `Int`. We can check this out by getting the `Metatype` with the help of `type(of:)` function:

```swift
let ageType = type(of: age)
debugPrint("type of age is : ", ageType) // The ageType is Int
```

We can redefine which type should be considered as the `Identifier` type for a particular literal type:

```swift
typealias IntegerLiteralType = Double
```

We redefined the default type for `Integer` type, that is used by default with the `Identifier` pattern. Now, the already familiar property assignment will produce a slightly different result:

```swift
var weight = 89
``` 

Except that the type now `Double`, rather than `Int`. We can check it out by getting the `Metatype`:

```swift
let weightType = type(of: weight)
debugPrint("type of weight is : ", weightType) // The weight is Double
```

However, you need to be very careful if you redefine any literal type through `typealias`, since it may cause some issues that are hard to debug. As a general rule of thumb, try not to touch type literals and if you are not sure about which type will be infered, just make it explicit for the sake of simplicity. Better verbose than sorry 😄.