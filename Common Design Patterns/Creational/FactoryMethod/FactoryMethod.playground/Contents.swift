import Foundation

enum Engine {
    case v2
    case v8
    case v12
}

enum Price {
    case cheap
    case affordable
    case expensive
}

protocol Car {
    var name: String { get }
    var engine: Engine { get }
    var price: Price { get }
}

struct Bugaggi: Car {
    var name: String = "Buggagi Chevron"
    var engine: Engine = .v12
    var price: Price = .expensive
}

extension Bugaggi: CustomStringConvertible {
    var description: String {
        return "name: \(name), engine: \(engine), price: \(price)"
    }
}

struct Fodr: Car {
    var name: String = "Fodr Pahamareno"
    var engine: Engine = .v8
    var price: Price = .affordable
}

extension Fodr: CustomStringConvertible {
    var description: String {
        return "name: \(name), engine: \(engine), price: \(price)"
    }
}

struct Truck: Car {
    var name: String = "Truck Trashmobile"
    var engine: Engine = .v2
    var price: Price = .cheap
}

extension Truck: CustomStringConvertible {
    var description: String {
        return "name: \(name), engine: \(engine), price: \(price)"
    }
}

class CarFactory {
    
    func produce(price: Price) -> Car {
        switch price {
        case .expensive:
            return Bugaggi()
        case .affordable:
            return Fodr()
        case .cheap:
            return Truck()
        }
    }
}

let carFactory = CarFactory()
let expensivePowerfulCar = carFactory.produce(price: .expensive)
print("expensivePowerfulCar: ", expensivePowerfulCar)

let cheapAndNotPoweful = carFactory.produce(price: .cheap)
print("cheapAndNotPoweful: ", cheapAndNotPoweful)

