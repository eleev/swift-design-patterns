import Foundation

protocol Memento {
    
    // MARK: - Properties

    var data: [String : Any] { get }
    
    // MARK: - Initializers
    
    init?(data: [String : Any])
}

protocol Caretaker {
    
    var states: [String] { get }
    
    // MARK: - Methods
    
    mutating func save<T: Memento>(memento: T, for stateName: String)
    func restore<T: Memento>(state: String) -> T?
    func delete(state: String)
}


@dynamicMemberLookup
struct PropertyListCarataker: Caretaker {
    
    // MARK: - Private properties

    private let standardDefaults = UserDefaults.standard

    // MARK: - Initializers
    
    init() { }
    
    // MARK: - Conformance to Caretaker protocol

    var states: [String] = []
    
    mutating func save<T: Memento>(memento: T, for stateName: String) {
        standardDefaults.set(memento.data, forKey: stateName)
    }

    func restore<T: Memento>(state: String) -> T? {
        guard let data = standardDefaults.object(forKey: state) as? [String : Any] else {
            return nil
        }
        let memento = T(data: data)
        return memento
    }
    
    func delete(state: String) {
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


var user = User(name: "Astemir", age: 26, address: "Dovatora st.35")

var animal = Animal(name: "Monkey", age: 8)

var caretaker = PropertyListCarataker()
caretaker.save(memento: user, for: "defaultUser")
caretaker.save(memento: animal, for: "defaultAnimal")

user.age = 32
animal.age = 10

caretaker.save(memento: user, for: "defaultUser01")
caretaker.save(memento: animal, for: "defaultAnimal01")

user.name = "Alex"
animal.name = "Cat"

caretaker.save(memento: user, for: "defaultUser02")
caretaker.save(memento: animal, for: "defaultAnimal02")

print(user)
print(animal)



if let restoredUser: User? = caretaker.defaultUser, let user = restoredUser {
    print("restored: ", user)
}

if let restoredUser: User? = caretaker.defaultUser01, let user = restoredUser {
    print("restored: ", user)
}

if let restoredUser: User? = caretaker.defaultUser02, let user = restoredUser {
    print("restored: ", user)
}

if let restoredUser: Animal? = caretaker.defaultAnimal, let user = restoredUser {
    print("restored: ", user)
}

if let restoredUser: Animal? = caretaker.defaultAnimal02, let user = restoredUser {
    print("restored: ", user)
}

//if let restoredUser: User? = caretaker.restore(state: "default 01"), let user = restoredUser {
//    print("restored: ", user)
//}
