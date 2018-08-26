# swift-design-patterns
🚀 The ultimate collection of various `Design Patterns` implemented using the latest verion of `Swift Programming Language`. 

# About 
There are many design patterns for various purposes and use-cases. We may not remember them all - it's absolutely normal. This repository aims to collect as many design patterns as possbile with examples implemented using the latest version of `Swift`, and serve as a reference material for eveyone who is willing to learn something new.

# Disclamer
The motivation behind this porject is to help the others to learn by compiling the knowlege that I have. The material to write down is enourmous, sometimes I may formalize my thoughts in a way that look strange or unclear. I provide reference materials, so you are able to take a look at the same patterns but from a different perspective or original source. 

If you find that something is not clear or has an issue, please, don't judge immediately in a negative way. It's an open source and you have such an opportunity to polietly tell me about that or even create a pool request (which is the best way to contribute). The other piece of motivation is that I really want to create learning material that is `solid` and yet `easy` to understand for developers that know basics of `OOP` and `POP` paradigms (since it's `Swift` and `POP` is almost as important as `OOP` IMHO).

I want to keep this repo up to date, implement the latest design, architecture and concurrency patterns. Open-source for eveyone :octocat:

# List of content 

## Common Design Patterns

### Behavioral
Behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.

#### Gang of Four

- **Chain of Responsibility:** command objects are handled or passed on to other objects by logic-containing processing objects
- ***Command:*** command objects encapsulate an action and its parameters
- **Interpreter:** implement a specialized computer language to rapidly solve a specific set of problems
- **Iterator:** iterators are used to access the elements of an aggregate object sequentially without exposing its underlying representation
- **Mediator:** provides a unified interface to a set of interfaces in a subsystem
- **Memento:** provides the ability to restore an object to its previous state (rollback)
- **Observer:** a.k.a. `Publish/Subscribe` or `Event Listener`. Objects register to observe an event that may be raised by another object
- **State:** a clean way for an object to partially change its type at runtime
- **Strategy:** algorithms can be selected on the fly, using composition
- **Template Method:** describes the program skeleton of a program; algorithms can be selected on the fly, using inheritance
- **Visitor:** a way to separate an algorithm from an object

#### Other

- **Externalize the Stack:** turn a recursive function into an iterative one that uses a stack
- **Null Object:** designed to act as a default value of an object
- **Weak Reference:** de-couple an observer from an observable
- **Protocol Stack:** communications are handled by multiple layers, which form an encapsulation hierarchy
- **Scheduled-Task:** a task is scheduled to be performed at a particular interval or clock time (used in real-time computing)
- **Single-Serving Visitor:** optimise the implementation of a visitor that is allocated, used only once, and then deleted
- **Specification:** recombinable business logic in a boolean fashion

### Creational 
Creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or in added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.

#### Gang of Four

- **Abstract Factory:** a class requests the objects it requires from a factory object instead of creating the objects directly
- **Factory Method:** centralize creation of an object of a specific type choosing one of several implementations
- [**Builder:**](https://github.com/jVirus/swift-design-patterns/blob/master/Common%20Design%20Patterns/Creational/Builder/Builder.md) separates the construction of a complex object from its representation so that the same construction process can create different representations
- **Prototype:** used when the type of objects to create is determined by a prototypical instance, which is cloned to produce new objects
- [**Singleton:**](https://github.com/jVirus/swift-design-patterns/blob/master/Common%20Design%20Patterns/Creational/Singleton/Sinpleton.md) restrict instantiation of a class to one object

#### Other 

- **Dependency Injection:** a class accepts the objects it requires from an injector instead of creating the objects directly
- **Lazy Initialization:**: tactic of delaying the creation of an object, the calculation of a value, or some other expensive process until the first time it is needed
- **Object Pool**: avoid expensive acquisition and release of resources by recycling objects that are no longer in use


### Structural 
Structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.

#### Gang of Four

- **Adapter:** 'adapts' one interface for a class into one that a client expects
- **Bridge:**: decouple an abstraction from its implementation so that the two can vary independently
- **Composite:** a tree structure of objects where every object has the same interface
- **Decorator:** add additional functionality to a class at runtime where subclassing would result in an exponential 
- [**Facade:**](https://github.com/jVirus/ios-design-patterns/tree/master/ios-design-patterns/Facade) create a simplified interface of an existing interface to ease usage for common tasks
- **Flyweight:** a large quantity of objects share a common properties object to save space
- **Proxy:** a class functioning as an interface to another thing

#### Other 

- **Adapter Pipeline:** use multiple adapters for debugging purposes.
- **Retrofit Interface:** an adapter used as a new interface for multiple classes at the same time.
- **Aggregate pattern:** a version of the Composite pattern with methods for aggregation of children
- **Tombstone:** an intermediate "lookup" object contains the real location of an object.
rise of new classes
- **Extensibility:** a.k.a. `Framework` - hide complex code behind a simple interface
- **Marker:** an empty interface to associate metadata with a class.
- **Pipes and Filters:** a chain of processes where the output of each process is the input of the next
- **Opaque Pointer:** a pointer to an undeclared or private type, to hide implementation details
- [**Delegation:**](https://github.com/jVirus/swift-design-patterns/blob/master/Common%20Design%20Patterns/Structural/Delegation/Delegation.md) allows object composition to achieve the same code reuse as inheritance
- [**Multicast Delegate:**]() advanced version of `Delegate pattern` which allows multiple delegates to be notified about method calls

## Concurrency Design Patterns
Concurrency patterns are those types of design patterns that deal with the multi-threaded programming paradigm.

- **Active Object:**
- **Balking Pattern:**
- **Barrier:**
- **Double-Checked Locking:**
- **Guarded Suspension:**
- **Leaders/Followers:**
- **Monitor Object:**
- **Nuclear Reaction:**
- **Reactor:**
- **Read Write Lock:**
- **Scheduler:**
- **Thread Pool**
- **Thread-Local Storage:**

## iOS Design Patterns
Design patterns that are specific to `iOS` platform.

- **Coordinator:** A Coordinator is an object the encapsulates a lifecycle that is spread over a collection of view controllers.

## Architectural Patterns
Architectural patterns addres issues that arise in software engineering within certain contexts. They are similar to design patterns, but have broader scope of responsibilities. Architectural patterns structure the way how software product/application/platform is built by separating different abstractions into reusable layers. Sometimes architectural patterns are documented as design patterns.

- [**MVC:**]() - 
- [**MVP:**]() - 
- [**MVVM:**]() - 
- [**MVVM-C:**]() - 
- [**VIPER:**]() - 
- [**DAO:**]() - `DAO` stands for `Data Access Object`. `DAO` provides abstract interface to a database or other persistence storage mechanism. 

## Swift Patterns
In [`Swift`](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Patterns.html#//apple_ref/doc/uid/TP40014097-CH36-ID419), there are two basic kinds of patterns: those that successfully match any kind of value, and those that may fail to match a specified value at runtime. 

>  The first kind of pattern is used for destructuring values in simple variable, constant, and optional bindings. These include wildcard patterns, identifier patterns, and any value binding or tuple patterns containing them. You can specify a type annotation for these patterns to constrain them to match only values of a certain type.

>  The second kind of pattern is used for full pattern matching, where the values you’re trying to match against may not be there at runtime. These include enumeration case patterns, optional patterns, expression patterns, and type-casting patterns. You use these patterns in a case label of a switch statement, a catch clause of a do statement, or in the case condition of an if, while, guard, or for-in statement.

The following patterns are not part of the topic about `design patterns`. However they have some relation to the topic since they offer reusable solutions for common design scenarious. 

- **Wildcard:** a wildcard pattern matches and ignores any value and consists of an underscore (_). Use a wildcard pattern when you don’t care about the values being matched against 
- **Identifier:** an identifier pattern matches any value and binds the matched value to a variable or constant name
- **Value-Binding:** a value-binding pattern binds matched values to variable or constant names. Value-binding patterns that bind a matched value to the name of a constant begin with the let keyword; those that bind to the name of variable begin with the var keyword
- **Tuple Pattern:** a tuple pattern is a comma-separated list of zero or more patterns, enclosed in parentheses. Tuple patterns match values of corresponding tuple types
- **Enumeration Case:** an enumeration case pattern matches a case of an existing enumeration type. Enumeration case patterns appear in switch statement case labels and in the case conditions of `if`, `while`, `guard`, and `for-in` statements
- **Optional:** an optional pattern matches values wrapped in a `some(Wrapped)` case of an `Optional<Wrapped>` enumeration. Optional patterns consist of an identifier pattern followed immediately by a question mark and appear in the same places as enumeration case patterns
- **Type-Casting:** there are two type-casting patterns, the is pattern and the as pattern. The is pattern appears only in switch statement case labels
- **Expression:** an expression pattern represents the value of an expression. Expression patterns appear only in `switch` statement `case` labels

# References
There were used a number of reference materials such as:

- [Wikipedia](https://www.wikipedia.org)
- [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.amazon.com/Design-Patterns-Object-Oriented-Addison-Wesley-Professional-ebook/dp/B000SEIBB8)
- [Clean Code: A Handbook of Agile Software Craftsmanship](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882/ref=pd_lpo_sbs_14_img_0?_encoding=UTF8&psc=1&refRID=GTMN22S3KHGP59KCCANC&dpID=515iEcDr1GL&preST=_SX258_BO1,204,203,200_QL70_&dpSrc=detail)
- [Swift Patterns](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Patterns.html#//apple_ref/doc/uid/TP40014097-CH36-ID419)
- [Coordinator Pattern](http://khanlou.com/2015/01/the-coordinator/)

# Author 
[Astemir Eleev](https://github.com/jVirus)

# Licence
The project is availabe under [MIT licence](https://github.com/jVirus/ios-design-patterns/blob/master/LICENSE).
