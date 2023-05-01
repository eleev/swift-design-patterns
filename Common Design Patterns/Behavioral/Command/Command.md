# Command Design Pattern
`Command` is a behavioral design pattern that incapsulates an action and is used to define concrete command actions. Those concerete commands are used for delayed execution or adding dynamic behavior to the *invoker*. `Command` types make very easy to construct generic components that delegate or execute method calls dynamically, depending on concrete implementations that are assigned to *invoker* via *aggregation*. 

Command pattern is implemented using several building blocks: `command` protocol, `concrete command types`, `invoker` and `caller`. Let's break each component down one by one:

- `Command` protocol is a protocol that defines actions to be executed
- `Concrete command types` are types that conform to the Command protocol
- `Invoker` is a type that is connected with Command protocol via *aggregation* - it receives commands to be executed by the *caller*
- `Caller` is a type that acts as a source that initiates actions and possibly needs to get some resutls back

If you are confused a bit by all the termonology, don't worry, we will implement each building block programmatically. We could skip all of that and dive straight into the code, but it's important to know the exact terms since it is a common practice and it will help to establish common vocabulary when working in a team. 

## Building Blocks
`Command` protocol defines a common interface that is used by the `concrete command` types in order to provide concrete implementation that can then be assigned with the `invoker` and then called by `caller` type.

```swift
protocol DoorCloseCommand {
    func close()
}
protocol DoorOpenCommand {
    func open()
}
```
`DoorCloseCommand` and `DoorOpenCommand` are protocols that define interfaces for actions to be executed by the concrete commands. The protocols represent the `Command Protocol` building block and will be used to open and close various doors in a house. Each command (open and close) may have specific implementation for each door type. *Command* pattern helps to decompose those differences into concrete action objects and use the one that is appropriate. 

```swift
struct MainDoor: DoorCloseCommand, DoorOpenCommand {

    func close() {
        print("MainDoor -> " + #function)
    }

    func open() {
        print("MainDoor -> " + #function)
    }
}


struct HallDoor: DoorCloseCommand, DoorOpenCommand {

    func close() {
        print("HallDoor -> " + #function)
    }

    func open() {
        print("HallDoor -> " + #function)
    }
}

struct GarageDoor: DoorCloseCommand, DoorOpenCommand {

    func close() {
        print("GarageDoor -> " + #function)
    }

    func open() {
        print("GarageDoor -> " + #function)
    }
}
```
We have created three structs: `MainDoor`, `HallDoor` and `GarageDoor` each of which conforms to the command protocols (DoorCloseCommang and DoorOpenCommand). These concrete conformances represent `concrete protocol types` building block. The types will be used to change the behavior of the `invoker` duiring the runtime. The *invoker* represents sequirity remote control that can communicate and send actions to all kinds of doors in a house:

```swift
struct SequrityRemoteControl {

    // MARK: - Properties

    var door: DoorCloseCommand & DoorOpenCommand

    // MARK: - Initializers

    init(_ door: DoorCloseCommand & DoorOpenCommand) {
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

`SequirityRemoteControl` struct represents a remote control that can perform `openDoor` and `closeDoor` actions for various doors in a house. This type represents an `invoker` building block, since it basically receives messages from the `caller` and delegates the execution to the `concrete command types`. 

Instead of storing each of the door in the *invoker* (in a case when we may don't know the exact list of doors, or may be the remote control can be reconfigured for different sequirity systems) we use `dependency injection` in a form of *aggregation* via `initializer`. That gives us an ability to change the concrete action during the runtime:

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

We used *aggregation* as a form of `composition` because doors can outlive the remote control, which means that the remote control doesn't own the door that it is communicating to. This is an important distinction with an another form of `composition` called *association*, however it's not always the case - *aggregation* is just more suitable for this particular example.

## Conclusion 
The `Command` design pattern is highly beneficial when an object is required to perform various actions without storing all possible actions within a single object. This pattern separates actions into concrete types through protocol conformance, utilizing an *invoker* type to hold a command object responsible for executing specific actions. The concrete command objects contain actions that can be executed at a later time based on requirements.
