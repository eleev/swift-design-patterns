# Chain of Responsibility

## Introduction
The `Chain of Responsibility` design pattern is a behavioral pattern that allows you to decouple the sender of a request from its receiver by giving multiple objects a chance to handle the request. This is done by chaining the receiving objects together and passing the request along the chain until an object handles it.

In this article, we'll discuss the `Chain of Responsibility` design pattern and its implementation in Swift, along with examples.

## Components
There are three main components in the `Chain of Responsibility` pattern:

1. `Handler`: An abstract class or protocol that defines the interface for handling requests. It also maintains a reference to the next handler in the chain.
2. `Concrete Handler`: A class that inherits from the `Handler` and implements the handling logic for a specific request.
3. `Client`: The client class that initiates the request and sends it to the first handler in the chain.

## Implementing Chain of Responsibility in Swift
Let's say we have an expense approval system, and we want to model the approval process using the `Chain of Responsibility` pattern. The approval process consists of multiple levels of approval, such as Manager, Director, and CEO.

```swift
struct Expense {
    let amount: Double
    let description: String
}

protocol Handler: AnyObject {
    var nextHandler: Handler? { get set }
    func handle(expense: Expense) -> Bool
}
```

Next, let's create the concrete handlers for Manager, Director, and CEO:

```swift
class Manager: Handler {
    var nextHandler: Handler?
    
    func handle(expense: Expense) -> Bool {
        if expense.amount <= 500 {
            print("Manager approved expense: \(expense.description)")
            return true
        } else {
            return nextHandler?.handle(expense: expense) ?? false
        }
    }
}

class Director: Handler {
    var nextHandler: Handler?
    
    func handle(expense: Expense) -> Bool {
        if expense.amount <= 2000 {
            print("Director approved expense: \(expense.description)")
            return true
        } else {
            return nextHandler?.handle(expense: expense) ?? false
        }
    }
}

class CEO: Handler {
    var nextHandler: Handler?
    
    func handle(expense: Expense) -> Bool {
        if expense.amount <= 10000 {
            print("CEO approved expense: \(expense.description)")
            return true
        } else {
            print("Expense not approved: \(expense.description)")
            return false
        }
    }
}
```

Now, we can create the chain of handlers and send an expense request:

```swift
let manager = Manager()
let director = Director()
let ceo = CEO()

manager.nextHandler = director
director.nextHandler = ceo

let expense = Expense(amount: 1500, description: "Conference tickets")

if !manager.handle(expense: expense) {
    print("Expense not approved")
}
```

## Responder Chain and Chain of Responsibility
The responder chain is an excellent example of the `Chain of Responsibility` design pattern in action. `UIResponder` objects in the chain are responsible for handling different types of events. If a `UIResponder` object cannot handle an event, it passes the event to the next `UIResponder` object in the chain until the event is either handled or reaches the end of the chain.

This approach allows UIKit to handle events in a flexible and extensible manner while also providing a clean separation of concerns.

## Understanding UIResponder
`UIResponder` is an abstract class in UIKit that defines the interface for handling events. The `UIResponder` class provides a set of methods for handling various types of events, such as touches, motion events, and remote control events.

The `UIResponder` class also provides a property, next, which points to the next `UIResponder` object in the responder chain. By default, the next property returns nil, which indicates the end of the responder chain. Subclasses of `UIResponder` can override this property to return the next responder in the chain.

To manage system events, subclasses of `UIResponder` can indicate their ability to handle particular `UIEvent` types by overriding the corresponding methods for those event types:

```swift
open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
open func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
open func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
open func remoteControlReceived(with event: UIEvent?)
```

## Responder Chain in UIKit
In UIKit, the responder chain consists of a series of `UIResponder` objects, such as `UIView`, `UIViewController`, `UIWindow`, and `UIApplication`. When an event occurs, UIKit starts at the first responder and traverses the responder chain until it finds an object that can handle the event.

The responder chain is built based on the view hierarchy, as well as the relationship between view controllers and their parent view controllers or presenting view controllers.

For example, consider the following view hierarchy:

- `UIWindow`
    - `UINavigationController`
        - `UITableViewController`
            - `UITableViewCell`

When a touch event occurs within a `UITableViewCell`, UIKit starts the responder chain at the `UITableViewCell`. If the `UITableViewCell` cannot handle the event, UIKit passes the event to its superview, the `UITableViewController`, and so on up the chain.

Here's a simplified example of how the `UIResponder` next property can be used to traverse the responder chain:

```swift
extension UIResponder {
    func traverseResponderChain() {
        print(String(describing: type(of: self)))
        next?.traverseResponderChain()
    }
}

// Usage:
cell.traverseResponderChain()
```

This example would print the `UIResponder` classes in the chain, starting with `UITableViewCell`, `UITableViewController`, `UINavigationController`, `UIWindow`, and `UIApplication`.

## Conclusion
The responder chain in UIKit is a great example of the `Chain of Responsibility` design pattern applied to event handling. By implementing the responder chain, UIKit can handle events in a flexible and extensible manner while maintaining a clean separation of concerns. Understanding the responder chain can help you build more robust and maintainable iOS applications.
The `Chain of Responsibility` design pattern is a powerful technique for decoupling the sender of a request from its receiver. By implementing this pattern in Swift, we can create flexible and extensible systems that can handle different types of requests in a clean and organized manner.
