# Builder Design Pattern

Builder is a creational design pattern which purpose is aimed to simplify creation of complex objects. There are cases when object needs to accept too many parameters or the parameters are passed using a specific algorithm. For instance let's take a look at the following example:

```swift
struct Burger {

    // MARK: - Properties 

    var name: String
    var patties: Int
    var bacon: Bool 
    var cheese: Bool
    var pickles: Bool
    var mustard: Bool
    var tomato: Bool

    // MARK: - Initializers
    
    init(name: String, patties: Int, bacon: Bool, cheese: Bool, pickles: Bool, mustard: Bool, tomato: Bool) {
        self.name = builder.name
        self.patties = builder.patties
        self.bacon = builder.bacon
        self.cheese = builder.cheese
        self.pickles = builder.pickles
        self.mustard = builder.mustard
        self.tomato = builder.tomato
    }
}
```

We defined a simple  `struct` called Burger. The struct defines a set of properties that define a particular burger. However there are too many properties to be defined each time when we need to create new burger: 

```swift
let cheeseBurger = Burger(name: "Cheese Burger", patties: 1, bacon: false, cheese: true, pickles: true, mustard: true, tomato: false)

let hamburgerBurger = Burger(name: "Hamburger", patties: 1, bacon: false, cheese: false, pickles: true, mustard: true, tomato: false)
```

The problem here is that it is very easy to make a mistake when passing all those parameters and aesthetically the code not that good. If you extrapolate the example, and imagine that you have pretty big code-base, you will realise that so many parameters create boilerplate code that is really hard to look at. 

We can resolve this issue by decoupling the parameters into separate code-blocks. Then reuse those blocks in order to be able to build objects of value or reference types. We are going to start from declaring a common protocol which defines public data that needs to be set up at initialization time of object. 

```swift
protocol BurgerBuilder {

    var name: String { get }
    var patties: Int { get }
    var bacon: Bool { get }
    var cheese: Bool { get }
    var pickles: Bool { get }
    var mustard: Bool { get }
    var tomato: Bool { get }
}
```

Then we create structures that conform to the BurgerProtocol and we initialize each of the properties in the specialized structures: 

```swift
struct CheeseBurgerBuilder: BurgerBuilder {

    // MARK: - Properties

    var name: String = "CheeseBurger"
    var patties: Int = 1
    var bacon: Bool = false
    var cheese: Bool = true
    var pickles: Bool = true
    var mustard: Bool = true
    var tomato: Bool = false
}

struct HamburgerBuilder: BurgerBuilder {

    // MARK: - Properties

    var name: String = "Hamburger"
    var patties: Int = 1
    var bacon: Bool = false
    var cheese: Bool = false
    var pickles: Bool = true
    var mustard: Bool = true
    var tomato: Bool = false
}

```

As a result we no longer need to pass all those parameters into `Burger struct` :

```swift
struct Burger: BurgerBuilder {

    // MARK: - Properties

    var name: String
    var patties: Int
    var bacon: Bool
    var cheese: Bool
    var pickles: Bool
    var mustard: Bool
    var tomato: Bool


    // MARK: - Initializers

    init(builder: BurgerBuilder) {
        self.name = builder.name
        self.patties = builder.patties
        self.bacon = builder.bacon
        self.cheese = builder.cheese
        self.pickles = builder.pickles
        self.mustard = builder.mustard
        self.tomato = builder.tomato
    }
}
```

The only thing that was changed is the parameter list for the initializer. Instead of passing each property of the `Burger` we pass a type that conforms to BurgerBuilder protocol. 

```swift
let cheeseBurger = Burger(builder: CheeseBurgerBuilder())

let hamburgerBurger = Burger(builder: HamburgerBuilder())
```

We eliminated the boilerplateness  of the code, made it easy to look at and the changes that we miss something are greatly reduced. `Builder` pattern is a simple and effective solution that allows to more elegantly create objects of value or reference types. Also you can use it in cases when a method takes too many parameters. However, in that case you may probably need to use some other design solution, since `Builder` is aimed to create objects. 

## Injectable Closure

Another approach is to define an `injectable closure` instead of listing all the parameters. I have seen that the other developers recommend it as a way to implement the `Builder` pattern, however this approach has a couple of issues. Let's break them down one by one. 

### Broken encapsulation
By declaring the injectable closure that will be capable of initializers all the properties outside of the target object, you actually break one of the fundamentals concepts of Object Oriented Paradigm - encapsulation. 

Let's create an alternative `Burger` type but this time it's going to be declared as a `class` and we call it `BurgerInjectable`. 

```swift
public class BurgerInjectable {
    
    // MARK: - Properties
    
    public var name: String?
    public var patties: Int?
    public var bacon: Bool?
    public var cheese: Bool?
    public var pickles: Bool?
    public var mustard: Bool?
    public var tomato: Bool?
    
    // MARK: - Typealias
    
    public typealias BurgerInjectableClosure = (BurgerInjectable) -> ()
    
    // MARK: - Initializers
    
    public init(builder: BurgerInjectableClosure) {
        builder(self)
    }
}

```

Great! We don't even need to implement `builder protocol` and provide conformances for various use-cases. Let's take a look at the usage sample:


```swift
let burgerInjectableClosureHam: BurgerInjectable.BurgerInjectableClosure = { burger in
    
    burger.name = "Hamburger"
    burger.patties = 1
    burger.bacon = false
    burger.cheese = false
    burger.pickles = true
    burger.mustard = true
    burger.tomato = false
}

let burgerInjectableHam = BurgerInjectable(builder: burgerInjectableClosureHam)

```

Seems shorter and pretty nice! However we just broke the one of the fundamental OOP principles by declaring the properties as `public`. We had to do that in order to be able to set new values in the `BurgerInjectableClosure`. 

On the other hand, when we used builder protocol we marked all the properties as `get-only` which conforms to the encapsulation principle. 

## Keypath Builder

This is a relatively new approach, available since the introduction of Swift's `Key Path` addition with `Swift 4.0` release. The approach is based on the added dynamism to the language through keypaths and functional chaining. 

We start off from declaring an empty protocol called `BuilderProtocol`:

```swift
protocol BuilderProtocol { /* empty, implementation is added to the protocol extension*/ }
```
Then we implement a small protocol extension with a single method called `init`. `Init` is a reserved keyword in Swift, so we need to escape it by putting backtrick (`) before and after the word:

```swift
extension BuilderProtocol where Self: AnyObject {
    
    @discardableResult
    func `init`<T>(_ property: ReferenceWritableKeyPath<Self, T>, with value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
}
```

The `init` method allows to set a new value to a property by using a `keypath` in a chainable manner by repeatedly  calling `init` method for each single property. By the way, we can implement additional methods for different initialization cases, when several parameters are passed all at one method call. 

In order to use such as builder we need to add a conformance to `BuilderProtocol` to the type that needs to get this functionality:

```swift
extension Song: BuilderProtocol { /* empty implementation */ }
```

Then, the usage will look something like this:

```swift
let song = Song()
    .init(\.author,         with: "The Heavy")
    .init(\.name,           with: "Same Ol`")
    .init(\.genre,          with: .rock)
    .init(\.duration,       with: 184)
    .init(\.releaseDate,    with: "2012")
```
Separates the initialization from the actual usage of an object! 

However, I find this approach quite dangerous since we can easily misspell a keypath name and get a run-time error. Be wise when selecting an approach, there is no silver bullet for all the cases and situations.

## Conclusion
It's always up to you - the developer and architect to decide which approach suits best for your particular case and context. When making decisions related to choosing the way how the pattern is implemented just try to follow the main rules and principles of the paradigms and architectures that you use. Otherwise - you will find yourself in a situation when design wrongly implemented design pattern becomes `anti-pattern` and only gets you troubles and messy code. 
