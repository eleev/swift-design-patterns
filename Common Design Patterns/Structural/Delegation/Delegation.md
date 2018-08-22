# Delegation Design Pattern
Delegation is a structural design pattern that is aimed to decompose the responsibilities into smaller, discrete objects called delegates. The pattern is pretty simple and can be constructed by just using a single protocol called delegate protocol.

```swift
public protocol DelegateProtocol: class {
    
    // MARK: - Methods
    
    func methodOne()
    func methodTwo()
}
```
Then we crete a concrete type that conforms to the delegate protocol:

```swift
public class Delegate: DelegateProtocol {
    
    // MARK: - Conformance to DelegateProtocol
    
    public func methodOne() {
        print(#function + " delegated method call for methodOne")
    }
    
    public func methodTwo() {
        print(#function + " delegated method call for methodTwo")
    }
    
}
```

And the type that calls delegate methods:

```swift
public class Foo {

    // MARK: - Delegate property
    
    weak var delegate: DelegateProtocol?
    
    // MARK: - Initializers
    
    public init(delegate: DelegateProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    
    public func someFunc() {
        guard let delegate = delegate else {
            debugPrint(#function + " delegate protocol has not been set, the method will be aborted")
            return
        }
        delegate.methodOne()
    }
    
    public func someOtherFunc() {
        guard let delegate = delegate else {
            debugPrint(#function + " delegate protocol has not been set, the method will be aborted")
            return
        }
        delegate.methodTwo()
    }
}

```

The property for `DelegateProtocol` needs to be marked as `weak` or `unowned` property since we don't want to end up having `retain cycle`. 

```swift
let delegate = Delegate()

let foo = Foo(delegate: delegate)
foo.getColor()
foo.someFunc()
foo.someOtherFunc()
```
By injecting the delegate type into the `Foo` class, we connected the concrete delegate that conforms to the `DelegateProtocol` protocol with the `Foo` class, that delegates its work to the `Delegate` class. 


## Other use-cases
Delegate pattern has many applications across the `Apple Ecosystem` including `macOS`, `iOS`, `tvOS` and `watchOS`. For instance, frequently used `UITableViewDelegate` and `UICollectionViewDelegate` protocols are used to decompose and delegate functionality into separate types. You can find a lot more types in `SDKs` that delegate their some operations and even responsibilities using `Delegate` pattern. 

## Communication 
`Delegate` pattern can be used to pass values between different parts of your application. For instance a `delegate` protocol can be used to pass color information between two `view controllers`:

```swift

public protocol DelegateProtocol: class {
    
    // MARK: - Methods
    
    func methodOne()
    func methodTwo()
    func set(color: UIColor)
}
``` 
We have added a new method that takes a single parameter for `UIColor` type. This method acts as a data transmitter, since it will be used to pass parameters to the delegate type.

```swift
public class Delegate: DelegateProtocol {
   
    ... 
    
    public func set(color: UIColor) {
        print(#function + " delegated method call for set(color:)")
    }
    
}
```

We simply updated the conformance to the `DelegateProtocol`. Now `Delegate` class is capable of received data from the `caller` type. 

```swift
public class Foo: DelegateProtocol {

	...

   public func getColor() {
        // This method gets UIColor instance from a user, remove-server, color picker or anywhere else and passes it to the delegate type that need that color in order to perform its tasks
        guard let delegate = delegate else {
            debugPrint(#function + " delegate protocol has not been set, the method will be aborted")
            return
        }
        delegate.set(color: .orange)
    }
}
```

We wrapped data passing into `getColor` method. This method may represent a lot of real-world use-cases such as: 

- Input form a user
- Remove sever data transmission
- Color picker that was initiated by a user
- Or anything else

Conceptually we got the color data from somewhere and passed it to the destination point, which is the `delegate` type. 

Using this pattern we may also get a feedback data from the `delegate` type. You also may see such an example in `iOS`, `macOS`, `tvOS` and `watchOS` `SDKs`. For instance `UITableViewDelegate` has a method called `tableView(_:cellForRowAt:) -> UITableViewCell` that accepts two parameters: `UITableView` and `IndexPath` and returns `UITableViewCell` instance. The method is used to create a `cell` based on the `table` and `index path` data and return it. The method is a great example of delegation with the feedback return type. 

# Conclusion 
Delegation is a simple and pretty powerful design pattern that allows to greatly reduce code complexity by decomposing complex types into smaller, more specialized classes. `Delegate` protocol defines a contract between the delegate and the caller types, that allows to communicate by calling methods, passing data and getting feedback types as results of method calls. 