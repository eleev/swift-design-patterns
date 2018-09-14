# Observer Desing Pattern
`Observer` is a behavioral design pattern that is aimed to simplify communication between objects by providing means for notification handling and incapsulating logic around communication, without the need know how exactly those notifications are processed and sent to the observers.The pattern decreases coupling between objects that listen for events and an object that raises them. `Observer` pattern decouples their relationship by separating objects into two layers called `Observer` and `Subject`. 

`Observer` is represented as a protocol that defines common interface for communication. `Subject` is an object that emits events and sends them to multiple *Observers*. That forms *one-to-many* relationship, where one *Subject* sends notifications to many *Observers*. As a *notification* we may use a common protocol and in some implementations concrete classes, structs or enum types. 

The pattern has some similarities with `Multicast Delegate` and `Event Listener`, however *Observer* is different pattern and has its own applications.

## Observers
In order to implement the pattern, we start off from defining an `Observer` protocol. The protocol will be used for each type that requires to receive notifications from the emitter:

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

## Juicing Up

## Conclusio