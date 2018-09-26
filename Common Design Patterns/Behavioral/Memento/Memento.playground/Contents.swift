import Foundation

protocol Memento {
    
    // MARK: - Properties

    var data: [String : Any] { get }
    
    // MARK: - Initializers
    
    init?(data: [String : Any])
}

protocol Caretaker {
    
    // MARK: - Properties
    
    var states: [String : String] { get }
    
    // MARK: - Methods
    
    mutating func save<T: Memento>(memento: T, for stateName: String)
    func restore<T: Memento>(state: String) -> T?
    mutating func delete(state: String)
}


@dynamicMemberLookup
struct PropertyListCaretaker: Caretaker {
    
    // MARK: - Private properties

    private let standardDefaults = UserDefaults.standard
    private static let STATES_KEY = "KEYS FOR STATES"
    
    // MARK: - Initializers
    
    init() {
        if let states = standardDefaults.object(forKey: PropertyListCaretaker.STATES_KEY) as? [String : String] {
            print("restored state keys: ", states)
            self.states = states
        }
    }
    
    // MARK: - Conformance to Caretaker protocol

    var states: [String : String] = [:] {
        didSet {
            standardDefaults.set(states, forKey: PropertyListCaretaker.STATES_KEY)
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

extension User: CustomStringConvertible {
    var description: String {
        return "name: \(name), age: \(age), address: \(address)"
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

extension Animal: CustomStringConvertible {
    var description: String {
        return "name: \(name), age: \(age)"
    }
}


var user = User(name: "John", age: 26, address: "New Ave, 456")

var animal = Animal(name: "Monkey", age: 8)

var caretaker = PropertyListCaretaker()
caretaker.states
if let user = caretaker.restore(state: "defaultUser02") as User? {
    print("user that was restored from the persistent state key: ", user)
}

caretaker.save(memento: user, for: "defaultUser")
caretaker.save(memento: animal, for: "defaultAnimal")

user.age = 32
animal.age = 10

caretaker.save(memento: user, for: "defaultUser01")
caretaker.save(memento: animal, for: "defaultAnimal01")

user.name = "Alex"
animal.name = "Cat"
//
//caretaker.save(memento: user, for: "defaultUser02")
//caretaker.save(memento: animal, for: "defaultAnimal02")

print(user)
print(animal)



if let restoredUser = caretaker.defaultUser as User? {
    print("restored: ", restoredUser)
}

if let restoredUser = caretaker.defaultUser01 as User? {
    print("restored: ", restoredUser)
}

//if let restoredUser = caretaker.defaultUser02 as User? {
//    print("restored: ", restoredUser)
//}

if let restoredAnimal = caretaker.defaultAnimal as Animal? {
    print("restored: ", restoredAnimal)
}

if let restoredAnimal = caretaker.defaultAnimal02 as Animal? {
    print("restored: ", restoredAnimal)
}

//if let restoredUser: User? = caretaker.restore(state: "default 01"), let user = restoredUser {
//    print("restored: ", user)
//}
