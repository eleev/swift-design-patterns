# Factort Method Design Pattern
`Factory Method` is a creational design pattern that is aimed to hide the creation logic of an object. Also the pattern is very useful when we don't know in advance which type of an object we are going to use. *Factory Method* pattern is relatevely easy to implement.

## Car Factory
We are going to create a `CarFactory` that will help to resolve the following issue: we have several car types, for different price tiers and we need to crete one of them based on price. 

Let's start off from declaring a common protocol for `Car` type:

```swift
protocol Car {
    var name: String { get }
    var engine: Engine { get }
    var price: Price { get }
}
```
`Engine` and `Price` are enum types that contains several properties, that are not important for this particular example. The protocol itself is minimal and contains several of properties.

Next, we create several concrete implementations for our `Car` prtoocol:

```swift
struct Bugaggi: Car {
    var name: String = "Buggagi Chevron"
    var engine: Engine = .v12
    var price: Price = .expensive
}

struct Fodr: Car {
    var name: String = "Fodr Pahamareno"
    var engine: Engine = .v8
    var price: Price = .affordable
}

struct Truck: Car {
    var name: String = "Truck Trashmobile"
    var engine: Engine = .v2
    var price: Price = .cheap
}
```

The presented types conform to `Car` protocol and represent cars for various price tiers: cheap, affordable and expensive.

Now let's take a look at the `Factory Method` pattern implementation:

```swift
class CarFactory {
    
    func produce(price: Price) -> Car {
        switch price {
        case .expensive:
            return Bugaggi()
        case .affordable:
            return Fodr()
        case .cheap:
            return Truck()
        }
    }
}
```
The pattern contains a non-static method that creates a `Car` type based on the input parameter for price. 

```swift
// Create the factory
let carFactory = CarFactory()
// Produce the concrete car for expencive price tier:
let expensivePowerfulCar = carFactory.produce(price: .expensive)
// The produced car is Bugaggi

// Next produce car for cheap price tier
let cheapAndNotPoweful = carFactory.produce(price: .cheap)
// The produced car is Truck
```
Now, in order to create a `Car` we just instantiate the factory and call the `produce` method by passing `price` property. That is very convenient when we don't know at compile-time which type we will need during the run-time. Also, the related types' creation can be incapsulated and simplified, which is a great way to control the complexity of your code-base.

## Conclusion
`Factory Method` is a simple yet powerful creational design pattern that incapsulates dependent objects' creation from their declarations. The pattern is just a method, in some cases you may create a dedicated type that will wrap that method - as we did in the example above. 