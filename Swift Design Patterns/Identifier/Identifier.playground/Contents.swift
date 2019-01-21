import Foundation

// The type inference capability allows to match any value and bind it to a variable or constant. This pattern is called Identifier, since it, as the name suggests, identifies the matched value, infers its type and binds it.

var message = "Hello World" // message is of type String

var age = 23 // age is of type Int

let ageType = type(of: age)
debugPrint("type of age is : ", ageType)


// The default value-to-type identification can be changed by declaring a typealias for a particular type literal:

typealias IntegerLiteralType = Double

var weight = 89 // however, here weight is of type Double

// We can eaily prove that by using the reflection:

let wegithType = type(of: weight)
debugPrint("type of weight is : ", wegithType)
