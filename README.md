# swift-design-patterns [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

![GitHub last commit](https://img.shields.io/github/last-commit/jvirus/swift-design-patterns?label=Last%20Commit)
[![Language](https://img.shields.io/badge/language-Swift-orange.svg)]()
[![Progress Patterns](https://img.shields.io/badge/patters-36/79-green.svg)]()
[![Progress Principles](https://img.shields.io/badge/principles-0/50-red.svg)]()
[![NLOC](https://img.shields.io/tokei/lines/github/jvirus/swift-design-patterns)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()

![](logo-swift_design_patterns.jpg)

### If you like the project, please give it a star ⭐ It will show the creator your appreciation and help others to discover the repo.

# ✍️ About 
🚀 The ultimate collection of various `Software Design Patterns` implemented using `Swift Programming Language`.  This repository aims to collect as many design patterns as possbile with examples and to serve as a reference material for everyone who is willing to learn something new.

Each design pattern has a complete description and source code. You can view the description by clicking the **name** of a design pattern and view the code by clicking the **[code]**. 

# ☢️ Disclamer
The primary objective of this project is to assist others in learning by compiling and sharing the knowledge I have acquired. Given the vast amount of material to be documented, there may be instances when my thoughts are expressed in a manner that appears peculiar or unclear. I have included reference materials to enable you to examine similar patterns from different perspectives or original sources.

If you come across any unclear or problematic content, please refrain from forming an immediate negative judgment. As this is an open-source project, you have the opportunity to politely inform me of any issues or even submit a pull request, which is the most effective way to contribute. Another motivating factor for this project is my desire to create learning materials that are both 'solid' and 'easy' to comprehend for developers who are familiar with the basics of OOP and POP paradigms, as these are crucial for working with Swift.

**Nonetheless, in some contexts and literature certain terminology is not reffered as design pattern (for example ***Weak Reference***). My intention here is to provide explanations and use cases without initiating any heated debates.**

# 📚 List of Contents

- [Common Design Patterns](#common-design-patterns)
- [Concurrency Design Patterns](#concurrency-design-patterns)
- [Architectural Patterns](#architectural-patterns)
- [Swift Patterns](#swift-patterns)
- [Software Design Principles](#software-design-principles)

## 🏗 Common Design Patterns

### Behavioral
> Behavioral design patterns are design patterns that identify common communication patterns between objects and realize these patterns. By doing so, these patterns increase flexibility in carrying out this communication.
>
> **Source:** [wikipedia.org](http://en.wikipedia.org/wiki/Behavioral_pattern)

#### Gang of Four

- [**Chain of Responsibility:**](/Common%20Design%20Patterns/Behavioral/ChainOfResponsibility/ChainOfResponsibility.md) command objects are handled or passed on to other objects by logic-containing processing objects
- [**Command:**](/Common%20Design%20Patterns/Behavioral/Command/Command.md) command objects encapsulate an action and its parameters [[code]](/Common%20Design%20Patterns/Behavioral/Command/Command.playground/Contents.swift)
- [**Interpreter:**](/Common%20Design%20Patterns/Behavioral/Interpreter/Interpreter.md) implement a specialized computer language to rapidly solve a specific set of problems
- [**Iterator:**](/Common%20Design%20Patterns/Behavioral/Iterator/Iterator.md) iterators are used to access the elements of an aggregate object sequentially without exposing its underlying representation [[code]](/Common%20Design%20Patterns/Behavioral/Iterator/Iterator.playground/Contents.swift)
- [**Mediator:**](/Common%20Design%20Patterns/Behavioral/Mediator/Mediator.md) defines an object that encapsulates how a set of objects interact [[code](/Common%20Design%20Patterns/Behavioral/Mediator/Mediator.playground/Contents.swift)]
- [**Memento:**](/Common%20Design%20Patterns/Behavioral/Memento/Memento.md) provides the ability to restore an object to its previous state (rollback) [[code]](/Common%20Design%20Patterns/Behavioral/Memento/Memento.playground/Contents.swift)
- [**Observer:**](/Common%20Design%20Patterns/Behavioral/Observer/Observer.md) objects register to observe an event that may be raised by another object. The pattern has similarities with `Publish/Subscribe` and `Multicast Delegate`patterns [[code]](/Common%20Design%20Patterns/Behavioral/Observer/Observer.playground/Contents.swift)
- [**State:**](/Common%20Design%20Patterns/Behavioral/State/State.md) allows an object to alter its behavior when its internal state changes [[code](/Common%20Design%20Patterns/Behavioral/State/State.playground/Contents.swift)]
- [**Strategy:**](/Common%20Design%20Patterns/Behavioral/Strategy/Strategy.md) algorithms can be selected on the fly, using composition [[code]](/Common%20Design%20Patterns/Behavioral/Strategy/Strategy.playground/Contents.swift)
- **Template Method:** describes the program skeleton of a program; algorithms can be selected on the fly, using inheritance
- [**Visitor:**](/Common%20Design%20Patterns/Behavioral/Visitor/Visitor.md) a way to separate an algorithm from an object

#### Other

- [**Externalize the Stack:**](/Common%20Design%20Patterns/Behavioral/Other/ExternalizeTheStack/ExternalizeTheStack.md) turn a recursive function into an iterative one that uses a stack
- [**Null Object:**](/Common%20Design%20Patterns/Behavioral/Other/NullObject/NullObject.md) designed to act as a default value of an object [[code]](/Common%20Design%20Patterns/Behavioral/Other/NullObject/NullObject.playground/Contents.swift) 
- [**Weak Reference:**](/Common%20Design%20Patterns/Behavioral/Other/WeakReference/WeakReference.md) de-couple an observer from an observable
- **Protocol Stack:** communications are handled by multiple layers, which form an encapsulation hierarchy
- **Scheduled-Task:** a task is scheduled to be performed at a particular interval or clock time (used in real-time computing)
- **Single-Serving Visitor:** optimise the implementation of a visitor that is allocated, used only once, and then deleted
- **Specification:** recombinable business logic in a boolean fashion
- **Publish/Subscribe:** messaging pattern where senders of messages, called publishers, do not program the messages to be sent directly to specific receivers, called subscribers, but instead categorize published messages into classes without knowledge of which subscribers, if any, there may be. The pattern has similarities with `Observer`, `Event Listener` and `Multicast Delegate`, however it has its differences and weaknesses as well
- **Event Listener:** NO DESCRIPTION YET (has differences in comparison to *Observer* and *Publish/Subscribe* patterns - need to formalize it in a sentence or so) 

### Creational 
> Creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or in added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
>
> **Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Creational_pattern)

#### Gang of Four

- [**Abstract Factory:**](/Common%20Design%20Patterns/Creational/AbstractFactory/AbstractFactory.md) a class requests the objects it requires from a factory object instead of creating the objects directly [[code]](/Common%20Design%20Patterns/Creational/AbstractFactory/AbstractFactory.playground/Contents.swift)
- [**Factory Method:**](/Common%20Design%20Patterns/Creational/FactoryMethod/FactoryMethod.md) centralize creation of an object of a specific type choosing one of several implementations [[code]](/Common%20Design%20Patterns/Creational/FactoryMethod/FactoryMethod.playground/Contents.swift) 
- [**Builder:**](/Common%20Design%20Patterns/Creational/Builder/Builder.md) separates the construction of a complex object from its representation so that the same construction process can create different representations [[code]](/Common%20Design%20Patterns/Creational/Builder/Builder.playground/Contents.swift)
- [**Prototype:**](/Common%20Design%20Patterns/Creational/Prototype/Prototype.md) used when the type of objects to create is determined by a prototypical instance, which is cloned to produce new objects [[code]](/Common%20Design%20Patterns/Creational/Prototype/Prototype.playground/Contents.swift)
- [**Singleton:**](/Common%20Design%20Patterns/Creational/Singleton/Sinpleton.md) restrict instantiation of a class to one object [[code]](/Common%20Design%20Patterns/Creational/Singleton/Singleton.playground/Sources/Singleton.swift) 

#### Other 

- [**Dependency Injection:**](/Common%20Design%20Patterns/Creational/DependencyInjection/DependencyInjection.md) a type accepts the objects it requires from an injector instead of creating the objects directly [[code]](/Common%20Design%20Patterns/Creational/DependencyInjection/DependencyInjection.playground/Contents.swift)
- [**Lazy Initialization:**](/Common%20Design%20Patterns/Creational/LazyInitialization/LazyInitialization.md) tactic of delaying the creation of an object, the calculation of a value, or some other expensive process until the first time it is needed [[code]](/Common%20Design%20Patterns/Creational/LazyInitialization/LazyInitialization.playground/Contents.swift)
- [**Object Pool:**](/Common%20Design%20Patterns/Creational/ObjectPool/ObjectPool.md) avoid expensive acquisition and release of resources by recycling objects that are no longer in use [[code]](/Common%20Design%20Patterns/Creational/ObjectPool/ObjectPool.playground/Contents.swift)
- **Simple Factory:** provides an interface for creating objects in a superclass while allowing subclasses to define the type of objects that will be created. It is called a `simple factory` because it centralizes the object creation process, making it easier to manage and maintain.
- **Static Factory:** used for instantiation of dependent types. Replaces constructors/initializers for object creation that provides additional capabilities such as caching and/or throwing an error

### Structural 
> Structural design patterns are design patterns that ease the design by identifying a simple way to realize relationships between entities.
>
> **Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Structural_pattern)


#### Gang of Four

- [**Adapter:**](/Common%20Design%20Patterns/Structural/Adapter/Adapter.md) 'adapts' one interface for a class into one that a client expects [[code]](/Common%20Design%20Patterns/Structural/Adapter/Adapter.playground/Contents.swift)
- [**Bridge:**](/Common%20Design%20Patterns/Structural/Bridge/Bridge.md) decouple an abstraction from its implementation so that the two can vary independently [[code]](/Common%20Design%20Patterns/Structural/Bridge)
- **Composite:** a tree structure of objects where every object has the same interface
- **Decorator:** allows behavior to be added to an individual object, dynamically, without affecting the behavior of other objects from the same class
- [**Facade:**](/Common%20Design%20Patterns/Structural/Facade/Facade.md) create a simplified interface of an existing interface to ease usage for common tasks [[code]](/Common%20Design%20Patterns/Structural/Facade/Facade.playground/Contents.swift)
- **Flyweight:** a large quantity of objects share a common properties object to save space
- [**Proxy:**](/Common%20Design%20Patterns/Structural/Proxy/Proxy.md) a class functioning as an interface to another thing [[code]](/Common%20Design%20Patterns/Structural/Proxy/Proxy.playground)

#### Other 
- [**Marker:**](/Common%20Design%20Patterns/Structural/Marker/Marker.md) an empty interface (or protocol) to associate metadata with a class  [[code]](/Common%20Design%20Patterns/Structural/Marker/Marker.playground/Contents.swift)
- [**Delegate:**](/Common%20Design%20Patterns/Structural/Delegate/Delegate.md) allows object composition to achieve the same code reuse as inheritance [[code]](/Common%20Design%20Patterns/Structural/Delegate/Delegate.playground)
- [**Multicast Delegate:**](/Common%20Design%20Patterns/Structural/MulticastDelegate/MulticastDelegate.md) advanced version of `Delegate pattern` which allows multiple delegates to be notified about method calls [[code]](/Common%20Design%20Patterns/Structural/MulticastDelegate/MulticastDelegate.playground/Contents.swift)
- [**Coordinator:**](https://github.com/jVirus/coordinator-kit#%EF%B8%8F-coordinator-pattern) is an object that encapsulates lifecycle that is spread over a collection of view controllers [[code](https://github.com/jVirus/coordinator-kit/tree/master/coordinator-kit)]
- [**Type Erasure**](/Common%20Design%20Patterns/Structural/TypeErasure/TypeErasure.md) turns an associated type into a generic constraint. Resolves an issue that does not allow to treat a collection of objects that conform to a protocol with an associated type as a collection of regular protocols [[code](/Common%20Design%20Patterns/Structural/TypeErasure/TypeErasure.playground/Contents.swift)]
- **DAO:** - `DAO` stands for `Data Access Object`. `DAO` provides abstract interface to a database or other persistence storage mechanism
- **Adapter Pipeline:** use multiple adapters for debugging purposes
- **Retrofit Interface:** an adapter used as a new interface for multiple classes at the same time
- **Aggregate pattern:** a version of the Composite pattern with methods for aggregation of children
- **Tombstone:** an intermediate "lookup" object contains the real location of an object.
rise of new classes
- **Extensibility:** a.k.a. `Framework` - hide complex code behind a simple interface
- **Pipes and Filters:** a chain of processes where the output of each process is the input of the next
- **Opaque Pointer:** a pointer to an undeclared or private type, to hide implementation details
- **Humble Object:** extracts the logic into a separate easy-to-test component that is decoupled from its environment

## 🚅 Concurrency Design Patterns
> Concurrency patterns are those types of design patterns that deal with the multi-threaded programming paradigm.
>
> **Source:** [wikipedia.org](https://en.wikipedia.org/wiki/Concurrency_pattern)

- **Active Object:** decouples method execution from method invocation for objects that each reside in their own thread of control
- [**Balking Pattern:**](/Concurrency%20Design%20Patterns/BalkingPattern/BalkingPattern.md) executes an action on an object when the object is in a particular state
- [**Barrier:**](/Concurrency%20Design%20Patterns/Barrier/Barrier.md) is a type of synchronization method. A barrier for a group of threads or processes in the source code means any thread/process must stop at this point and cannot proceed until all other threads/processes reach this barrier
- **Binding Pattern:** combines multiple observers to force properties in different objects to be synchronized or coordinated in some way
- **Double-Checked Locking:** used to reduce the overhead of acquiring a lock by first testing the locking criterion (the "lock hint") without actually acquiring the lock. Only if the locking criterion check indicates that locking is required does the actual locking logic proceed
- **Guarded Suspension:** manages operations that require both a lock to be acquired and a precondition to be satisfied before the operation can be executed
- **Monitor Object:** is a synchronization construct that allows threads to have both mutual exclusion and the ability to wait (block) for a certain condition to become true
- **Nuclear Reaction:** is a type of computation which allows threads to either spawn new threads or converge many threads to one
- **Reactor:** is an event handling pattern for handling service requests delivered concurrently to a service handler by one or more inputs
- [**Read Write Lock:**](/Concurrency%20Design%20Patterns/ReadWriteLock/ReadWriteLock.md) allows concurrent access for read-only operations, while write operations require exclusive access [[code]](/Concurrency%20Design%20Patterns/ReadWriteLock/ReadWriteLock.playground/Contents.swift)
- **Scheduler:** is the method by which work specified by some means is assigned to resources that complete the work
- **Thread Pool:** maintains multiple threads waiting for tasks to be allocated for concurrent execution by the supervising program
- **Thread-Local Storage:** is a computer programming method that uses static or global memory local to a thread

## 🏛 Architectural Patterns
Architectural patterns addres issues that arise in software engineering within certain contexts. They are similar to design patterns, but have broader scope of responsibilities. Architectural patterns structure the way how software product/application/platform is built by separating different abstractions into reusable layers. Sometimes architectural patterns are documented as design patterns.

- **MVC:** is an architectural pattern commonly used for developing user interfaces that divides an application into three interconnected parts. This is done to separate internal representations of information from the ways information is presented to and accepted from the user. The `MVC` design pattern decouples these major components allowing for efficient code reuse and parallel development [[1](#references)]
- **MVP:** is a derivation of the model–view–controller (`MVC`) architectural pattern, and is used mostly for building user interfaces. In `MVP`, the presenter assumes the functionality of the "middle-man". In `MVP`, all presentation logic is pushed to the presenter [[1](#references)]
- **MVVM:** is a software architectural pattern that facilitates a separation of development of the graphical user interface – be it via a markup language or `GUI` code – from development of the business logic or back-end logic (the data model). The view model of `MVVM` is a value converter, meaning the view model is responsible for exposing (converting) the data objects from the model in such a way that objects are easily managed and presented [[1](#references)]
- **MVVM-C:** basically the same `MVVM` arcitectural pattern, but with an addition of `Routing` layer, which is `Coordinator` pattern
- **VIPER:** `VIPER` is an application of `Clean Architecture` to `iOS` apps. The word `VIPER` is a backronym for `View`, `Interactor`, `Presenter`, `Entity`, and `Routing`. `Clean Architecture` divides an app’s logical structure into distinct layers of responsibility. This makes it easier to isolate dependencies (e.g. your database) and to test the interactions at the boundaries between layers [[8](#references)]
- **RIBs:** is the cross-platform architecture framework developed by Uber. RIBs means: Router, Interactor and Builder, which are core components of this architecture. The key aspects of the architecure are: modible apps with large number of engineers and nested states [[10](#references)]
- **Clean-Swift:** is a derivarive architecture of the `Clean Archtiecure` proposed by Uncle Bob

## 🐦 Swift Patterns
> In `Swift`, there are two basic kinds of patterns: those that successfully match any kind of value, and those that may fail to match a specified value at runtime. 
>
>  The first kind of pattern is used for destructuring values in simple variable, constant, and optional bindings. These include wildcard patterns, identifier patterns, and any value binding or tuple patterns containing them. You can specify a type annotation for these patterns to constrain them to match only values of a certain type.
>
>  The second kind of pattern is used for full pattern matching, where the values you’re trying to match against may not be there at runtime. These include enumeration case patterns, optional patterns, expression patterns, and type-casting patterns. You use these patterns in a case label of a switch statement, a catch clause of a do statement, or in the case condition of an if, while, guard, or for-in statement.
>
> **Source:** [`swift.org`](https://docs.swift.org/swift-book/ReferenceManual/Patterns.html#//apple_ref/doc/uid/TP40014097-CH36-ID419)

The following patterns are not part of the `design patterns` topic. However, the presented `language patterns` are related to the `design patterns` theme, since they offer reusable solutions for common design scenarious when using the programming language. `IMHO` they are essential to master in order to realise that patterns are everywhere - language, constructions, architectures, approaches etc.

- [**Wildcard:**](/Swift%20Design%20Patterns/Wildcard/Wildcard.md) a wildcard pattern matches and ignores any value and consists of an underscore (_). Use a wildcard pattern when you don’t care about the values being matched against [[code]](/Swift%20Design%20Patterns/Wildcard/Wildcard.playground/Contents.swift)
- [**Identifier:**](/Swift%20Design%20Patterns/Identifier/Identifier.md) an identifier pattern matches any value and binds the matched value to a variable or constant name [[code](/Swift%20Design%20Patterns/Identifier/Identifier.playground/Contents.swift)]
- [**Value-Binding:**](/Swift%20Design%20Patterns/ValueBinding/ValueBinding.md) a value-binding pattern binds matched values to variable or constant names. Value-binding patterns that bind a matched value to the name of a constant begin with the let keyword; those that bind to the name of variable begin with the var keyword
- **Tuple Pattern:** a tuple pattern is a comma-separated list of zero or more patterns, enclosed in parentheses. Tuple patterns match values of corresponding tuple types
- **Enumeration Case:** an enumeration case pattern matches a case of an existing enumeration type. Enumeration case patterns appear in switch statement case labels and in the case conditions of `if`, `while`, `guard`, and `for-in` statements
- **Optional:** an optional pattern matches values wrapped in a `some(Wrapped)` case of an `Optional<Wrapped>` enumeration. Optional patterns consist of an identifier pattern followed immediately by a question mark and appear in the same places as enumeration case patterns
- **Type-Casting:** there are two type-casting patterns, the is pattern and the as pattern. The is pattern appears only in switch statement case labels
- **Expression:** an expression pattern represents the value of an expression. Expression patterns appear only in `switch` statement `case` labels

## 🧑‍🎨 Software Design Principles
There are numerous software design principles that help to create maintainable, scalable, and efficient software systems. These principles, along with other best practices, can guide developers in creating high-quality software systems that are easy to understand, maintain, and extend.

1. `SOLID` Principles:
  - `Single Responsibility` Principle (SRP): A class should have only one reason to change, which means it should have only one responsibility.
  - `Open/Closed` Principle (OCP): Software entities should be open for extension but closed for modification.
  - `Liskov Substitution` Principle (LSP): Subtypes should be substitutable for their base types without altering the correctness of the program.
  - `Interface Segregation` Principle (ISP): Clients should not be forced to implement interfaces they don't use; instead, create specific interfaces for each client.
  - `Dependency Inversion` Principle (DIP): High-level modules should not depend on low-level modules; both should depend on abstractions.   Additionally, abstractions should not depend on details; details should depend on abstractions.
2. `DRY` (Don't Repeat Yourself): Avoid duplicating code and functionality; aim for modularity and reusability.
3. `KISS` (Keep It Simple, Stupid): Design should be as simple as possible, and complexity should be avoided whenever possible.
4. `YAGNI` (You Aren't Gonna Need It): Do not implement features or functionality until they are actually needed, as it can lead to unnecessary complexity.
5. `Separation of Concerns` (SoC): Divide your application into distinct sections, each with a specific responsibility, to improve maintainability and modularity.
6. `Encapsulation`: Bundle data and the methods that operate on that data within a single unit, thereby hiding the internal state and implementation details from other parts of the system.
7. `Composition over Inheritance`: Favor object composition over class inheritance to promote flexibility and avoid issues related to deep inheritance hierarchies.
8. `Law of Demeter` (LoD) / Principle of Least Knowledge: An object should only communicate with its immediate neighbors and should not have knowledge of the inner workings of other objects.
9. `Principle of Proximity`: Related code and functionality should be placed close together, promoting cohesion and making it easier to understand the relationships between components.
10. `Fail-Fast`: Design the system to fail as soon as possible when something goes wrong, making it easier to identify and fix problems.
11. `GRASP` (General Responsibility Assignment Software Patterns):
  - `Information Expert`: Assign a responsibility to the class that has the necessary information.
  - `Creator`: Assign the responsibility of creating an object to the class that uses it the most or has the necessary information to create it.
  - `Controller`: Assign the responsibility of handling external events to a specific class, often referred to as a controller.
  - `Low Coupling`: Minimize dependencies between classes to promote modularity and ease of maintenance.
  - `High Cohesion`: Keep related responsibilities within the same class, making the class easier to understand and maintain.
  - `Polymorphism`: Use inheritance and interfaces to create flexible and reusable solutions.
  - `Pure Fabrication`: Create artificial classes to achieve low coupling and high cohesion when necessary.
  - `Indirection`: Introduce an intermediate class to manage relationships between other classes, reducing coupling.
  - `Protected Variations`: Identify points of potential variation and create stable interfaces around them to minimize the impact of changes.
12. `Convention Over Configuration`: Establish sensible defaults and conventions to minimize the amount of configuration required, making it easier for developers to work with the system.
13. `Code Reuse`: Reuse existing code, libraries, or frameworks instead of reinventing the wheel. This saves time and effort and often results in more stable and efficient solutions.
14. `Incremental Development`: Develop and deliver software in small, manageable increments, allowing for rapid feedback and adjustment.
15. `Test-Driven Development` (TDD): Write tests before writing the actual code, ensuring that code meets the desired specifications and improving the overall quality of the software.
16. `Continuous Integration` (CI) and Continuous Delivery (CD): Integrate code changes frequently and automatically, and deploy updates to production with minimal human intervention. This promotes rapid feedback and reduces the risk of introducing errors.
17. `Principle of Least Astonishment`: Design the software so that its behavior is predictable and intuitive, minimizing surprises for users and developers.
18. `Scalability`: Design the system to handle increased workload efficiently by adding more resources or optimizing resource utilization.
19. `Modularity`: Break down a complex system into smaller, manageable modules that can be developed, tested, and maintained independently.
20. `Maintainability`: Design the software to be easy to understand, modify, and extend, allowing for efficient long-term maintenance.
21. `Readability`: Write code that is easy to read and understand, which makes it easier for others (and yourself) to maintain and modify the software.
22. `Self-Documenting Code`: Write code that clearly communicates its intent, reducing the need for separate documentation and making it easier to maintain.
23. `Loose Coupling`: Strive to minimize dependencies between components, allowing them to evolve independently and reducing the risk of cascading changes.
24. `Orthogonality`: Design components to have a single, well-defined responsibility and ensure that their behavior is independent of other components. This makes the system more modular, maintainable, and less error-prone.
25. `Principle of Least Privilege`: Give components the minimum level of access and authority required to perform their tasks, reducing the potential impact of security breaches or bugs.
26. `Defensive Programming`: Write code that anticipates and handles potential errors and exceptional situations, ensuring that the system remains stable and secure even in unexpected circumstances.
27. `Design by Contract`: Clearly define the responsibilities and expectations of components (preconditions, postconditions, and invariants), improving the overall robustness and reliability of the system.
28. `Feature Toggle`: Use feature flags or toggles to enable or disable features in the software, allowing for easier management of experimental features and phased rollouts.
29. `Continuous Improvement`: Regularly review and refine the codebase, adopting new best practices and technologies as they emerge, and addressing technical debt to keep the system maintainable and efficient.
30. `Domain-Driven Design` (DDD): Focus on the core domain and its logic, using a common language (ubiquitous language) among developers and domain experts, and creating a model that accurately represents the domain.
31. `Separation of Interface and Implementation`: Keep the interface of a component separate from its implementation, allowing for flexibility and interchangeability without affecting the rest of the system.
32. `Code Consistency`: Establish and follow coding standards and conventions across the entire codebase, making it easier to read, understand, and maintain.
33. `Performance Optimization`: Design the software with performance in mind, using appropriate data structures, algorithms, and techniques to minimize resource usage and response times.
34. `Flexibility and Adaptability`: Design the system to be easily modified and extended to accommodate changing requirements and new features.
35. `Security by Design`: Integrate security best practices and considerations into every stage of the software development process, minimizing the risk of vulnerabilities and breaches.
36. `Cost-Effective Development`: Strive to balance the trade-offs between development time, code quality, and performance, aiming for a cost-effective approach that meets the project requirements.
37. `Design Patterns`: Leverage proven design patterns that solve common problems, making the code more reusable, modular, and maintainable.
38. `Antifragility`: Design systems that not only tolerate failures and stress but also improve and adapt when faced with challenges.
39. `Microservices Architecture`: Decompose a monolithic system into smaller, loosely-coupled services, each with a single responsibility, which can be developed, deployed, and scaled independently.
40. `Resource Management`: Ensure efficient allocation, use, and release of resources (e.g., memory, file handles, sockets) to prevent leaks and other performance issues.
41. `Cross-Platform Compatibility`: Design the software to work across multiple platforms and environments, ensuring a consistent user experience and broad accessibility.
42. `Versioning`: Implement version control for both code and APIs, enabling better collaboration, easier rollback of changes, and compatibility between different versions of the software.
43. `Design for Testability`: Develop the software in a way that facilitates testing at various levels (unit, integration, system), ensuring that issues can be identified and addressed early in the development process.
44. `Monitoring and Observability`: Build monitoring and observability features into the system, allowing for easy identification and diagnosis of issues in production environments.
45. `Design for Accessibility`: Consider the needs of users with disabilities, ensuring that the software is usable by as many people as possible.
46. `Localization and Internationalization`: Design the software to support multiple languages, currencies, and cultural conventions, making it easier to adapt the product for different regions.
47. `Graceful Degradation`: Ensure that the software continues to function, albeit with reduced capabilities, in the face of partial failures or adverse conditions.
48. `Progressive Enhancement`: Start with a basic, functional version of the software and incrementally add enhancements, ensuring that the application remains usable and accessible even on older or less-capable devices.
49. `Cache Management`: Use caching techniques to store and quickly retrieve frequently used data, improving performance and reducing the load on external systems.
50. `Responsiveness`: Design the software to provide quick and timely feedback to user actions, ensuring a smooth and satisfying user experience.


# 📝 References
There were used a number of reference materials such as:

1. [Wikipedia](https://www.wikipedia.org)
2. [swift.org](https://www.swift.org)
3. [Apple Developer Portal](https://developer.apple.com)
4. [Design Patterns: Elements of Reusable Object-Oriented Software](http://www.blackwasp.co.uk/GangOfFour.aspx)
5. [SOLID](https://en.m.wikipedia.org/wiki/SOLID)
6. [Swift Patterns](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Patterns.html#//apple_ref/doc/uid/TP40014097-CH36-ID419)
7. [Coordinator Pattern](http://khanlou.com/2015/01/the-coordinator/)
8. [VIPER Architecture](https://www.objc.io/issues/13-architecture/viper/)
9. [Code Complete. Wikipedia](https://en.wikipedia.org/wiki/Code_Complete)
10. [RIBs. GitHub](https://github.com/uber/RIBs)

# 🙋‍♀️🙋‍♂️ Contributing
Your contributions to this project are warmly welcomed! To ensure a smooth collaboration, please follow these guidelines:

- If you want to implement example code for an existing Design Pattern, wrap it up in a `.playground` file. This way, code compilation is as simple as launching the file, and there's no need to manage a large `Xcode` project.
- If you want to write about a Design Pattern that's on the list but hasn't been implemented yet, adhere to the following style guide:
  - Write a clear description of the design pattern.
  - Divide the example code into subsections.
  - Provide explanations for each code snippet.
  - Keep your example simple and avoid unnecessary details.
  - Conclude with a summary highlighting the pattern's key points.
- If you want to write about a Design Pattern or Design Principle not on the list, follow the rules mentioned above and add a brief description along with the pattern's category.
- If you notice an important detail missing in an existing Design Pattern or Design Principle, kindly point it out in a polite manner. Providing more details and arguments will make it easier to address the issue.

# 👨‍💻 Author 
[Astemir Eleev](https://github.com/jVirus)

# 🔖 Licence
The project is availabe under [MIT licence](https://github.com/jVirus/ios-design-patterns/blob/master/LICENSE).
