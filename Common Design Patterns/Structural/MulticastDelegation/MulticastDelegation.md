# Multicast Delegation Design Pattern

`Multicast Delegate` is a multipurpose design pattern (despite it's categorized  here as structural) that further extends the capabilities of the `Delegate` pattern. `Delegate` pattern establishes one-to-one relationship between the delegate and the delegated types. `Multicast Delegate` pattern allows for multiple delegates to be attached to a delegated type by maintaining a weakly-referenced collection of objects. 

## Weak Wrapper

The first thing that we need to do to implement the pattern, is to crete a `weak` wrapper around an object, so it can be stored in a collection of delegates:

```swift
final class Weak {

	// MARK: - Properties	

	weak var value: AnyObject?
	
	// MARK: - Initializers
	
	init(_ value: AnyObject) {
		self.value = value
	}
}
```
The `Weak` class is pretty simple: it wraps `AnyObject` type as a weak property and provides an initializer for that. 

## Multicast Delegate

The next step is to create the base skeleton for the `MulticastDelegate` class:

```swift
class MulticastDelegate<T> {

	 // MARK: - Properties
    
    private var delegates = [Weak]()
    
    // MARK: - Methods
    
    public func add(delegate: T) {
        delegates.append(Weak(delegate as AnyObject))
    }
    
    public func remove(delegate: T) {
        guard let index = self[delegate] else {
            return
        }
        delegates.remove(at: index)
    }
    
    public func update(_ completion: @escaping(T) -> ()) {
        // Recycle the values that are nil so the completion closure is called for non nil values
        recycle()
        
        delegates.forEach { delegate in
            // Additional anti-nil check
            if let udelegate = delegate.value as? T {
                completion(udelegate)
            }
        }
    }
    
    // MARK: - Private
    
    private func recycle() {
        for (index, element) in delegates.enumerated().reversed() where element.value == nil {
            delegates.remove(at: index)
        }
    }

}
```

First of all we create a private collection of `Weak` objects called `delegates`. Next we implement public methods that form the `API`: 

- `add(delegate: T)` - adds a new delegate to the collection of delegates
- `remove(delegate: T)` - if exists, removes a delegate from the collection
- `update(: @escaping(T) -> ())` - provides means to delegate responsibilities outside of the delegated type (the example will be shown later)

Also we have a private method called `recycle` - it's used to clean up the delegate references that were dereferenced and no longer valid. 


## Use Case 

In order to demonstrate how the pattern can be used, let's create a delegate protocol (hopefully already familiar, if not please take a look at the `Delegate` pattern). 

```swift
protocol ModelDelegate: class {
    func didUpdate(name: String)
    func didUpdate(city: String)
    func didSave()
}
```
The protocol defines a set of methods that allow a model to be updated and saved. 

```swift
class ProfileModel {

    // MARK: - Properties
    
    var delegates = MulticastDelegate<ModelDelegate>()
    
    var name: String = UUID.init().uuidString {
        didSet {
            delegates.update { [unowned self] modelDelegate in
                modelDelegate.didUpdate(name: self.name)
            }
        }
    }
    
    var city: String = UUID.init().uuidString {
        didSet {
            delegates.update { [unowned self] modelDelegate in
                modelDelegate.didUpdate(city: self.city)
            }
        }
    }
    
    // MARK: - Methods
    
    func completedUpdate() {
        delegates.update { modelDelegate in
            modelDelegate.didSave()
        }
    }
}

```
`ProfileModel` is a model class that represents a user's profile data and notifies the corresponding pieces of application about the changes. We could save the model and read the data in places where we need it, however in addition to data updates we have a special function that notifies about saving the data.

```swift
class ContainerViewController: UIViewController, ModelDelegate {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Conformance to ModelDelegate protocol
    
    func didUpdate(name: String) {
        print("ContainerViewControllers: ", #function, " value: ", name)
    }
    
    func didUpdate(city: String) {
        print("ContainerViewControllers: ", #function, " value: ", city)
    }
    
    func didSave() {
        print("ContainerViewControllers: ", #function)

    }
}

class ProfileViewController: UIViewController, ModelDelegate {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Conformance to ModelDelegate protocol
    
    func didUpdate(name: String) {
        print("ProfileViewController: ", #function, " value: ", name)
    }
    
    func didUpdate(city: String) {
        print("ProfileViewController: ", #function, " value: ", city)
    }
    
    func didSave() {
        print("ProfileViewController: ", #function)
    }
}
```

These two view controllers conform to the `ModelDelegate` protocol and are notified about model `ProfileModel` changes at the same time. 

```swift
// Create the view controllers that will be delegates
let containerViewController = ContainerViewController()
let profileViewController = ProfileViewController()

let profileModel = ProfileModel()

// Attach the delegates
profileModel.delegates.add(delegate: containerViewController)
profileModel.delegates.add(delegate: profileViewController)

// Change the model
profileModel.name = "John"

// After changing `name` property we got the following in console:
// ContainerViewControllers:  didUpdate(name:)  value:  John
// ProfileViewController:  didUpdate(name:)  value:  John

// Assume that we needed to remove one of the delegates:
profileModel.delegates.remove(delegate: profileViewController)

// And again update the model:
profileModel.city = "New York"
// This time the console outputs is the following:
// ContainerViewControllers:  didUpdate(city:)  value:  New York

// We again attach ProfileViewController
profileModel.delegates.add(delegate: profileViewController)

// Custom closure that is called outside of the model layer, for cases when something custom is required without the need to touch the original code-base. For instance we may implement this function in our view-model layer when using MVVM architecture
profileModel.delegates.update { modelDelegate in
    modelDelegate.didSave()
}
```

The presented usage example shown that basically we have the same `Delegate` pattern but under the hood it establishes `one-to-many` relationship with its delegates and provides some additional capabilities such as custom closure invocation outside of the delegated type.

## Adding Steroids
This section is about syntactic and `API` improvements, you may skip it if you feel yourself a bit overwhelmed and return when you are ready 😉. 

### Subscrips

Still here? Wonderful! You may be wondering: "What the 💩 is `self[delegate]` line?" located in `ModelDelegate` class in `add(delegate:)` method. The answer is simple - we added some "syntactic steroids" to our pattern, so it can be more easily used, without the need for boilerplate code. 

```swift
class MulticastDelegate<T> {

	  // MARK: - Subscripts
    
    /// Convenience subscript for accessing delegate by index, returns nil if there is no object found
    public subscript(index: Int) -> T? {
        get {
            guard index > -1, index < delegates.count else {
                return nil
            }
            return delegates[index].value as? T
        }
    }
    
    /// Searches for the delegate and returns its index
    public subscript(delegate: T) -> Int? {
        get {
            guard let index = delegates.index(where: { $0.value  === delegate as AnyObject }) else {
                return nil
            }
            return index
        }
    }
    
    // MARK: - Properties
	...
}
```
These two subscripts add syntactic convenience to our pattern: we can work with our `MulticastDelegate` as it is a collection of delegates, hiding the underlying collection of `Weak` references and providing a more safer mechanism for accessing delegates. 

We need that bacase often it's a requirement: imagine a case where you need to attach and remove delegates depending on external factors. In such situation we need a mechanism that allows to do so very easily. 

```swift
profileModel.delegates[0] // returns ContainerViewController
profileModel.delegates[1] // returns ProfileViewController
profileModel.delegates[2] // returns nil

// or 
profileModel.delegates[containerViewController] // returns 0
profileModel.delegates[profileViewController] // returns 1
profileModel.delegates[segmentViewController] // returns nil
```
It seems like `delegate` is a collection property, however it is not - it's a reference type for `MulticastDelegate` class. All it does is it hides the implementation and handles situations such as `index outside of the range` and the other runtime issues yet still providing the expected functionality. 

Also, the users of our `MulticastDelegate` class will never have to deal with `Weak` class - that is why in source code the `Weak` class is placed as nasted private class of `MulticastDelegate` class.

### Custom Operators

In the pattern usage code snippet in the previous section, we have seen that we need to use the following constructions:

```swift
profileModel.delegates.remove(delegate: profileViewController)
``` 

That looks pretty normal in Swift, but we can further improve it by introducing custom operators:

```swift
extension MulticastDelegate {

    static func +=(lhs: MulticastDelegate, rhs: T) {
        lhs.add(delegate: rhs)
    }
    
    static func -=(lhs: MulticastDelegate, rhs: T) {
        lhs.remove(delegate: rhs)
    }
    
    static func ~>(lhs: MulticastDelegate, rhs: @escaping (T) -> ()) {
        lhs.update(rhs)
    }
}
```

The extension adds support for custom operators for `add`, `remove` and `update` `APIs`. The implementation is straightforward yet greatly improves the usage of the same functions, especially when you have a lot of delegate management calls:

```swift
profileModel.delegates -= profileViewController

profileModel.city = "New York"

profileModel.delegates += profileViewController

profileModel.delegates ~> { modelDelegate in
    modelDelegate.didSave()
}
```
This is the same code but using custom operators. IMHO looks much cleaner. 

### Sequence Protocol

The final touch is we add conformance to `Sequence` protocol and make it really easy to work with the `MulticastDelegate` class as it is a collection type:

```swift
extension MulticastDelegate: Sequence {
    
    public func makeIterator() -> AnyIterator<T>{
        var iterator = delegates.makeIterator()

        return AnyIterator {
            while let next = iterator.next() {
                if let value = next.value as? T {
                    return value
                }
            }
            return nil
        }
    }
}
```

That will allow us to iterate and process the collection of delegates for our custom needs:

```swift
// Since we conformed to the Sequence protocol we can easily iterate through the delegates as it is a collection
for delegate in profileModel.delegates {
    print("Delegate: " , delegate)
}

// Prints:
// Delegate:  <__lldb_expr_7.ContainerViewController: 0x7fe23f608500>
// Delegate:  <__lldb_expr_7.ProfileViewController: 0x7fe23f504300>
```
The output can be further improved by adding conformance to `CustomStringConvertible` protocol.

The presented "syntactic steroids" not only make the code cleaner and more easily maintained, they also make it safer and extendable. 

## Conclusion
The multicast delegate pattern is multipurpose design pattern that decouples responsibilities and manages complex one-to-many relationships between the delegated type and delegate classes. It's a derivative from classic `Delegate` pattern that also has multiple purposes. By adding custom operators, support for `Sequence` extension and custom subscripts we made the pattern pretty Swifty and easy to integrate to existing applications.

