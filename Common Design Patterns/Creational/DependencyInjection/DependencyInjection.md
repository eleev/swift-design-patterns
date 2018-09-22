# Dependency Injection Design Pattern
`Dependency Injection` is a structural design pattern that is aimed to *decouple* the implementation of a behavior from its interface, or simply it provides means for giving an object its instance variables. 

> Dependency injection means giving an object its instance variables. Really. That’s it.
> 
> [James Shore](https://www.jamesshore.com/Blog/Dependency-Injection-Demystified.html)

The pattern is implemented by making the dependent properties to be passed from outside, that makes acquiring dependencies someone else's problem. It's important to note that it's preferable to use protocols rather than concrete types as *injectables*. That is because using protocols we are able to replace concrete implementation used at run-time by mock objects or subs, which makes tests far more easier and even in some circumstances  just possible. *Dependency Injection* makes coupling more weaker between a type and its dependencies. Another advantage is that a type can be flexibly configured with various injectable dependencies, make a type to be easily reconfigurable without additional compilation.

Concurrently, two or more developers can implement types that implement this pattern: while the first developer implements the type (a.k.a *client*), the other developers implement the *dependencies*. However, the communication protocol between the *client* and its *dependencies* needs to be establish first. The pattern removes all the nitty-gritty details from a client, related to the knowledge of a concrete implementation that it expects. 

The pattern is simple yet powerful. However, it has its own disadvantages, which will be overviewed in a dedicated section later on.

## Initializer Injection
`Initializer` injection is a type of *DI* that passes a dependency into the initializer and captures it for the later use. 

> **Note:**
>
> Please not note that common term for this type of injection is `Constructor Injection`. I used `Initializer` since `Swift` does not have *contructors*, only *initializers*. That was done for the sake of adoptation of the pattern and to avoid confusion with the term (*constructor*) that does not have practical application in `Swift`.


## Property Injection

## Method Injection

## Protocol Injection

## Storyboards & View Controllers

## Testability

## Disadvantages

## Conclusion


  