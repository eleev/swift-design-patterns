import Foundation

protocol ObjectPoolItem: class {
    
    /// Determines a rule that is used by the ObjectPool instnace to determine whether this object is eligible to be reused
    var canReuse: Bool { get }
    
    /// Resets the state of an instnace to the default state, so the next ObjectPool consumers will not have to deal with unexpected state of the enqueued object.
    ///
    /// WARNING: If you leave this method without an implementation, you may get unexpected behavior when using an instance of this object with ObjectPool
    func reset()
}

class ObjectPool<T: ObjectPoolItem> {
    
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
    
    // MARK: - Properties
    
    private var objects = [T]()
    private var semaphore: DispatchSemaphore
    private var queue = DispatchQueue(label: "objectPool.concurrentQueue", attributes: .concurrent)
    
    private var count: Int = 0
    
    var isDrained: Bool {
        return objects.isEmpty
    }
    
    var state: PoolState {
        var state: PoolState = .undefined
        
        queue.sync(flags: .barrier) {
            let currentCount = objects.count
            
            if objects.isEmpty {
                state = .drained
            } else if currentCount == count {
                state = .full(count: count)
            } else if currentCount < count, !objects.isEmpty {
                state = .deflated(count: currentCount)
            }
        }
        return state
    }
    
    // MARK: - Initializers

    init(objects: [T]) {
        self.objects.reserveCapacity(objects.count)
        semaphore = DispatchSemaphore(value: objects.count)
        
        self.objects += objects
        count = objects.count
    }
    
    convenience init(objects: T...) {
        self.init(objects: objects)
    }
    
    deinit {
        for _ in 0..<objects.count {
            semaphore.signal()
        }
    }
    
    // MARK: - Mehtods
    
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

let resourceOne = Resource(value: 1)
let resourceTwo = Resource(value: 2)
let resourceThree = Resource(value: 3)

let objectPool = ObjectPool<Resource>(objects: resourceOne, resourceTwo, resourceThree)
print("pool state: ", objectPool.state as Any)

print("Object Pool has been created")
let poolObject = objectPool.dequeue()
print("pooled object: ", poolObject?.value as Any)

print("pool state: ", objectPool.state as Any)

poolObject?.value = 5
objectPool.enqueue(object: poolObject!) {
    switch $0 {
    case .reused:
        print("Item was reused by the pool")
    case .rejected:
        print("Item was reject by the pool")
    }
}

print("pool state: ", objectPool.state)
print("\n")

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

