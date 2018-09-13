import Foundation

protocol Notification: class {
    var data: Any? { get }
}

protocol Observer: class {
    func notify(with notification: Notification)
}

class Subject {
    
    // MARK: - Inner classes
    
    private final class WeakObserver {
        
        // MARK: - Properties
        
        weak var value: Observer?
        
        // MARK: - Initializers
        
        init(_ value: Observer) {
            self.value = value
        }
    }
    
    // MARK: - Properties
    
    private var observers = [WeakObserver]()
    private var queue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    
    // MARK: - Subscripts
    
    /// Convenience subscript for accessing observers by index, returns nil if there is no object found
    public subscript(index: Int) -> Observer? {
        get {
            guard index > -1, index < observers.count else {
                return nil
            }
            return observers[index].value
        }
    }
    
    /// Searches for the observer and returns its index
    public subscript(observer: Observer) -> Int? {
        get {
            guard let index = observers.index(where: { $0.value === observer }) else {
                return nil
            }
            return index
        }
    }
    
    // MARK: - Methods
    
    func add(observer: Observer) {
        // .barrier flag ensures that within the queue all reading is done before the below writing is performed and pending readings start after below writing is performed
        queue.sync(flags: .barrier) {
            self.observers.append(WeakObserver(observer))
        }
    }
    
    /// Removes an Observer. The difference between dispose(observer:) and this method is that this method immediately removes an observer.
    ///
    /// - Parameter observer: is an Observer to be removed immediately
    func remove(observer: Observer) {
        queue.sync(flags: .barrier) {
            guard let index = self[observer] else {
                return
            }
            self.observers.remove(at: index)
        }
    }
    
    /// Sends notification to all the Observers. The method is executed syncronously.
    ///
    /// - Parameter notification: is a type that conforms to Notification protocol
    func send(notification: Notification) {
        queue.sync {
            recycle()
            
            for observer in observers {
                observer.value?.notify(with: notification)
            }
        }
    }
    
    /// Disposes an observer. The difference between remove(observer:) and this method is that this method delays observer removal until the recycle method will be called (the next time when a new Notification is sent)
    ///
    /// - Parameter observer: is an Observer to be disposed
    func dispose(observer: Observer) {
        queue.async(flags: .barrier) { [weak self] in
            if let index = self?[observer] {
                self?.observers[index].value = nil
            }
        }
    }
    
    // MARK: - Private
    
    private func recycle() {
        for (index, element) in observers.enumerated().reversed() where element.value == nil {
            observers.remove(at: index)
        }
    }

}

// Removal of Observer
infix operator --=

// Disposal of Observer
infix operator -=

extension Subject {
    static func +=(lhs: Subject, rhs: Observer) {
        lhs.add(observer: rhs)
    }
    
    static func +=(lhs: Subject, rhs: [Observer]) {
        rhs.forEach { lhs.add(observer: $0) }
    }
    
    static func --=(lhs: Subject, rhs: Observer) {
        lhs.remove(observer: rhs)
    }
    
    static func --=(lhs: Subject, rhs: [Observer]) {
        rhs.forEach { lhs.remove(observer: $0) }
    }
    
    
    static func -=(lhs: Subject, rhs: Observer) {
        lhs.dispose(observer: rhs)
    }
    
    static func -=(lhs: Subject, rhs: [Observer]) {
        rhs.forEach { lhs.dispose(observer: $0) }
    }
    
    static func ~>(lhs: Subject, rhs: Notification) {
        lhs.send(notification: rhs)
    }
    
    static func ~>(lhs: Subject, rhs: [Notification]) {
        rhs.forEach { lhs.send(notification: $0) }
    }
}

//public final class Disposable {
//
//    private let recycle: () -> ()
//
//    init(_ recycle: @escaping () -> ()) {
//        self.recycle = recycle
//    }
//
//    deinit {
//        recycle()
//    }
//
//    public func add(to bag: DisposeBag) {
//        bag.insert(self)
//    }
//
//    public func dispose() {
//        recycle()
//    }
//}
//
//public class DisposeBag {
//    /// Keep a reference to all Disposable instances -> this is the actual bag
//    private let disposables = Atomic<[Disposable]>([])
//
//    /// To be able to create a bag
//    public init() {}
//
//    /// Called by a Disposable instance
//    fileprivate func insert(_ disposable: Disposable) {
//        disposables.apply { _disposables in
//            _disposables.append(disposable)
//        }
//    }
//
//    /// Clean everything when the bag is deinited by calling dispose()
//    /// on all Disposable instances
//    deinit {
//        disposables.apply { _disposables in
//            _disposables.forEach { $0.dispose() }
//        }
//    }
//}
//
//private class UnfairLock {
//    private let _lock: os_unfair_lock_t
//
//    fileprivate init() {
//        _lock = .allocate(capacity: 1)
//        _lock.initialize(to: os_unfair_lock())
//    }
//
//    fileprivate func lock() {
//        os_unfair_lock_lock(_lock)
//    }
//
//    fileprivate func unlock() {
//        os_unfair_lock_unlock(_lock)
//    }
//
//    deinit {
//        _lock.deallocate()
//    }
//}
//
//internal class Atomic<Value> {
//    private let lock = UnfairLock()
//    private var _value: Value
//
//    internal init(_ value: Value) {
//        _value = value
//    }
//
//    internal func apply(_ action: (inout Value) -> Void) {
//        lock.lock()
//        defer { lock.unlock() }
//        action(&_value)
//    }
//}

class ObserverOne: Observer {
    
    func notify(with notification: Notification) {
        print("Observer One: " , notification)
    }
    
}

class ObserverTwo: Observer {
    
    func notify(with notification: Notification) {
        print("Observer Two: " , notification)
    }
    
}

class ObserverThree: Observer {
    
    func notify(with notification: Notification) {
        print("Observer Three: " , notification)
    }
    
}

final class EmailNotification: Notification {
    
    // MARK: - Conformance to Notification protocol
    
    var data: Any?
    
    // MARK: - Initializers
    
    init(message: String) {
        data = message
    }
}

extension EmailNotification: CustomStringConvertible {
    var description: String {
        return "data: \(data as Any)"
    }
}

let observerOne = ObserverOne()
var observerTwo: ObserverTwo? = ObserverTwo()
let observerThree = ObserverThree()

let subject = Subject()
subject += [observerOne, observerTwo!, observerThree]


subject.send(notification: EmailNotification(message: "Hello Observers, this messag was sent from the Subscriber!"))

let notificationOne = EmailNotification(message: "Message #1")
let notificationTwo = EmailNotification(message: "Message #2")
let notificationThree = EmailNotification(message: "Message #3")

subject ~> [notificationOne, notificationTwo, notificationThree]

subject --= observerThree

subject ~> notificationOne

observerTwo = nil
print("Observer Two was set to nil: ", observerTwo as Any)

subject ~> [notificationOne, notificationTwo, notificationThree]

