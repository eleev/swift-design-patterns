# Singleton Design Pattern

Singleton is a creational design pattern that restricts instantiation of a class to one object. 

In order to implement this pattern we need to mark the initializers as `private` and create a `static` property that contains the `instance` of `self`:

```swift
public class Singleton {
    
    // MARK: - Singleton property
    
    public static let instance = Singleton()
    
    // MARK: - Properties
    
    public private(set) var counter: Int
    
    // MARK: - Private initializer
    
    private init() {
        // Private initializer ensures that there will not access it from the outside, so instances can only be created inside the class
        counter = 0
    }
    
    // MARK: - Methods
    
    public func foo() {
        print(#function + " foo")
    }
    
    public func bar() {
        print(#function + " bar")
    }
    
    public func increment() {
        counter += 1
    }
    
    public func decrement() {
        counter -= 1
    }
}
```

This implementation is valid in modern `Swift` development and is pretty popular way to implement singletons. 

```swift
let singleton = Singleton.instance
singleton.counter					
// 0
singleton.increment()
// incremented using the first shared instance
singleton.counter
// 1

let anotherSingleton = Singleton.instance
anotherSingleton.counter
// 1
anotherSingleton.increment()
// incremented using the second shared instance
singleton.counter					
// 2
```


## The Struct way
In `Swift 1.0` classes didn't support static class variables. However, `structs` did static variables! The restrictions forced the developers to use this pretty strange approach to create singletons:

```swift
public class StructSignleton {
    
    // MARK: - Shared instance class property
    
    public class var sharedInstance: StructSignleton {
        struct Static {
            static let instance = StructSignleton()
        }
        return Static.instance
    }
    
    // MARK: - Properties
    
    public private(set) var counter: Int = 0
    
    // MARK: - Methods
    
    public func foo() {
        print(#function + " foo")
    }
    
    public func bar() {
        print(#function + " bar")
    }
    
    public func increment() {
        counter += 1
    }
    
    public func decrement() {
        counter -= 1
    }
}

```

This approached was quite popular back then. `Swift` didn't support `access control modifiers` until `1.2` version, so we were not able to create `private` initializer as well. However in modern `Swift` we can eliminate that boilerplate construction with nested `class` and `struct` and use more elegant way of creating singletons. 

## Conclusion
If misused, `Singleton` may become `anti-pattern` since the data may be mutated concurrently from different places of an application using the same shared instance. It will lead to unexpected results that are hard to diagnose and fix. It may be resolved by using some sort of `locking` mechanism in order to prevent the access to the `critical section` from several threads at the same time. However concurrency and multithreading are pretty advanced topics and they bring another class of possible issues, just beware of that.

Another issue with the pattern is that the access to the state of the objects is shared, which not only leads to `concurrency` and `data corruption` issues, but just unexpected behavior when working with such  an object. 
