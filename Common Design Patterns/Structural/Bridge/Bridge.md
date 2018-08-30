# Bridge Design Pattern
`Bridge` is a structural design pattern that is aimed to decouple the abstraction from the implementation. That is done to allow both vary independently. `Bridge` pattern adds an additional layer of abstraction that saves the code-base from unneeded refactoring and `class hierarchy explosion`. 

Class hierarchy explosion simply means that over time, when requirements change and more classes are added to hierarchies, it becomes  hard to control complexity and make the code manageable. 

## Abstraction & Implementation

In order to more practically dive in, let's create two hierarchies: one that specifies mobile device and the other one that is capable of charging them:

```swift
public protocol MobilePhone {
    
    // MARK: - Properties
    
    var name: String { get set }
    var model: String { get set }
    
    // MARK: - Methods
    
    func turnOn()
    func turnOff()
}

public protocol Chargeable: class {

	// MARK: - Properties
	
    var device: MobilePhone { get set }
    
    // MARK: - Methods
    
    func charge()
}
```
Protocol `MobilePhone` is pretty straightforward: it defines a set of requirements for a regular phone that has `name`, `model` and functions such as `turnOn` and `turnOff`.

Protocol `Chargeable` holds a single property for `MobilePhone` and a method called `charge`. That gives it an ability to work with any derivative type for mobile phone and charge them.

The next step is to implement a concrete type for each of the protocols. For `MobileDevice` we implement two child classes, in order to demonstrate the work of the pattern:

```swift
public class Charger: Chargeable {
    
    // MARK: - Properties
    
    public var device: MobilePhone
    
    // MARK: - Initialisers
    
    public init(device: MobilePhone) {
        self.device = device
    }
    
    // MARK: - Methods
    
    public func charge() {
        print("Charging device named: ", device)
    }
}

public class iPhone: MobilePhone, Callable {
    
    // MARK: - Conformance to MobilePhone protocol
    
    // MARK: - Properties
    
    public var name: String = "iPhone"
    public var model: String = "XXVIXI"
    
    // MARK: - Methods
    
    public func turnOn() {
        print("Turned On: ", name)
    }
    
    public func turnOff() {
        print("Turned Off: ", name)
    }
    
    // MARK: - Conformance to Callable protocol
    
    public private(set) var callConnected: PhoneNumber?
    
    public func call(number: PhoneNumber) {
        print("Calling to: ", number)
    }
    
    public func hangOut() {
        print("Hang out call: ", callConnected as Any)
    }
    
}

public class ApplePhone: MobilePhone, Callable {
    
    // MARK: - Conformance to MobilePhone protocol
    
    // MARK: - Properties
    
    public var name: String = "ApplePhone"
    public var model: String = "13s-"
    
    // MARK: - Methods
    
    public func turnOn() {
        print("Turned On: ", name)
    }
    
    public func turnOff() {
        print("Turned Off: ", name)
    }
    
    // MARK: - Conformance to Callable protocol
    
    public private(set) var callConnected: PhoneNumber?
    
    public func call(number: PhoneNumber) {
        print("Calling to: ", number)
    }
    
    public func hangOut() {
        print("Hang out call: ", callConnected as Any)
    }
}
```
We have created a concrete charger that conforms to the `Chargeable` protocol and two mobile devices called `iPhone` and `ApplePhone`. We added conformance for `Callable` protocol which adds calling functionality for the conforming types:

```swift
public protocol Callable {
    func call(number: PhoneNumber)
    func hangOut()
}

public enum PhoneNumber: Int {
    case mom = 348957
    case dad = 133412
    case brother = 82398
    case friend = 38740
    case cat = 666 // Evil cat that dropps everything 👹😄
}
```

We introduced this protocol in order to simulate charging/discharging for mobile devices. 

```swift
let iphone = iPhone()
iphone.call(number: .cat)

// After the conversation with our cat, the phone is dead and needs to be recharged

let applePhone = ApplePhone()
applePhone.call(number: .friend)
// The same story with our Apple Phone here

// Create a single charger and attach iPhone to it
let charger = Charger(device: iphone)
// Charge the device
charger.charge()

// Deattach the iPhone and connect ApplePhone
charger.device = applePhone
// Charge the ApplePhone
charger.charge()
```
The `Bridge` pattern may not be seen immediately in this example, since we simply have two hierarchies of classes. However that is exactly what the pattern represents: it decouples abstraction from the implementation. In this case, abstraction is represented by `MobilePhone` protocol. 

`Chargeable` protocol represents the implementation, since it knows about the abstraction part and performs some actions for it. The concrete implementation for `Chargeable` protocol called `Charger` is often called `implementor` because it actually provides means for interfering with the abstraction part.

## Bridging Type
Sometimes an additional, small layer of abstraction is implemented for the `Bridge` pattern. It can be implemented using reference or value type. This bridging type simplifies the intercommunication between the abstraction and the implementation further by decomposing the interference code into a separate API method call:

```swift
class ChargingDockBridge {
    
    func connect(charger: Chargeable, with device: MobilePhone) {
        charger.device = device
        charger.charge()
    }
}
```

We have created `ChargingDockBridge` type that decouples the intercommunication between the two hierarchies using a separate method. 

```swift
let dockStation = ChargingDockBridge()
dockStation.connect(charger: charger, with: iphone)

// Then we simply can connect the same charger but to the different mobile device:
dockStation.connect(charger: charger, with: applePhone)
```

Use this bridging type in cases when you have fairly complex mechanism for intercommunication between the abstraction and the implementation hierarchies. For instance our `ChargingDockBridge` could be further improved in order to provide notifications for situations when a device is fully charged. 


## Conclusion 
The `Bridge` pattern is a great way to structure your code, especially when you have hierarchies of classes that communicate/depend on each other. It saves from `class hierarchy explosion` and keeps your code decoupled and more easily maintainable. You may use an additional bridging type in order to further decompose the interference between the hierarchies of classes. 