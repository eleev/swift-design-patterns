# Command Design Pattern
`Command` is a behavioral design pattern that creates a type that can change its behavior at runtime. It's achieved through a protocol that defines an interface which is implemented by conforming types. Those types incapsulate all the information needed to perform an action or logic. `Command` types make very easy to construct generic components that delegate or execute method calls dynamically, depending on concrete implementations that are assigned to *receiver* via *aggrigation*. 

Command pattern is implemented using several building blocks: `command` protocol, `concrete command types`, `receiver` and `caller`. Let's break each component down one by one:

- `Command` protocol is a protocol that defines actions to be executed
- `Concrete command types` are types that conform to the Command protocol
- `Receiver` is a type that is connected with Command protocol via *aggregation*
- `Caller` is a type that acts as a source that initiates actions and possibly needs to get some resutls back

If you are confused a bit by all the termonology, don't worry, we will implement each building block programmatically. We could skip all of that and dive straight into the code, but it's important to know the exact terms since it is a common practice and it will help to establish common vocabulary when working in a team. [McConnel]() has a dedicated chapter about the importance of professional terminology and ability to give real-world analogies. 

## Building Blocks
`Command` protocol defines a common interface that is used by the `concrete command` types in order to provide concrete implementation that can then be assigned with the `receiver` and then called by `caller` type.

```swift
protocol DoorCommandProtocol {
    func close()
    func open()
}
```
`DoorCommandProtocol` is a protocol where the main interface for door management is defined. The protocol represents the `Command Protocol` building block. Then we need to define concrete door types that conform to the protocol:

```swift
struct MainDoor: DoorCommandProtocol {
    
    func close() {
        print("MainDoor -> " + #function)
    }
    
    func open() {
        print("MainDoor -> " + #function)
    }
}


struct HallDoor: DoorCommandProtocol {
    
    func close() {
        print("HallDoor -> " + #function)
    }
    
    func open() {
        print("HallDoor -> " + #function)
    }
}

struct GarageDoor: DoorCommandProtocol {
    
    func close() {
        print("GarageDoor -> " + #function)
    }
    
    func open() {
        print("GarageDoor -> " + #function)
    }
}
```
We have created three protocols: `MainDoor`, `HallDoor` and `GarageDoor` which conform to the `DoorCommandProtolol`. These concrete conformances represent `concrete protocol types` building block. The types will be used to change the behavior of the `receiver` duiring the runtime. 

```swift
struct SequrityRemoteControl {
    
    // MARK: - Properties
    
    var door: DoorCommandProtocol
    
    // MARK: - Initializers
    
    init(_ door: DoorCommandProtocol) {
        self.door = door
    }
    
    // MARK: - Methods
    
    func openDoor() {
        door.open()
    }
    
    func closeDoor() {
        door.close()
    }
}
```

`SequirityRemoteControl` struct represents a remote control that can perform `openDoor` and `closeDoor` actions for various doors in a house. This type represents a `receiver` building block, since it basically receives messages from the `caller` and delegates the execution ot the `concrete command types`. 

Instead of storing each of the door in the struct (in a case when we may don't know the exact list of doors, or may be the remote control can be reconfigured for different sequirity systems) we use `dependency injection` in a form of *aggrigation* via `initializer`. That gives us an ability to change the concrete action during the runtime:

```swift
let mainDoor = MainDoor()
let hallDoor = HallDoor()
let garageDoor = GarageDoor()

var remoteControl = SequrityRemoteControl(mainDoor)
remoteControl.openDoor()
remoteControl.closeDoor()

remoteControl.door = hallDoor
remoteControl.openDoor()

remoteControl.door = garageDoor
remoteControl.openDoor()
```
We have created several doors and a remote control with the assigned door. Then we can manipulate that door using the interface such as `open` and `close` door. The code that triggers the actions and manages which door is attached to the remote control is the `caller` building block of the design pattern. 

As you can see we can easily change the *concrete command type* and change the resulting action of the *receiver* during the runtime. 

We used *aggrigation* as a form of `composition` because doors can outlive the remote control, which means that the remote control doesn't own the door that it is communicating to. This is an important distinction with an another form of `composition` called *association*. 

## Conclusion
