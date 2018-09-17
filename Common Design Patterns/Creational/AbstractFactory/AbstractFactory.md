# Abstract Factory Design Pattern
`Abstract Factory` is a creational design pattern that is aimed to simplify creation of objects at run-time without specifying their concrete types. That is accomplished by incapsulating a group of related factories that operate the same domain-specific types. 

The pattern has some similarities with another creational pattern called `Factory Method`. Don't be confused by the common nature and similar names of the patterns - they are different and have different restrictions and purposes. 

`Abstract Factory` is implemented using a type rather than a method, can be `inherited` and `extended`. The pattern hides the related factories that specifically know how to create concrete types that belong to the factory. In order to implement the pattern we need to define a type that will incapsulate the related sub-factories and a `protocol` that will be used as the resulting type of the factory. In some cases there might be several protocols, each for a separate sub-factory. That will allow to produce non-dependent types. 

<!--act as an `abstract factory` and a `protocol` that will be used as the resulting type of the factory. Which type exactly - will be determined at runtime.-->

We will create two factories: one for creating `postapocalyptic vehicles` and the other will be used to create `regular vehicles`. Then we will build *Abstract Factory* that will be producing various types of vehicles, depending on non type-related properties and without exposing the underlying theme-specific factories.

<!--Our example will be the following: we need to create a land vehicle based on whether there are zombies walking on the Earth or not. If zombie apocalypse happened - then we need a post-apocalyptic car that can shoot rockets or flame. Otherwise, if zombie apocalypse hasn't happened yet 😅, then our factory will produce a very powerful sport car. 
-->
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
class SportCar: LandVehicle, MovableProtocol, RotatableProtocol, TurboAcceleratable {
    
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
    
     // MARK: - Conformance to TurboAcceleratable protocol
    
    func accelerate() {
        print("accelerated!")
    }
}

```

`MovableProtocol` and `RotatableProtocol` are protocols that add certain functions for our `SportCar` type - they indicate what capabilities our vehicles have. 

The next type that we are going to implement is `PostapocalypticCar`:

```swift
class PostapocalypticCar: LandVehicle, MovableProtocol, RotatableProtocol, ShootableProtocol {
    
    // MARK: - LandVehicle properties
    
    var engine: [Engine]
    var wheels: [Wheel]
    var body: CarBody
    
    // MARK: - Conformance to ShootableProtocol
    
    var missileType: MissileType
    
    // MARK: - Initializers
    
    init(missileType: MissileType) {
        self.missileType = missileType
        
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
    
    func shoot() {
        print("shoot missile of type: ", missileType)
    }
}
```
Additionally `PostapocalypticCar` conforms to `ShootableProtocol` which adds shooting capability using `MissileType` (rockets, bullets or flame). The conformance to this protocol adds some differentiate characteristic to anti-zombie car.

Each of the `LandVehicle` types incapsulate the functionality related to the instantiation of `self`, so the factory will be free from set up code. Please note that it's not required, your factories may be responsible for setting up the related types.

Next, we create theme-specific factories:

```swift
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
```

`SteampunkTruck` is similar to `PostapocalypticCar` except some type specific details (the code for *SteampunkTruck* can be found in the corresponding `.playground` file). The two factories specifically operate on either `Shootable` or `Regular` vehicles. For instance we can add some other land vehicle without a weapon system and add it to our `RegularVehicleFactory`. 

```swift
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
```

The factory is implemented using boolean values that are used to determine which type will be instantiated at runtime and then produced by the theme-specific factory.

```swift
// Create the factory 🏭
let vehicleFactory = VehicleFactory()

// Produce a vehicle with the specified properties
let steampunkTruck = vehicleFactory.produce(areThereZombies: false, hasWeapSystem: true) as? SteampunkTruck
// Use car-specific functionality 
steampunkTruck?.shoot()


// Produce another vehicle based on different initial requirements
let sportCar = vehicleFactory.produce(areThereZombies: true, hasWeapSystem: false) as? SportCar
// Use turbo acceleration available for Sport Car 🚗:
sportCar?.accelerate()
```

The usage of the factory is pretty straightforward. We have created the factory for vehicles and then produced our first vehicle that is a regular vehicle but has weapon system. Our factory will delegate this work to `ShootableVehicleFactory` that will produce for us `SteampunkLandVehicle` instance. Next, we produce another vehicle but adopted for zombie apocalypse and without weapon system. 

## Conclusion
`Abstract Factory` provides means for creating objects based on external parameters, configure them differently and provide specific type capabilities based on run-time requirements, by delegating the work to sub-factories that operate on theme-specific types. Since, the factory is built around concrete type, we can use `type extension` and `inheritance` to extend the capabilities. Use this pattern when you have related, unstructured types and you don't want to expose the way they are constructed. Also this pattern helps when you have run-time factors that affect the type that needs to be selected and constructed.