# Mediator Desing Pattern

`Mediator` is a behavioral design pattern that is aimed to decouple inter-object communications by providing a mediating protocol. The `Mediator` pattern makes object's communication loosely-coupled by creating an intermediate layer and removing the need to explicitly reference the target message receivers from within the sender. The pattern makes the interaction logic run-time replaceable, meaning that one `Mediator` can be replaced by another one during the run-time of an application. 

Another benefit of using the pattern is that many-to-many relationships can be easily constructed. With some minor modifications we can even extend the pattern and make it one-to-many or many-to-one interactable, depending on the requirements.

## Receivable 
Before diving into the `Mediator` protocol itself, we need to do some preparation. We need to make the  `Mediator` protocol to be loosely coupled from the objects that are going to be used with it. That is why we start off from making a unified protocol called `Receivable` that will be used in conjunction with the `Mediator` protocol:

```swift
protocol Receivable {
    var id: String { get }
    func receive(message: [String : Any])
}
```
The protocol contains only one property and a method. But they are very important and will make the rest of the architecture to be easily implemented. 

The `id` property will be used to compare the receivables and to avoid the need to compare the objects by references, in order to be able to make a search or to filter the receivables. 

The `receive` method will be used to, well, receive messages by the `Mediator`.


## Mediator Protocol
The `Mediator` protocol will be used to to perform the actual message passing and storing a collection of `Receivables` that will participate in message passing:

```swift
protocol Mediator {

    var receivers: [Receivable] { get set }
    
    /// Sends the specified message to all the registered receivers except the sender
    ///
    /// - Parameters:
    ///   - message: is a message that will be delivered to all the receivers
    ///   - sender: is a sender that conforms to Receivable protocol
    func send(message: [String : Any], sender: Receivable)
    
    /// Sends the specified message to the concrete receiver
    ///
    /// - Parameters:
    ///   - message: is a message that will be delivered to all the receivers
    ///   - receiver: is a receiver that conforms to Receivable protocol
    func send(message: [String : Any], receiver: Receivable) throws
}
```
The protocol defines a property for `Receivable`s and **two** methods: to make different types of message passing approaches. The first one, `send(message: , sender:)` which sends a message to all the `Receivable`s except the one that actually sent the message. And `send(message: , receiver: ) throws`, which sends a message to a concrete receiver. 

There is one thing that we do to make the pattern to really shine: we can implement default implementations for our methods that will cover the most common use-cases and eliminate the need to create boilerplate code over and over again.

```swift
extension Mediator {
    func send(message: [String : Any], sender: Receivable) {
        for receiver in receivers where receiver.id != sender.id {
            receiver.receive(message: message)
        }
    }
    
    func send(message: [String : Any], receiver: Receivable) throws {
        guard let actualReceiver = receivers.first(where: { $0.id == receiver.id }) else { throw MediatorError.missingReceiver }
        actualReceiver.receive(message: message)
    }
}
``` 
The implementations are quite simple but powerful, since we just implemented a protocol extension that will make the inter-object communication so easily done!

The last peace of work that we need to do is to create a concrete class that will conform to the `Mediator` protocol:

```swift
class CharactersMediator: Mediator {
    var receivers: [Receivable] = []
}
```

Since we have the default implementations as protocol extensions we just need to implement all the additional logic, which is quite minimal in our case. 

## Game Objects
Now we have all the architectural components in order to make a real example!

We are going to implement a number of game objects that will pass messages to each other by using the implemented `Mediator` and `Receivable` protocols.  

Let's assume that we have two classes: `Player` and `FlyingMob`. Both of the classes have quite similar implementations, for the sake of simplicity they will mimic "real" game objects. We assume that `Player` instance is controlled by a user and various instances of `FlyingMob` class are controller by artificial intelligence. 

```swift
class Player: Receivable {
    var id: String = UUID.init().uuidString
    var name: String

    init(name: String) {
        self.name = name
    }
    
    func receive(message: [String : Any])  {
        print("Player under id: ", id, " has received a message: ", message)
    }
}

class FlyingMob: Receivable {
    var id: String = UUID.init().uuidString
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func receive(message: [String : Any]) {
        print("FlyingMod under id: ", id, " has received a message: ", message)
    }
}
```
The implementation is mostly consists of the conformance to the `Receivable` prtocol, a `name` property and a designated initializer.

Let's create a few instances and take a look how it will actually work.

## Assembling
The first thing that need to do is to create actual objects that will participate in message passing. Then we will create `CharactersMediator` instance, assign the `Receivable` instances as `receivers` and send some messages.

```swift
// 1
let player = Player(name: "Mario")
let flyingMobBlue = FlyingMob(name: "Blue")
let flyingMobYellow = FlyingMob(name: "Yellow")
let flyingMobBoss = FlyingMob(name: "Boss")

// 2
let mediator = CharactersMediator()

// 3
let characters: [Receivable] = [ player, flyingMobBlue, flyingMobYellow, flyingMobBoss ]
mediator.receivers += characters

// 4
mediator.send(message: ["death note" : "you are going to die soon!😄"], sender: player)

// 5
try? mediator.send(message: ["hitTest" : (x: 10, y: 23)], receiver: player)
```
Let's break the sample code down:

1. Here we instantiated a `Player` instance named `Mario` and several instances for `FlingMob` class. 
2. Then we have created `CharactersMediator` instance that will be used to mediate between the game objects.
3. However, before actually sending some messages we need to assign the `Receivable`s as `receivers` in our `CharactersMediator` class. 
4. Now we are ready to mediate! 😄 Our player has been asked to send a **death note** to all the `AI` characters before he will eliminate them! After the all the messages will be passed we will get something like that in our console:

```swift
FlyingMod under id:  8D229EF6-5DB9-4DCD-98C9-9D9ABC8C4A01  has received a message:  ["death note": "you are going to die soon!😄"]
FlyingMod under id:  2CDA13EB-2000-4797-9012-E4945F92E646  has received a message:  ["death note": "you are going to die soon!😄"]
FlyingMod under id:  36A7454E-ED2C-4F75-B433-E248CF439DEA  has received a message:  ["death note": "you are going to die soon!😄"]
```
All the messages have been sent! Great!

5. You cannot threaten our `AI` without any consequences. The `flyingMobBoss` decided to reply:

```swift
Player under id:  A00C8478-DFB8-440D-827E-2FF6B15D1842  has received a message:  ["you are going to be slapped at": (x: 10, y: 23)]
```
Our `Mario` just has received his first message. We can continue on by sending new messages back and forth and selecting the type of message sender in our `Mediator`.

One thing to note that the message type and the whole mechanism of message passing can be futher improved. For instance, message passing mechanism can be made type-safe, since right now it's more like what we had in our good old days (hello legacy `Objective-C`). Another improvement can be done by introducing mechanisms like `read receipt` or adding more sophisticated `send` methods where we can add injectable rules that will be used to filter out the receivers in a type-safe way.

## Conclusion 
As we saw, `Mediator` pattern is quite simple to implement. Its usage and potential applications are quite intuitive. The pattern does a great job by decoupling the inter-object communications and removing tight coupling, by eliminating the direct access between senders and receivers. The pattern has great extensibility, especially by introducing the protocol-oriented extensions that greatly reduce the amount of code that needs to be written. 

It's worth to mention that there are implementations where the senders and receivers have references of a `Mediator` instance. Be careful if you decide to use such an approach, since you can easily create a retain cycle and, as a result, make the senders and receivers less light-weight and dependent on external objects.