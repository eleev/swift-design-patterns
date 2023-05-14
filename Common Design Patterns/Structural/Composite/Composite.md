# Composite 

## Introduction
The `Composite Design Pattern` is a structural design pattern that allows us to use recursive composition so that client code can treat individual objects and compositions uniformly. It's particularly useful when dealing with a hierarchy of objects.

In simpler terms, it lets you compose objects into tree structures and then work with these structures as if they were individual objects.

Let's take a closer look at how you can implement the `Composite Design Pattern` in Swift.

## Components of Composite Design Pattern

The `Composite Pattern` consists of three primary components:

1. `Component`: This is the base interface or class which defines the common methods that will be implemented by all child parts.
2. `Leaf`: These are the building blocks of the composite pattern. They implement all the methods defined by the Component.
3. `Composite`: This is an object which consists of Components. It implements the Component methods and also defines methods for accessing its child Components.

## Implementing Composite Design Pattern in Swift

Let's consider an example of an organization structure to demonstrate the composite pattern. The organization has employees, and each employee can either be a manager or a developer.

We'll start by defining the `Component`:
```swift
protocol Employee {
    func work()
}
```
Next, let's define the `Leaf` classes:
```swift
class Manager: Employee {
    func work() {
        print("Manager is managing the team")
    }
}

class Developer: Employee {
    func work() {
        print("Developer is writing code")
    }
}
```
Then, let's create the `Composite`:
```swift
class Organization {
    private var employees: [Employee] = []
    
    func add(employee: Employee) {
        employees.append(employee)
    }
    
    func work() {
        employees.forEach { $0.work() }
    }
}
```
In this example, `Employee` is the `Component`, `Manager` and `Developer` are `Leaf` classes, and `Organization` is the `Composite`.

Now we can use it like this:
```swift
let john = Manager()
let alice = Developer()
let bob = Developer()

let organization = Organization()
organization.add(employee: john)
organization.add(employee: alice)
organization.add(employee: bob)

organization.work()
```
When we call `work()` on the organization, it delegates the call to all its employees, whether they're managers or developers. This is the power of the `Composite Design Pattern`.
## Conclusion

The `Composite Design Pattern` provides a way to work with tree structures in a way that abstracts away the difference between individual objects and groups of objects. It's a powerful tool for dealing with complex hierarchies, and Swift's strong protocol-oriented programming features make it an excellent fit for implementing this pattern.
