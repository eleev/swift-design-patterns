# Observer Desing Pattern
`Observer` is a behavioral design pattern that is aimed to simplify communication between objects by providing means for notification handling and incapsulating logic around communication, without the need know how exactly those notifications are processed and sent to the observers.The pattern decreases coupling between objects that listen for events and an object that raises them. `Observer` pattern decouples their relationship by separating objects into two layers called `Observer` and `Subject`. 

`Observer` is represented as a protocol that defines common interface for communication. `Subject` is an object that emits events and sends them to multiple *Observers*. That forms *one-to-many* relationship, where one *Subject* sends notifications to many *Observers*. As a *notification* we may use a common protocol and in some implementations concrete classes, structs or enum types. 

The pattern has some similarities with `Multicast Delegate` and `Event Listener`, however *Observer* is different pattern and has its own applications.

## Observers
In order to implement the pattern, we start off from defining the `Observer` protocol. The protocol will be used for each type that requires to receive notifications from an emitter:

```swift
protocol Observer: class {
    func notify(with notification: Notification)
}
```
The protocol defines a single method called `notify(with notification:)`. This method will be called by the `Subject` (a.k.a. emitter). The parameter of type `Notification` is represented as a protocol:

```swift
protocol Notification: class {
    var data: Any? { get }
}
```
`Notification` protocol defines the base interface for all kinds of notifications that are sent by the *Subject* to all the *Observera*. The protocol contains a signle property that represents any data. We will implement the concrete notification type for type-safety a bit later. 

## Subject
The next step is to implement the `Subject` layer. It's going to be a class with a number of method such as:

- Add an Observer - adds a new *Observer* to the list of observers for a particular `Subject`
- Remove an Observer - immediately removes an *Observer* from a `Subject`
- Send Notification - send a *Notification* to all the *Observers*
- Dispose an Observer - waits until the next notification will be sent to remove an *Observer* 

Our implementation is minimal and pretty intuitive. You may extend the functionality to, for example, add support for `willSend(notification:)` and `didSend(notification:)` for more complicated notification handling.

### Weak Observer

In order to be able to manage a collection of observers, we need to store them. By directly holding the references of objects we create `retain-cycle`, which leands to memory leaks. That is why we crete a wrapper type called `WeakObserver` that weakly holds a reference to an observer:

```swift
private final class WeakObserver {
        
	// MARK: - Properties
        
	weak var value: Observer?
        
	// MARK: - Initializers
        
	nit(_ value: Observer) {
		self.value = value
	}
}
```
The class declared as `private final` since it's declared inside the `Subject` class. We don't need to expose the way we manage the internals of our `Subject` by marking `WeakObserver` as `internal or public`, since the whole point of making an intermediate abstraction layer will be lost in this case. In a minute you will see how this class is used to manage a collection of observeres.

## Subject Class

The implementation of `Subject` class has many similarities with `Multicast Delegate` class: we store a collection observers and hide all the notification sending code and recycling of observers hidden. We will break down the implementation step by step, starting from properties:

```swift
class Subject {

    // MARK: - Properties
    
    private var observers = [WeakObserver]()
    private var queue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)

...    
```
We have declared two properties: one to keep track of all the attached observers, and the other one for making safe concurrent access to the non thread-safe collection. 

Next, we implement the `API`:

```swift
...
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
        queue.sync(flags: .barrier) {
            if let index = self[observer] {
                observers[index].value = nil
            }
        }
    }
...
```
There is a bit of code to digest. First of all we create a method that grants thread-safe addition of a new *Observer* by making it syncronious. We use `barrier` lock in a form of a flag parameter to the `sync(flags: .barrier)` method. The lock is used to restrict the readings over writings, making sure that 
we won't be able to attemt to delete an `Observer` that has already been removed. 

The next method is `remove(observer:)` - which gets an observer instance, finds it and immediately removed from the collection. You may be wondering, what this line in remove method means: `self[observer]`. It's a custom `subscript` and we take a closer took in [Swiftification](swiftification) section.

Then we implemented `send(notification:)` method that syncronously calls `notify(with:)` method for each observer in the collection of observers. However before calling sending the notifications, it calls `recycle` method, that has the following implementation:

```swift
...
	// MARK: - Private
    
    private func recycle() {
        for (index, element) in observers.enumerated().reversed() where element.value == nil {
            observers.remove(at: index)
        }
    }
}
```
This method simply iterates over the observers and removes those that were dereferenced.

Getting back to the non-private methods, we have the last one called `dispose(observer:)`. This method sents the specified *Observer* to nil and makes it eligible for dereferensing in the next `send(notification:)` method call.


## Swityfication
This section is optional and you may skip it. Still here? - Great! 😉

In order to make the code more *swifty* we can implement several custom subscripts and operators which make the code slightly less verbous and "more visual" (in terms of using symbols rather than explicit method names).

Earlier we saw the following line of code in `remove(observer:)` method - `self[observer]`. It's a custom subscript that is used as an accessor to a particular *Observer*.

```swift
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
		guard let index = observers.index(where:{ $0.value === observer }) else {
			return nil
		}
		return index
	}
}
```
The first subscript returns an *Observer* for the specified index or nil, if the index is invalid. This subscript makes access to observers safer and hides the actual collection type that is used to store them.

The next subscript is used to search an *Observer* in the collection of observers, by providing the reference that we are interested in. As a result the subscript will return the index of the *Observer*.

The next step is to implement custom operators

## Usage

## Conclusio