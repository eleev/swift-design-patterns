# Visitor Design Pattern in Swift

The Visitor Design Pattern is a powerful behavioral design pattern that allows you to separate an algorithm from the object structure it operates on. It promotes the principle of the `Single Responsibility` and `Open/Closed` design, making it easier to maintain, extend, and test your code.

In this article, we will discuss the Visitor Design Pattern, its benefits, and how to implement it in Swift.

# The Problem

Imagine you have an application that processes various types of shapes, such as circles, rectangles, and triangles. These shapes have their own specific properties and methods. Now, you want to implement some operations on these shapes, like calculating their areas, drawing them, or exporting them to a file.

One approach is to add these operations as methods in each shape class. However, this would violate the `Single Responsibility Principle`, as each shape class would have multiple responsibilities. Moreover, adding new operations would require modifying the shape classes, breaking the `Open/Closed Principle`.

# The Solution: Visitor Design Pattern

The Visitor Design Pattern addresses these issues by separating the operations from the object structure they operate on. It involves creating a separate visitor class for each operation. The visitor class implements a specific interface that defines visit methods for each object type it can operate on.

The object structure (shapes in our case) implements an interface with an accept method that takes a visitor as an argument. The accept method calls the appropriate visit method on the visitor, passing itself as an argument. This way, the operation logic is encapsulated in the visitor class and does not affect the object structure.

# Example in Swift

Let's implement the `Visitor Design Pattern` in Swift to calculate the area of different shapes:

## `Element Protocol`
First, we define an `Element` protocol that requires an `accept()` method:
```swift
protocol Element {
    func accept(visitor: Visitor)
}

```

## Concrete Elements
Next, we create concrete element classes for each shape type:
```swift
class Circle: Element {
    let radius: Double
    
    init(radius: Double) {
        self.radius = radius
    }
    
    func accept(visitor: Visitor) {
        visitor.visit(circle: self)
    }
}

class Rectangle: Element {
    let width: Double
    let height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    func accept(visitor: Visitor) {
        visitor.visit(rectangle: self)
    }
}

```
## Visitor Protocol
Now, we define a `Visitor` protocol with visit methods for each concrete element:
```swift
protocol Visitor {
    func visit(circle: Circle)
    func visit(rectangle: Rectangle)
}
```

## Concrete Visitor
We create a concrete visitor class `AreaCalculator` that calculates the area of each shape:
```swift
class AreaCalculator: Visitor {
    func visit(circle: Circle) {
        let area = Double.pi * pow(circle.radius, 2)
        print("Circle area: \(area)")
    }
    
    func visit(rectangle: Rectangle) {
        let area = rectangle.width * rectangle.height
        print("Rectangle area: \(area)")
    }
}
```

## Client Code
Finally, we can use the `Visitor Design Pattern` in our client code:
```swift
let shapes: [Element] = [Circle(radius: 5), Rectangle(width: 4, height: 6)]
let areaCalculator = AreaCalculator()

for shape in shapes {
    shape.accept(visitor: areaCalculator)
}
```

# Conclusion

The `Visitor Design Pattern` is a powerful way to separate algorithms from the object structures they operate on. It makes your code more maintainable, extensible, and testable by adhering to the `Single Responsibility` and `Open/Closed` design principles.
