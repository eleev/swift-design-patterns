# Observer Design Pattern
`Observer` is a behavioral design pattern that is aimed to simplify communication between objects by providing means for notification handling and incapsulating logic around communication, without the need know how exactly those notifications are processed and sent to the observers.The pattern decreases coupling between objects that listen for events and an object that raises them. `Observer` pattern decouples their relationship by separating objects into two layers called `Observer` and `Subject`. 

`Observer` is represented as a protocol that defines common interface for communication. `Subject` is an object that emits events and sends them to multiple *Observers*. That forms *one-to-many* relationship, where one *Subject* sends notifications to many *Observers*. As a *notification* we may use a common protocol and in some implementations concrete classes, structs or enum types. 

The pattern has some similarities with `Multicast Delegate` and `Event Listener`, however *Observer* is a different pattern and has its own applications.

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
`Notification` protocol defines the base interface for all kinds of notifications that are sent by the *Subject* to all the *observers*. The protocol contains a single property that represents any data. We will implement the concrete notification type for type-safety a bit later and take a look at a real usege example.

## Subject
The next step is to implement the `Subject` layer. It's going to be a class with a number of methods such as:

- Add an Observer - adds a new *Observer* to the list of observers for a particular `Subject`
- Remove an Observer - immediately removes an *Observer* from a `Subject`
- Send Notification - sends a *Notification* to all the *Observers*
- Dispose an Observer - waits until the next notification will be sent to remove an *Observer* 

Our implementation is minimal and pretty intuitive. You may extend the functionality, for example, to add support for `willSend(notification:)` and `didSend(notification:)` for more complicated notification handling.

### Weak Observer

In order to be able to manage a collection of observers, we need to store them. By directly holding the references of objects we may create `retain-cycle`, which leads to memory leaks. That is why we create a wrapper type called `WeakObserver` that weakly holds a reference to an observer:

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
The class declared as `private final` since it's defined inside the `Subject` class. We don't need to expose the way we manage the internals of our `Subject` by marking `WeakObserver` as `internal or public`, since the whole point of making an intermediate abstraction layer will be lost in this case. In a minute you will see how this class is used to manage a collection of observers.

## Subject Class

The implementation of `Subject` class has many similarities with `Multicast Delegate` class: the we store a collection of observers is hidden, as well a we hide all the notification sending code and recycling of observers. We will break down the implementation step by step, starting from the class declaration and its properties:

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
    
    /// Sends notification to all the Observers. The method is executed synchronously.
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
we won't be able to attempt to delete an `Observer` that has already been removed. The same rule is applied to an addition of a new *observer*.

The next method is `remove(observer:)` - which gets an observer instance, finds and immediately removes it from the collection. You may be wondering, what this line in remove method means: `self[observer]`. It's a custom `subscript` and we take a closer took in [Swiftification](swiftification) section.

Then we implemented `send(notification:)` method that synchronously calls `notify(with:)` method for each observer in the collection of observers. However before calling sending the notifications, it calls `recycle` method, that has the following implementation:

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

Getting back to the non-private methods, we have the last one called `dispose(observer:)`. This method sets the specified *Observer* to nil and makes it eligible for dereferensing in the next `send(notification:)` method call.


## Swiftification
This section is optional and you may skip it. Do you still reading? - Great! 😉

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
The first subscript returns an *Observer* for the specified index or nil, if the index is invalid. This subscript makes access to observers safer and hides the actual collection type that is used to store them. That is a big advantage because we will be able to change the *array* (that is used to store *observers*) to any other data structure that we will be needed, without the need to refactor all the code that uses our *Subject* class.

The next subscript is used to search an *Observer* in the collection of observers, by providing the reference that we are interested in. As a result the subscript will return the index of an *Observer*.

The next step is to implement custom operators.

```swift
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
```
Basically we have defined the following operators for the `APIs` of `Subject` class:

- `+=` adds an *Observer* to the *Subject*
- `+=` alternative method - adds an array of *Observer* to the *Subject*
- `--=` removes an *Observer* from the *Subject*
- `--=`alternative operator - removes an array of *Observer* from the *Subject*
- `-=` disposes an `Observer` from the `Subject`
- `-=` alternative operator - disposes an array of `Observer` from the `Subject`
- `~>` sends the specified `Notification`
- `~>` alternative operator - sends the specified array of `Notification`

There are quite a few operators, which may seem a bit heavy to understand immediately. However, there is nothing complicated, these are just syntactic sugar blocks that make the code easier to write and read. We will see that in the next section.

## Usage

It's time to use the pattern and observer for events! First, let's create several classes that will conform to `Observer` protocol:

```swift
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
```
These are just dummy classes for the demonstrtion purposes. They don't have any code rather than the conformance to the *Observer* protocol and print statements.

The next step is we create a custom `EmailNotification` class that conforms to the *Notification* protocol:

```swift
final class EmailNotification: Notification {
    
    // MARK: - Conformance to Notification protocol
    
    var data: Any?
    
    // MARK: - Initializers
    
    init(message: String) {
        data = message
    }
}
```
We will use this concrete notification to send emails to our obserers that we have declared earlier.

```swift
let observerOne = ObserverOne()
var observerTwo: ObserverTwo? = ObserverTwo()
let observerThree = ObserverThree()

let subject = Subject()
subject += [observerOne, observerTwo!, observerThree]
```

Here we have created the observers and the *Subject* instance. Then we added the observers to the subject, so we will be able to send then emails:

```swift
subject ~> EmailNotification(message: "Hello Observers, this messag was sent from the Subject!")
```
Then we sent email notification to all the *observers* and got the following printed in the console:

```swift
Observer One:  data: Optional("Hello Observers, this messag was sent from the Subject!")
Observer Two:  data: Optional("Hello Observers, this messag was sent from the Subject!")
Observer Three:  data: Optional("Hello Observers, this messag was sent from the Subject!")
```
Next we may remove one of the *observers* and again send the notification:

```swift
subject --= observerThree
subject ~> [notificationOne, notificationTwo, notificationThree]
```

We removed the third observer and sent several notification to the remaining observers. 

In this example we used `Subject` as a standalone class, which may not always be the best scenario. Sometimes a `Subject` or a several of them should be included as a part of another class that emitts some notifications. Then the *observers* need to be added through the pattern known as `Dependency Injection`. That gives many advantagies such as: 

- We have isolated code that handles all the things related to observer's management and notification handling. Which allows us to reuse the same `Subject` in multiple places, extend and refactor it without breaking any code.
- The code-base stays minimal in places that need to post notifications, since it's handled by a separate class.


## Conclusion