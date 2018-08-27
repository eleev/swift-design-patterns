# Abstract Factory Pattern
`Abstract Factory` is a creational design pattern that is aimed to simplify creation of objects in runtime without specifying their concrete types. The pattern has some similarities with another creational pattern called `Factory Method`. Don't be confused by the common nature and similar names of the patterns - they are different and have different restrictions. 

`Abstract Factory` is implemented using a type rather than a method and can be `inherited` and `extended`. In order to implement the pattern we need to define a type that will act as `abstract factory` and a `protocol` that will be used as the resulting type of the factory. Which type exactly - will be determined at runtime. 

Our example will be built around the following task: we need to create a land vehicle based on whether there are zombies walking on the Earth or not. If zombie apocalypse happened - then we need a post-apocalyptic car that can shoot rockets or flame. Otherwise, if zombie apocalypse hasn't happened yet 😅, then our factory will produce a very powerful sport car. 

## Implementation

We start from defining `LandVehicle` protocol that will be used as a runtime type for our abstract factory:

```swift
protocol LandVehicle {
    
    // MARK: - Properties
    
    var engine: [Engine] { get }
    var wheels: [Wheel] { get }
    var body: CarBody { get }
}
```

The protocol defines a set of properties that describe main components for our land vehicles: engine (can have multiple for post-apocalyptic car), wheels and the vehicle body. 

Then we create a concrete type for `SportCar` and add conformance to `LandVehicle` protocol:

```swift
class SportCar: LandVehicle, MovableProtocol, RotatableProtocol {
    
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
    
    func move(to trajectory: MovementType) {
        print("moved:", trajectory)
    }
    
    // MARK: - Conformance to RotatableProtocol
    
    func turn(to direction: RotationType) {
        print("turned to the:", direction)
    }
    
}

```

`MovableProtocol` and `RotatableProtocol` are protocols that add certain functions for our `SportCar` type - they indicate what capabilites our vehicles have. 

The next type that we are going to implement is `PostapocalypticCar`:

```swift
class PostapocalypticCar: LandVehicle, MovableProtocol, RotatableProtocol, ShootableProtocol {
    
    // MARK: - LandVehicle properties
    
    var engine: [Engine]
    var wheels: [Wheel]
    var body: CarBody
    
    // MARK: - Initializers
    
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
```
Additionally `PostapocalypticCar` conforms to `ShootableProtocol` which adds shooting capability using `MissileType` (rockets, bullets or flame). The conformance to this protocol adds some differentiative characteristic to anti-zombie car.


Each of the `LandVehicle` types incapsulate the functionality related to the instantiation of `self`, so the factory will be free from set up code. Please note that it's not required, your abstract factory may be responsible for setting up the related types.

```swift
struct VehicleFactory {
    
    // MARK: - Properties
    
    var areThereZombies = false
    
    // MARK: - Methods
    
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
```

The factory is implemented using a basic boolean rule that is used to determine which type will be instantiated at runtime and produced. 

```swift
// Create the factory
var vehicleFactory = VehicleFactory()
// Set the state of the factory to produce postapocalyptic land vehicles
vehicleFactory.areThereZombies = true

// Cast the produces vehicle as PostapocalypticCar
let postapocalypticCar = vehicleFactory.produce() as? PostapocalypticCar
// Shoot a rocket! 🚀 Kill all the zombies! 😄
postapocalypticCar?.shoot(missleOf: .rocket)

// After killing all the zombies we set the state of the factory to produce SportCar
vehicleFactory.areThereZombies = false
let sportCar = vehicleFactory.produce()
// Now we have a normal 🚗
```

The usage of the factory is pretty straightforward:

- We instantiate the `Abstract Factory`
- We change the factory state to produce `PostapocalypticCar` type
- We shoot the rocket and kill all the zombies 🚀
- Then we again change the state of the factory to produce sport car 🚗

## Conclusion
`Abstract Factory` is a great and very easy to use creational pattern! It provides means for creating objects based on external parameters, configure them differently, and provide specific type capabilities based on runtime requirements. Since the implementation is built around concrete type, we can use `type extension` and `inheritance` in order to create families of factories or domain specific factories.
