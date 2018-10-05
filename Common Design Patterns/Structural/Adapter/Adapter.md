# Adapter Design Pattern
`Adapter` is a structural design pattern that is aimed to resolve an issue with incompatible interfaces (in our case it  is protocols). The resolution consists of creating an `Adapter` type that wraps the incompatible `Adaptee` type, so the `Target` type will be able to use it. As it was just mentioned, the pattern has three  building blocks: 

- `Adaptee` - is **what** needs to be adopted
- `Adapter`- is a type that specifies **how** it needs to be adopted
- `Target` - is a type that specifies **where** `Adaptee` needs to be used

The pattern can be used to solve several problems. For instance when there is a client code that requires a specific type of interface from its types. Also the pattern can be used in cases when two or more types need to work together, but they have incompatible interfaces (protocols). 

The pattern can be implemented by using *inheritance* or *composition*. I personally prefer *composition* over *inheritance*, when there is a choice. That is why we are going to focus on an example where we will use an `Adapter` type as a composite type of our `Target` type.


## USB-C Charger for iPhone
In our example, we are going to create a `Lightning - USB-C` adapter for `iPhones`. I know, we ain't there yet, but hopefully will be someday 😄. 

The first thing that we need to do is to create a protocol for `USB-C Socket` type and the `USB-C Charger` type:

```swift
protocol USBCSocketType {
    func connect()
    func charge()
}

class USBCAdapter: USBCSocketType {
    
    var lightningSocket: LightningSocketType {
        didSet {
            disableLogging()
        }
    }
    
    init(for lightningSocket: LightningSocketType) {
        self.lightningSocket = lightningSocket
        disableLogging()
    }
    
    private func disableLogging() {
        (self.lightningSocket as? iPhone)?.isLoggingEnabled = false
    }
    
    // MARK: - Conformance to USBCSocketType protocol
    
    func connect() {
        print("iPhone is being connected using USB-C Socket Adapter")
        lightningSocket.attach()
    }
    
    func charge() {
        print("iPhone is being charged using USB-C Socket Adapter")
        lightningSocket.charge()
    }
}
```

The `USBCSocketType` protocol declares two methods called `connect` and `charge`. We *assume* that our interpretation of `USB-C` standard works in that way: when a device is set then we immediately call `connect` method and then we will be able to manually call `charge` method. 

The next step is to create a protocol for `LightningSocket` and `iPhone` class, so we have the base type:

```swift
// Let's assume by some reasons our Lightning Socket protocol has no ability to be programmatically connected, just attached and it immediately stars charging
protocol LightningSocketType {
    func attach()
    func charge()
}

/// Adaptee that needs to be adapted to work with USB-C port
class iPhone: LightningSocketType {
    
    var isLoggingEnabled: Bool = true
    
    /// ...
    /// Among other possbilities, our iPhone struct has an ability to charge our phone
    ///...
    
    // MARK: - Conformance to LightningSocketType protocol
    
    func attach() {
        if isLoggingEnabled {
            print("iPhone is being attached using Lightning Socket")
        }
    }
    
    func charge() {
        if isLoggingEnabled {
            print("iPhone is being charged using Lightning Socket")
        }
    }
}
```

We assume that `LightningSocketType` protocol cannot be connected, just `attached` which is a different operation from the technical perspective. Again, the actual details aren't important, what is important is that we have two protocols with incompatible set of methods. 

Right now cannot charge our `iPhone` with `USB-C` charger, since it doesn't work with `Lightning` sockets. We could have create a separate charger for `Lightning` socket and be happy about that, but our requirements will not always be that flexible. So we need to create a `Lightning to USB-C` adapter to make the protocols compatible. 

```swift
class USBCAdapter: USBCSocketType {
    
    // MARK: - Properties
    
    var lightningSocket: LightningSocketType {
        didSet {
            disableLogging()
        }
    }
    
    // MARK: - Initializers
    
    init(for lightningSocket: LightningSocketType) {
        self.lightningSocket = lightningSocket
        disableLogging()
    }
    
    // MARK: - Methods
    
    private func disableLogging() {
        (self.lightningSocket as? iPhone)?.isLoggingEnabled = false
    }
    
    // MARK: - Conformance to USBCSocketType protocol
    
    func connect() {
        print("iPhone is being connected using USB-C Socket Adapter")
        lightningSocket.attach()
    }
    
    func charge() {
        print("iPhone is being charged using USB-C Socket Adapter")
        lightningSocket.charge()
    }
}
```

The implementation of `USBCAdapter` class consists of the following parts: 

- We have added conformance to the target socket type named `USBSocketType` protocol
- Then we implemented the conformance
- Added a `lightningSocket` property that can be set later on, during the runtime of an application
- Finally, crated a designated initializer that accepts the initial state of the `lightningSocket` property

As a result we now are able to make the incompitable types to work together using the `Adapter`:

```swift
let phone = iPhone()    // 1
let usbcAdapter = USBCAdapter(for: phone)   // 2
let charger = USBCCharger(using: usbcAdapter)   // 3
charger.charge()    // 4
```

The first thing that we do (1) is to create an instance of an `iPhone` type. Then (2) we create an `Adapter` called `USBCAdapter`, which may accept a type that conforms to `LightningSocketType` protocol. Finally, we can use our charger adapter by passing it to the `USBCCharger` type, since it conforms to `USBCSocketType` and knows how to convert the method calls from one socket to another one. Then we call `charge` method and our `iPhone` is charging via *USB-C* charger 🍾.


## Conclusion
`Adapter` is a simple, yet powerful structural pattern that can be implemented by various ways. The exact implementation details depend on many factors that is why need to decide whether or not *inheritance*-based approach suits best, or may be *composition*-based approach is the one that needs to be used. It's all up to you, there are no strict rules. Just remember one thing - make your *adapters* thin and be responsible for just a single type. Don't try to make a `super adapter` that does all kinds of crazy things with various types at the same type. Use composite types and built up on top of that. 
