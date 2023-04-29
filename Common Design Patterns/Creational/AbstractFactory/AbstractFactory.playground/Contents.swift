import Foundation
import UIKit

protocol SerialNumberable {
    
    // MARK: - Proeprties
    
    var id: String { get set }
}

extension SerialNumberable {
    
    // MARK: - Methods
    
    mutating func generateId() {
        id = UUID.init().uuidString
    }
}

struct Engine: SerialNumberable {
    
    // MARK: - Conformance to SerialNumberable protocol
    
    var id: String
    
    // MARK: - Properties
    
    var horsepower: Int
}

extension Engine: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Conformances to CustomStringConvertible and CustomDebugStringConvertible protocols
    
    var description: String {
        return representation()
    }
    
    var debugDescription: String {
        return representation()
    }
    
    // MARK: - Private helpers
    
    private func representation() -> String {
        return """
        id: \(id),
        horsepower: \(horsepower)
        """
    }
    
}

struct CarBody: SerialNumberable {
    
    // MARK: - Conformance to SerialNumberable protocol
    
    var id: String
    
    // MARK: - Properties
    
    var color: UIColor
}

extension CarBody: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Conformances to CustomStringConvertible and CustomDebugStringConvertible protocols
    
    var description: String {
        return representation()
    }
    
    var debugDescription: String {
        return representation()
    }
    
    // MARK: - Private helpers
    
    private func representation() -> String {
        return """
        id: \(id),
        color: \(color)
        """
    }
    
}

struct Wheel: SerialNumberable {
    
    // MARK: - Conformance to SerialNumberable protocol
    
    var id: String
    
    // MARK: - Properties
    
    var radius: Double
}

extension Wheel {
    
    init(radius: Double) {
        self.radius = radius
        self.id = ""
        generateId()
    }
}

extension Wheel: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Conformances to CustomStringConvertible and CustomDebugStringConvertible protocols
    
    var description: String {
        return representation()
    }
    
    var debugDescription: String {
        return representation()
    }
    
    // MARK: - Private helpers
    
    private func representation() -> String {
        return """
        id: \(id),
        radius: \(radius)
        """
    }
    
}

protocol LandVehicle {
    
    // MARK: - Properties
    
    var engine: [Engine] { get }
    var wheels: [Wheel] { get }
    var body: CarBody { get }
}

class PostapocalypticCar: LandVehicle, MovableProtocol, RotatableProtocol, ShootableProtocol, CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - LandVehicle properties
    
    var engine: [Engine]
    var wheels: [Wheel]
    var body: CarBody
    
    // MARK: - Conformance to ShootableProtocol
    
    var missileType: MissileType
    
    // MARK: - Initializers

    init(missileType: MissileType) {
        
        let engine = Engine(id: "V12", horsepower: 1200)
        var wheels = [Wheel]()
        let numberOfWheels = 4
        
        for _ in 0..<numberOfWheels {
            wheels += [Wheel(radius: 56)]
        }
        let body = CarBody(id: "Bugatti", color: .orange)
        self.engine = [engine]
        self.wheels = wheels
        self.body = body
        
        self.missileType = missileType
    }
    
    // MARK: - Conformance to MovableProtocol
    
    func move(to direction: MovementType) {
        print("moved:", direction)
    }
    
    // MARK: - Conformance to RotatableProtocol
    
    func turn(to direction: RotationType) {
        print("turned to the:", direction)
    }
    
    // MARK: - Conformance to ShootableProtocol
    
    func shoot() {
        print("shoot missile of type: ", missileType)
    }
    
}

class SteampunkTruck: LandVehicle, MovableProtocol, RotatableProtocol, ShootableProtocol, CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - LandVehicle properties
    
    var engine: [Engine]
    var wheels: [Wheel]
    var body: CarBody
    
    // MARK: - Conformance to ShootableProtocol
    
    var missileType: MissileType
    
    // MARK: - Initializers
    
    init(missileType: MissileType) {
        self.missileType = missileType
        
        let engine = Engine(id: "V8", horsepower: 1200)
        var wheels = [Wheel]()
        let numberOfWheels = 6
        
        for _ in 0..<numberOfWheels {
            wheels += [Wheel(radius: 72)]
        }
        let body = CarBody(id: "Truck", color: .orange)
        self.engine = [engine]
        self.wheels = wheels
        self.body = body
    }
    
    // MARK: - Conformance to MovableProtocol
    
    func move(to direction: MovementType) {
        print("moved:", direction)
    }
    
    // MARK: - Conformance to RotatableProtocol
    
    func turn(to direction: RotationType) {
        print("turned to the:", direction)
    }
    
    // MARK: - Conformance to ShootableProtocol
    
    func shoot() {
        print("shoot missile of type: ", missileType)
    }
}

class SportCar: LandVehicle, MovableProtocol, RotatableProtocol, TurboAcceleratable, CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - LandVehicle properties
    
    var engine: [Engine]
    var wheels: [Wheel]
    var body: CarBody
    
    // MARK: - Initializer
    
    init() {
        let engineOne = Engine(id: "V8", horsepower: 850)
        let engineTwo = Engine(id: "V6", horsepower: 550)
        
        var wheels = [Wheel]()
        let numberOfWheels = 8
        
        for _ in 0..<numberOfWheels {
            wheels += [Wheel(radius: 92)]
        }
        
        let body = CarBody(id: "Titan Body", color: .cyan)
        
        self.engine = [engineOne, engineTwo]
        self.wheels = wheels
        self.body = body
    }
    
    // MARK: - Conformance to MovableProtocol
    
    func move(to trajectory: MovementType) {
        print("moved:", trajectory)
    }
    
    // MARK: - Conformance to RotatableProtocol
    
    func turn(to direction: RotationType) {
        print("turned to the:", direction)
    }
    
    // MARK: - Conformance to TurboAcceleratable protocol
    
    func accelerate() {
        print("accelerated!")
    }
    
}

extension LandVehicle where Self : CustomStringConvertible & CustomDebugStringConvertible {
    
    // MARK: - Conformances to CustomStringConvertible and CustomDebugStringConvertible protocols
    
    var description: String {
        return representation()
    }
    
    var debugDescription: String {
        return representation()
    }
    
    // MARK: - Private helpers
    
    private func representation() -> String {
        return """
        engine: \(engine),
        wheels: \(wheels),
        body: \(body)
        """
    }
    
}

protocol TurboAcceleratable {
    func accelerate()
}

enum MovementType {
    case forward
    case backward
    case none
}

protocol MovableProtocol {
    func move(to direction: MovementType)
}

enum RotationType {
    case left
    case right
    case none
}

protocol RotatableProtocol {
    func turn(to direction: RotationType)
}

enum MissileType {
    case rocket
    case bullet
    case fire
}

protocol ShootableProtocol {
    
    // MARK: - Properties
    
    var missileType: MissileType { get }
    
    // MARK: - Methods
    
    func shoot()
}

class ShootableVehicleFactory {
    
    func produce(with missileType: MissileType) -> LandVehicle {
        return missileType == .fire ? SteampunkTruck(missileType: .fire) : PostapocalypticCar(missileType: missileType)
    }
}

class RegularVehicleFactory {
    
    func produce() -> LandVehicle {
        return SportCar()
    }
}


struct VehicleFactory {

    // MARK: - Private properties
    
    private let shootableVehicleFactory = ShootableVehicleFactory()
    private let regularVehicleFactory = RegularVehicleFactory()
    
    // MARK: - Factory
    
    func produce(areThereZombies: Bool, hasWeapSystem: Bool) -> LandVehicle {
        
        switch (zombies: areThereZombies, weaponSystem: hasWeapSystem) {
        case (true, true):
            return shootableVehicleFactory.produce(with: .rocket)
        case (false, true):
            return shootableVehicleFactory.produce(with: .fire)
        default:
            return regularVehicleFactory.produce()
        }
    }
}


//: Usage

let vehicleFactory = VehicleFactory()
let steampunkTruck = vehicleFactory.produce(areThereZombies: false, hasWeapSystem: true) as? SteampunkTruck
steampunkTruck?.shoot()

print(steampunkTruck?.description ?? "steampunkTruck is nil")

let sportCar = vehicleFactory.produce(areThereZombies: true, hasWeapSystem: false) as? SportCar
sportCar?.accelerate()
print(sportCar?.description ?? "sportCar is nil")
