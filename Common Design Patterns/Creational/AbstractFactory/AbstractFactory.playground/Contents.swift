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
    
    // MARK: - Initializers

    init() {
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
    
    func shoot(missileOf type: MissileType) {
        print("shoot missile of type: ", type)
    }
    
}

class SportCar: LandVehicle, MovableProtocol, RotatableProtocol, CustomStringConvertible, CustomDebugStringConvertible {
    
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
    func shoot(missileOf type: MissileType)
}


struct VehicleFactory {
    
    var areThereZombies = false
    
    func produce() -> LandVehicle {
        return areThereZombies ? producePostApocalypticCar() : produceSportCar()
    }
    
    // MARK: - Private helpers
    
    private func produceSportCar() -> LandVehicle {
        return SportCar()
    }
    
    private func producePostApocalypticCar() -> LandVehicle {
        return PostapocalypticCar()
    }
    
}


//: Usage
var vehicleFactory = VehicleFactory()
let sportCar = vehicleFactory.produce()

print(sportCar)

//engine: [id: V12,
//horsepower: 1200],
//wheels: [id: 89CA2C97-E540-4864-B5A5-34A0CCE89C59,
//radius: 56.0, id: 99AB06F6-2554-4AFD-927A-18C4B54B8119,
//radius: 56.0, id: 52DA8B5B-CAD4-4CB2-A767-5A2771FC23FE,
//radius: 56.0, id: B1F58094-2CC9-494C-920E-EB997D4111C6,
//radius: 56.0],
//body: id: Bugatti,
//color: UIExtendedSRGBColorSpace 1 0.5 0 1

print("\n")

vehicleFactory.areThereZombies = true

let postapocalypticCar = vehicleFactory.produce() as? PostapocalypticCar
print(postapocalypticCar as Any)
postapocalypticCar?.shoot(missileOf: .rocket)

//engine: [id: V8,
//horsepower: 850, id: V6,
//horsepower: 550],
//wheels: [id: 9A2FE063-A62E-45EA-914B-AA06D52B118C,
//radius: 92.0, id: C7286782-9DD4-404E-B4F7-6F2DA08172CD,
//radius: 92.0, id: FA20326B-7910-4BE7-A620-624EF6C31435,
//radius: 92.0, id: 7DA56464-EDEF-4FA2-9CE5-75383A91D85F,
//radius: 92.0, id: A6F9E12C-E4FE-4309-8069-3FEF8088BFD2,
//radius: 92.0, id: 7826EC39-787C-4737-BD7A-B5C67DC5362D,
//radius: 92.0, id: 4A4A6CBF-2190-4D85-A987-C7ABF09250D9,
//radius: 92.0, id: BC771330-66D4-4622-BE95-8AF38DE04543,
//radius: 92.0],
//body: id: Titan Body,
//color: UIExtendedSRGBColorSpace 0 1 1 1


