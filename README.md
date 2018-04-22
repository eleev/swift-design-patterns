# ios-design-patterns
🚀 The ultimate collection of various Design Patterns implemented using the latest verion of Swift Programming Language. 

# About 
Sometimes it is hard to understnad the differnces and purposes of various types of design patterns. This repository aims to collect every single design pattern implemented using the latest version of `Swift` with examples and explanations. 

# List of content 

## Common Design Patterns

### Behavioral
Behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.

- **Chain of responsibility pattern:** Command objects are handled or passed on to other objects by logic-containing processing objects
Command pattern: Command objects encapsulate an action and its parameters
- **"Externalize the stack":** Turn a recursive function into an iterative one that uses a stack
- **Interpreter pattern:** Implement a specialized computer language to rapidly solve a specific set of problems
- **Iterator pattern:** Iterators are used to access the elements of an aggregate object sequentially without exposing its underlying representation
- **Mediator pattern:** Provides a unified interface to a set of interfaces in a subsystem
- **Memento pattern:** Provides the ability to restore an object to its previous state (rollback)
- **Null object pattern:** Designed to act as a default value of an object
- **Observer pattern:** a.k.a. Publish/Subscribe or Event Listener. Objects register to observe an event that may be raised by another object
- **Weak reference pattern:** De-couple an observer from an observable
- **Protocol stack:** Communications are handled by multiple layers, which form an encapsulation hierarchy
- **Scheduled-task pattern:** A task is scheduled to be performed at a particular interval or clock time (used in real-time computing)
- **Single-serving visitor pattern:** Optimise the implementation of a visitor that is allocated, used only once, and then deleted
- **Specification pattern:** Recombinable business logic in a boolean fashion
- **State pattern:** A clean way for an object to partially change its type at runtime
- **Strategy pattern:** Algorithms can be selected on the fly, using composition
- **Template method pattern:** Describes the program skeleton of a program; algorithms can be selected on the fly, using inheritance
- **Visitor pattern:** A way to separate an algorithm from an object

### Creational 
Creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or in added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.

- Abstract Factory pattern: a class requests the objects it requires from a factory object instead of creating the objects directly
- Factory method pattern: centralize creation of an object of a specific type choosing one of several implementations
- Builder pattern: separate the construction of a complex object from its representation so that the same construction process can create different representations
- Dependency Injection pattern: a class accepts the objects it requires from an injector instead of creating the objects directly
- Lazy initialization pattern: tactic of delaying the creation of an object, the calculation of a value, or some other expensive process until the first time it is needed
- Object pool pattern: avoid expensive acquisition and release of resources by recycling objects that are no longer in use
- Prototype pattern: used when the type of objects to create is determined by a prototypical instance, which is cloned to produce new objects
- [**Singleton pattern:**](https://github.com/jVirus/ios-design-patterns/tree/master/ios-design-patterns/Singleton) restrict instantiation of a class to one object

### Structural 
Structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.

- Adapter pattern: 'adapts' one interface for a class into one that a client expects
- Adapter pipeline: Use multiple adapters for debugging purposes.
- Retrofit Interface Pattern: An adapter used as a new interface for multiple classes at the same time.
- Aggregate pattern: a version of the Composite pattern with methods for aggregation of children
- Bridge pattern: decouple an abstraction from its implementation so that the two can vary independently
- Tombstone: An intermediate "lookup" object contains the real location of an object.
- Composite pattern: a tree structure of objects where every object has the same interface
- Decorator pattern: add additional functionality to a class at runtime where subclassing would result in an exponential rise of new classes
- Extensibility pattern: a.k.a. Framework - hide complex code behind a simple interface
- [**Facade pattern:**](https://github.com/jVirus/ios-design-patterns/tree/master/ios-design-patterns/Facade) create a simplified interface of an existing interface to ease usage for common tasks
- Flyweight pattern: a large quantity of objects share a common properties object to save space
- Marker pattern: an empty interface to associate metadata with a class.
- Pipes and filters: a chain of processes where the output of each process is the input of the next
- Opaque pointer: a pointer to an undeclared or private type, to hide implementation details
- Proxy pattern: a class functioning as an interface to another thing
- [**Delegation pattern:**](https://github.com/jVirus/ios-design-patterns/tree/master/ios-design-patterns/Delegation) allows object composition to achieve the same code reuse as inheritance

## Concurrency Design Patterns
Concurrency patterns are those types of design patterns that deal with the multi-threaded programming paradigm.

- Active Object
- Balking pattern
- Barrier
- Double-checked locking
- Guarded suspension
 Leaders/followers pattern
- Monitor Object
- Nuclear reaction
- Reactor pattern
- Read write lock pattern
- Scheduler pattern
- Thread pool pattern
- Thread-local storage

## iOS Specific Design Patterns


# References
There were used a number of reference materials such as:

- [Wikipedia](https://www.wikipedia.org)
- [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.amazon.com/Design-Patterns-Object-Oriented-Addison-Wesley-Professional-ebook/dp/B000SEIBB8)
- [Clean Code: A Handbook of Agile Software Craftsmanship](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882/ref=pd_lpo_sbs_14_img_0?_encoding=UTF8&psc=1&refRID=GTMN22S3KHGP59KCCANC&dpID=515iEcDr1GL&preST=_SX258_BO1,204,203,200_QL70_&dpSrc=detail)

# Author 
[Astemir Eleev](https://github.com/jVirus)

# Licence
The project is availabe under [MIT licence]().
