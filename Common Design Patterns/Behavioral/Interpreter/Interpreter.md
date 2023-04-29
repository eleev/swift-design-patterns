# Interpreter Design Pattern in Swift

The Interpreter Design Pattern is a behavioral design pattern that defines a way to evaluate a language's grammar. It helps you create a simple language for your application or evaluate expressions based on a specific grammar.

In this article, we will discuss the Interpreter Design Pattern, its benefits, and how to implement it in Swift.

# The Problem

Imagine you are building a calculator app that evaluates arithmetic expressions. The expressions can include numbers, addition, subtraction, multiplication, and division operators. To evaluate these expressions, you need to parse and interpret them according to arithmetic rules.

# The Solution: Interpreter Design Pattern

The Interpreter Design Pattern provides a solution for evaluating expressions by defining a grammar for the language and creating an interpreter to evaluate the expressions based on this grammar.

The pattern involves creating an abstract syntax tree (AST) representing the expression. Each node in the tree represents a grammar rule or an element of the language. The interpreter traverses the tree and evaluates the expression by applying the grammar rules.

# Example in Swift

Let's implement the Interpreter Design Pattern in Swift to evaluate arithmetic expressions:

## Expression Protocol
First, we define an `Expression protocol that requires an `interpret()` method:
```swift
protocol Expression {
    func interpret() -> Double
}
```

## Terminal Expressions
Next, we create terminal expression classes for numbers and arithmetic operators:
```swift
class Number: Expression {
    let value: Double

    init(_ value: Double) {
        self.value = value
    }

    func interpret() -> Double {
        return value
    }
}

class Addition: Expression {
    let left: Expression
    let right: Expression

    init(_ left: Expression, _ right: Expression) {
        self.left = left
        self.right = right
    }

    func interpret() -> Double {
        return left.interpret() + right.interpret()
    }
}

class Subtraction: Expression {
    let left: Expression
    let right: Expression

    init(_ left: Expression, _ right: Expression) {
        self.left = left
        self.right = right
    }

    func interpret() -> Double {
        return left.interpret() - right.interpret()
    }
}

class Multiplication: Expression {
    let left: Expression
    let right: Expression

    init(_ left: Expression, _ right: Expression) {
        self.left = left
        self.right = right
    }

    func interpret() -> Double {
        return left.interpret() * right.interpret()
    }
}

class Division: Expression {
    let left: Expression
    let right: Expression

    init(_ left: Expression, _ right: Expression) {
        self.left = left
        self.right = right
    }

    func interpret() -> Double {
        return left.interpret() / right.interpret()
    }
}
```

## Client Code
Finally, we can use the `Interpreter Design Pattern` in our client code:
```swift
let expression: Expression = Division(
    Multiplication(Number(4), Number(5)),
    Addition(Number(3), Number(1))
)

let result = expression.interpret()
print("Result: \(result)")
```
This example evaluates the expression (4 * 5) / (3 + 1), and the result is 5.


# Conclusion

The `Interpreter Design Pattern` is a powerful way to evaluate expressions based on a specific grammar. It provides a clean and efficient solution for implementing a simple language or evaluating expressions in your application.

By separating the interpretation logic from the expression structure, the `Interpreter Design Pattern` makes your code more maintainable, extensible, and testable.
