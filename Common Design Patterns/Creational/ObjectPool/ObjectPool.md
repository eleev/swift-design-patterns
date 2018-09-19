# Object Pool Design Pattern
`Object Pool` is a creational design pattern that is used to manage a collection of reusable objects that are inefficient to create many times and thus they need to be reused. The other reason to reuse objects is that they only needed for a short perfiod of time, so they can be reused and as a result it positively affects the performance of an entire application. 

The pattern incapsulates the logic that is responsible for storing, pooling and returning objects. The calling component retreives an object from the pool, uses it and then returns it back to the pool. 

## Object Pool Item
We are going to start off from declaring a protocol that will be used to help the `Object Pool` to reuse or not to reuse objects and to reset their states. 

```swift
protocol ObjectPoolItem: class {
    
    /// Determines a rule that is used by the ObjectPool instnace to determine whether this object is eligible to be reused
    var canReuse: Bool { get }
    
    /// Resets the state of an instnace to the default state, so the next ObjectPool consumers will not have to deal with unexpected state of the enqueued object
    ///
    /// WARNING: If you leave this method without an implementation, you may get unexpected behavior when using an instance of this object with ObjectPool
    func reset()
}
```
The `ObjectPoolItem` protocol provides two mechanisms for the conforming types. The first one is `canReuse` property. The conforming type may implement a type-related logic that will be used by the `ObjectPool` to determine whether such an object can be reused or not. 

The other mechanism is the `reset` method. That method is used to reset the state of the conforming type. Storing clones for object pool items inside the `ObjectPool` in order be able to reset them is inefficient. That is why we need to provide a way to reset them somehow else. Since an object may have private or read-only properties that cannot be reset outside of the type itself, we need to delegate resetting to each conforming type. However, `ObjectPool` calls this method when needed. 

## Object Pool
Our `ObjectPool` will be capable of storing any object that conforms to the presented `ObjectPoolItem` protocol. Let's declare that:

```swift
class ObjectPool<T: ObjectPoolItem> {
```
Next, we define enums that describe the possible states of the pool and the stored items:

```swift 
// MARK: - States
    
    /// Determines the condition of the pool
    ///
    /// - drained: Empty state, meaning that there is nothing to dequeue from the pool
    /// - deflated: Consumed state, meaning that some items were dequeued from the pool
    /// - full: Filled state, meaning that the full capacity of the pool is used
    /// - undefined: Intermediate state, rarely occurs when many threads modify the pool at the same time
    enum PoolState {
        case drained
        case deflated(count: Int)
        case full(count: Int)
        case undefined
    }
    
    /// Defines the states of a pool's item. The state is determined by the pool
    ///
    /// - reused: Item is eligable to be reused by the pool
    /// - rejected: Item cannot be reused by the pool since the reuse policy returned rejection
    enum ItemState {
        case reused
        case rejected
    }
```

There are `four` states for the pool: *drained*, *deflated*, *full* and *undefined*. The example code has detailed explanation for each one. Also we defined an enum called `ItemState`, which contanis `two` cases for *reused* and *rejected* states. 

`ObjectPool` will



## Usage

## Pitfalls
`Object Pool` is responsible for resetting states of the returned objects, since otherwise it will lead to unexpected behavior of the reused objects. If not done correctly that leads to *anti-pattern*. For instance data-base connection may be set to one state when pooled for the first time, then returned back without resetting the state and later on pooled again but expected behavior will be provided. The operations that will be performed using such a connection will be valid and may even damage data integrity of your data-base. Such an issue is hard to diagnose and debug.

Also a great deal of attention needs to be paid to ensure that concurrent access will not break you program, as well as it may lead to unexpected behavior or make an application unstalbe to use. 

## Conclusion