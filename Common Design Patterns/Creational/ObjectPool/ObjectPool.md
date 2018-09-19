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
        case deflated(size: Int)
        case full(size: Int)
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

`ObjectPool` needs to store the items, hold a *semaphore* and a *dispatch queue* (will be explined later), as well as privetly store the initial *size*. The only property that will be accessable as read-only is a *state* property:

```swift
	// MARK: - Properties
    
    private var objects = [T]()
    private var semaphore: DispatchSemaphore
    private var queue = DispatchQueue(label: "objectPool.concurrentQueue", attributes: .concurrent)
    
    private var size: Int = 0
    
    var state: PoolState {
        var state: PoolState = .undefined
        
        queue.sync(flags: .barrier) {
            let currentSize = objects.count
            
            if objects.isEmpty {
                state = .drained
            } else if currentSize == size {
                state = .full(size: size)
            } else if currentSize < size, !objects.isEmpty {
                state = .deflated(size: currentSize)
            }
        }
        return state
    }
```
Next, we are going to implement the initializers and a deinitializer for our *semaphore*:

```swift
	// MARK: - Initializers

    init(objects: [T]) {
        self.objects.reserveCapacity(objects.count)
        semaphore = DispatchSemaphore(value: objects.count)
        
        self.objects += objects
        size = objects.count
    }
    
    convenience init(objects: T...) {
        self.init(objects: objects)
    }
    
    deinit {
        for _ in 0..<objects.count {
            semaphore.signal()
        }
    }
```
We have implemented a designated initializer, a convenience initializer and a deinitializer. The designated initializer accepts an array of objects that are of type `T`, it reserves a capacity for the provided array size, creates a *semaphore*, appends *objects* to the internal data source and sets the default *ObjectPool* size. The convenience initializer provides a *vararg* parameter rather than an array and the deinitializer signals the semaphore to unlock the `dequeue` method, if it's being used at that particular moment in time.


```swift
	// MARK: - Methods
    
    func enqueue(object: T, shouldResetState: Bool = true, completion: ((ItemState)->())? = nil) {
        queue.async {
            var itemState: ItemState = .rejected
            
            if object.canReuse {
                if shouldResetState {
                    // Reset the object state before returning it to the pool, so there will not be ambiguity when reusing familiar object but getting a different  behavior  because some other resource changed the object's state before
                    object.reset()
                }
                
                self.objects.append(object)
                self.semaphore.signal()
                
                itemState = .reused
            }
            completion?(itemState)
        }
    }
    
    func dequeue() -> T? {
        var result: T?
        
        if semaphore.wait(timeout: .distantFuture) == .success {
            queue.sync(flags: .barrier) {
                result = objects.removeFirst()
            }
        }
        return result
    }
}
```
The final part of the implementation of the pattern is the methods section. We have implemented two methods: `enqueue(object: , shouldResetState: Bool, completion:)` that is responsible for returning an item to the *ObjectPool*, by default resetting its state and calling the completion closure that returns an item state enum. The final method is `dequeue() -> T?` that pools an intem from the *ObjectPool* and returns it.

### About Concurrency

`DispathSemaphore` is used to prevent multiple threads to get access to the same `ObjectPool` item. Since we use `DispatchQueue` to prevent data modification of the `objects` array and ensure that no two (or many more) threads use *enqueue* and *dequeue* methods at the same time. I made `dequeue` method to be sync the object removal, and `enqueue` method to be able to asyncronously append items to the *ObjectPool* back. Each time an object is returned to the `objects` array, the *semaphore* is signaled to incremet its index, so the client that calls `dequeue` method will be able to get an *ObjectPool* item, rather than *wait*  until the *semaphore* will be signaled. 

## Usage

We need to implement a class that will conform to the `ObjectPoolItem` protocol first:

```swift
class Resource: ObjectPoolItem, CustomStringConvertible {
    
    // MARK: - Properties
    
    var value: Int
    private let _value: Int
    
    // MARK: - Initializers
    
    init(value: Int) {
        self.value = value
        self._value = value
    }
    
    // MARK: - Conformance to CustomStringConvertible prtocol
    
    var description: String {
        return "\(value)"
    }
    
    // MARK: - Conformance to ObjectPoolItem protocol
    
    var canReuse: Bool {
        return true
    }
    
    func reset() {
        value = _value
    }   
}
``` 
The implementation is quite simple, we just wrapped an `Int` value for the demonstration purposes.

```swift
let resourceOne = Resource(value: 1)
let resourceTwo = Resource(value: 2)
let resourceThree = Resource(value: 3)

let objectPool = ObjectPool<Resource>(objects: resourceOne, resourceTwo, resourceThree)
// Pool State: full(size: 3)

// Dequeue an item from the main thread:
let poolObject = objectPool.dequeue()
// poolObject: Optional(1)
// Pool State: deflated(size: 2)

// Then we change the poolObject state by setting new 5 to the `value` property
poolObject?.value = 5

// That changes the state of the object, so when we return that object back to pool we dequeue it again, we should get the resetted object (with value = 1)

objectPool.enqueue(object: poolObject!) {
    switch $0 {
    case .reused:
        print("Item was reused by the pool")
    case .rejected:
        print("Item was reject by the pool")
    }
}
// Will be printed: Item was reused by the pool
```

We have created three instances of `Resource` class, an instance of `ObjectPool` class with the resoruce instnaces. Then we check the state of the pool, dequeue item, change its state and enqueue that item back to the pool. Everything has been done in the main thread, but we have implemented concurrency protection, let's write some `async` code:

```swift
DispatchQueue.global(qos: .default).async {
    for _ in 0..<5 {
        let poolObject = objectPool.dequeue()
        
        print("iterator #1, pool object: ", poolObject as Any)
        print("iterator #1, pool state: ", objectPool.state)
        print("\n")
    }
}

DispatchQueue.global(qos: .default).async {
    for _ in 0..<5 {
        let poolObject = objectPool.dequeue()
        
        print("iterator #2, pool object: ", poolObject as Any)
        print("iterator #2, pool state: ", objectPool.state)
        print("\n")
    }
}
```



## Pitfalls
`Object Pool` is responsible for resetting states of the returned objects, since otherwise it will lead to unexpected behavior of the reused objects. If not done correctly that leads to *anti-pattern*. For instance data-base connection may be set to one state when pooled for the first time, then returned back without resetting the state and later on pooled again but expected behavior will be provided. The operations that will be performed using such a connection will be valid and may even damage data integrity of your data-base. Such an issue is hard to diagnose and debug.

Also a great deal of attention needs to be paid to ensure that concurrent access will not break you program, as well as it may lead to unexpected behavior or make an application unstalbe to use. 

## Conclusion