# Memento Design Pattern
`Memento` is a behavioral design pattern that allows to save and restore an object's state without breaking encapsulation. Our implementation will be slightly differnet than the classic one, which splits the pattern into three components: `memento`, `carataker` and `originator`. `Caretaker` will be responsible for saving and restoring a `memento` object using a concrete implementation of storage and `memento` will be represented as a protocol that defines a contract for all types that should have storing/restoring capabiliy.

## Implementation
We start off from declaring `Memento` protocol:

```swift
protocol Memento {
    
    // MARK: - Properties

    var data: [String : Any] { get }
    
    // MARK: - Initializers
    
    init?(data: [String : Any])
}
```
The protocol defines a read-only property for dictionary can be store `Any` type for a `String` key. The dictionary will be used to store and restore the internal state of a particular type. Then we defined a required, failable initializer that accepts a dictionary as an input parameter. The initializer will be used by the `Caretaker` instance to restore an object.

Next, we implement a protocol called `Caretaker`. The protocol will be resposible for declaring contract for all kinds of concrete mechanisms that will actually save and restore *memento* objects.

```swift
protocol Caretaker {
    
    // MARK: - Properties
    
    var states: [String : String] { get }
    
    // MARK: - Methods
    
    mutating func save<T: Memento>(memento: T, for stateName: String)
    func restore<T: Memento>(state: String) -> T?
    mutating func delete(state: String)
}
```

The `states` property that is dicttionary of types `String` and `String` for keys and values, that will be internally holding states, in order to be able to re-use or reference them at run-time. As an `API` the protocol defines `three` methods for saving a `memento` for a given state, restoring from state and deleting the state of a `memento` object.

Let's implement a concrete `Caretaker` called `PropertyListCarataker` that is built around `UserDefaults` mechanism:

```swift
@dynamicMemberLookup
struct PropertyListCarataker: Caretaker {
    
    // MARK: - Private properties

    private let standardDefaults = UserDefaults.standard
    private static let STATES_KEY = "KEYS FOR STATES"
    
    // MARK: - Initializers
    
    init() {
        if let states = standardDefaults.object(forKey: PropertyListCarataker.STATES_KEY) as? [String : String] {
            print("restored state keys: ", states)
            self.states = states
        }
    }
    
    // MARK: - Conformance to Caretaker protocol

    var states: [String : String] = [:] {
        didSet {
            standardDefaults.set(states, forKey: PropertyListCarataker.STATES_KEY)
        }
    }
    
    mutating func save<T: Memento>(memento: T, for stateName: String) {
        states.updateValue(stateName, forKey: stateName)
        standardDefaults.set(memento.data, forKey: stateName)
    }

    func restore<T: Memento>(state: String) -> T? {
        guard let data = standardDefaults.object(forKey: state) as? [String : Any] else {
            return nil
        }
        let memento = T(data: data)
        return memento
    }
    
    mutating func delete(state: String) {
        states.removeValue(forKey: state)
        standardDefaults.removeObject(forKey: state)
    }
    
    // MARK: - Dynamic Member Lookup Subscripts
    
    subscript<T: Memento>(dynamicMember input: String) -> T? {
        return restore(state: input)
    }
}
```

The implementation is based on `struct`. We defiend a private `UserDefaults` property for convenient re-use and added conformance for `Carataker` protocol. The implementation is pretty straightforward, we used the built-in `API` for persistance. The interesting thing here is a relatively new feature of `Swift` called `dynamic member lookup`. We will use it to syntatically make the code more clear, however you may skip it, since it's not mandatory. 

The final part of our implementation is to create a couple of classes that will conform to `Memento` protocol. Let's implement a `User` and an `Animal` classes:

```swift
class User: Memento {
    
    var name: String
    var age: Int
    var address: String
    
    var data: [String : Any] {
        return ["name" : name, "age" : age, "address" : address]
    }
    
    init(name: String, age: Int, address: String) {
        self.name = name
        self.age = age
        self.address = address
    }
    
    required init?(data: [String : Any]) {
        guard let mName = data["name"] as? String, let mAge = data["age"] as? Int, let mAddress = data["address"] as? String else {
            return nil
        }
        name = mName
        age = mAge
        address = mAddress
    }
}

class Animal: Memento {
    
    var name: String
    var age: Int
    
    var data: [String : Any] {
        return ["name" : name, "age" : age]
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    required init?(data: [String : Any]) {
        guard let mName = data["name"] as? String, let mAge = data["age"] as? Int else {
            return nil
        }
        name = mName
        age = mAge
    }
}
```
The approach that is used to save and restore the state using the dictionary is pretty similar to the one used with `NSCoding` protocol: we save the properes for the specified keys and then in the required, failable initializer we restore them. Firther, it can be improved with more type-safe keys, rather than using `String` literals. 

## Usage

The usage of the `Memento` pattern is all about creating objects, saving states by using a concrete `Carataker` and later on restoring a state by using one of the `String` keys.

```swift
// A new user - John
var user = User(name: "John", age: 26, address: "New Ave, 456")
// A new animal - Monkey
var animal = Animal(name: "Monkey", age: 8)

// The initial states of the objects are:
// name: John, age: 26, address: New Ave, 456
// name: Monkey, age: 8

var caretaker = PropertyListCarataker()

// We save the default states of the user and animal
caretaker.save(memento: user, for: "defaultUser")
caretaker.save(memento: animal, for: "defaultAnimal")

// Then we change the age of the user and the animal
user.age = 32
animal.age = 10

// And save the states by using new state-keys
caretaker.save(memento: user, for: "defaultUser01")
caretaker.save(memento: animal, for: "defaultAnimal01")

// Then we change the names to be able to check if the pattern works correctly
user.name = "Alex"
animal.name = "Cat"

// As a result we have the following states of the objects:
// name: Alex, age: 32, address: New Ave, 456
// name: Cat, age: 10
```

In the presented snippet of code, we created a user and an animal. Then we created a `PropertyListCarataker` instnace and saved the states of the `memento` objects. Then we changed the ages of the objects and again saved then by using different state-keys. Finally, we changed the names of the `memento` objects to be able to verify that we actually are able to save and restore objects using varios state-keys. 

```swift
if let restoredUser = caretaker.defaultUser as User? {
	// name: John, age: 26, address: New Ave, 456
}

if let restoredUser = caretaker.defaultUser01 as User? {
	// name: John, age: 32, address: New Ave, 456
}

if let restoredAnimal = caretaker.defaultAnimal as Animal? {
	// name: Monkey, age: 8
}

if let restoredAnimal = caretaker.defaultAnimal02 as Animal? {
	// name: Cat, age: 10
}
```
The first saved state for the state-key named `defaultUser` is correct! As well as the remaining states. We are able to restart our `macOS` or `iOS` application and be able to restore any object that conforms to the `Memento` protocol to a certain state. 
 
## Conclusion