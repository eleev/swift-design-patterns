# Marker Design Pattern
`Marker` is a structural design pattern that is used to provide run-time metadata with objects. The associated information then used to indicate that the marked type requires specific treatment or belongs to a particular category that needs to be processed uniquely. 

In Swift the pattern is implemented using `protocols`. We simply create an *empty protocol* and a *target type* that needs to be marked. Then we can retrieve that information at run-time and perform some custom logic around the corresponding types.

## Example
As an example we build a simple skeleton structure for game objects and game systems that process types that are marked with particular `marker`. 

### Markers

We start off from declaring `marker` protocols for our needs: 

```swift
protocol Interactable {  /* empty */ }
protocol Destructible { /* empty */ }
protocol PositionUpdatable { /* empty */ }
```
We introduced three difference protocols with empty implementation. The first one, called `Interactable` will be used to mark game objects that can be touched. `Destructible` protocol will be used to mark game objects that can be destroyed and `PositionUpdatable` protocol will mark types that can be move around a game level.

The first type that will conform to all of the protocols will be `BunnyEnemy` class:

```swift
class BunnyEnemy: SKSpriteNode, Interactable, Destructible {
    
    // MARK: - Properties
    
    var movementSpeed: CGFloat
    
    // MARK: - Initializers
    
    init(position: CGPoint, texture: SKTexture, movementSpeed: CGFloat) {
        self.movementSpeed = movementSpeed
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
    }
}
```
We used `SpriteKit` framework to build this custom node. The implementation is fairly trivial: 

- The class has just a single custom property for movement speed
- Designated initializer 
- And the required initializer

We conformed to all two of the `marker` protocols: `Interactable` and `Destructible` since we designed our game in a way where the bunny enemies can not move around - they guard particular areas.

The next step is to create an another type for `Player`:

```swift
class Player: SKSpriteNode, Destructible, PositionUpdatable {
    
    // MARK: - Initializers
    
    init(position: CGPoint, texture: SKTexture) {
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
    }
}
```
This class is even simpler and has just the designated and required initializers. However our player conforms to only two protocols: `Destructible` - since player character can die and `PositionUpdatable` - since the player can move around. 

### Systems
*Marked* game objects will be processed by `systems` that are represented and *structs* that are responsible for processing nodes with specific markers.

```swift
struct InteractionSystem {
    
    // MARK: - Properties
    
    typealias InteractableSprite = SKSpriteNode & Interactable
    
    private(set) var interactables: [InteractableSprite]
    
    // MARK: - Initializers
    
    init() {
        interactables = []
    }
    
    // MARK: - Methods
    
    mutating func add(interactable: InteractableSprite) {
        interactables += [interactable]
    }
    
    func touchesBegan(touches: Set<UITouch>, with event: UIEvent?) {
        for interactable in interactables {
            interactable.touchesBegan(touches, with: event)
        }
    }
}
```

The first system is for `Interactable` marker. `InteractionSystem` delegates touch handling to the objects contained in `interactables` array. In `SpriteKit` scene this system in combination with `marker` design pattern is used to decompose responsibilities for delegating touch events, which simplifies scenes and makes the touch handling code more easily maintained.

The next system will be `DestructionSystem`:

```swift
struct DestructionSystem {
    
    // MARK: - Properties
    
    typealias DestructibleSprite = SKSpriteNode & Destructible
    
    private(set) var destructibles: [DestructibleSprite]
    
    // MARK: - Initializers
    
    init() {
        destructibles = []
    }
    
    private lazy var animationSequence: SKAction = {
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        return sequence
    }()
    
    // MARK: - Methods
    
    mutating func add(destructible: DestructibleSprite) {
        destructibles += [destructible]
    }
    
    mutating func destroy() {
        for destructible in destructibles {
            destructible.run(animationSequence)
        }
    }
}
```

The presented system works slightly differently: we append game objects that need to be destroyed and then at some point we call `destroy` method to apply animation sequence to all of them. The system simplifies management of a scene, allows for custom extensions related to game object destruction and decomposes responsibilities into dedicated objects (hello `Single Responsibility` principle). 

And the final system that we are about to present will be `PositionUpdatableSystem`:

```swift
struct PositionUpdatableSystem {
    
    // MARK: - Properties
    
    typealias PositionUpdatableSprite = SKSpriteNode & PositionUpdatable
    
    private(set) var updatables: [PositionUpdatableSprite]
    var inputSource: InputSource
    
    // MARK: - Initializers
    
    init(inputSource: InputSource) {
        self.inputSource = inputSource
        updatables = []
    }
    
    // MARK: - Methods
    
    mutating func add(updatable: PositionUpdatableSprite) {
        updatables += [updatable]
    }
    
    mutating func update() {
        
        for updatable in updatables {
            updatable.position = inputSource.move(currentPosition: updatable.position)
        }
    }
}
```
The final system works a bit differently than the others: it updates positions of the game objects with respect to the `InputSource`, which can be an another subsystem that is responsible for handling movement of characters.

### Usage

In order to use the systems we create them and our game objects:

```swift
// Systems

var interactionSystem = InteractionSystem()
var positionUpdatableSystem = PositionUpdatableSystem(inputSource: characterMovementController)
var destructionSystem = DestructionSystem()
    
// Game objects

let player = Player(position: CGPoint(x: 50, y: 120), texture: SKTexture(imageNamed: "player.png"))

let bunny = BunnyEnemy(position: CGPoint(x: 140, y: 165), texture: SKTexture(imageNamed: "bunny-mad.png"), movementSpeed: 3.24)

let bunnyFat = BunnyEnemy(position: CGPoint(x: 180, y: 165), texture: SKTexture(imageNamed: "bunny-fat"), movementSpeed: 1.03)
```
Then add them to the corresponding systems:

```swift
positionUpdatableSystem = PositionUpdatableSystem(inputSource: characterMovementController)
positionUpdatableSystem?.add(updatable: player)

interactionSystem.add(interactable: bunny)
interactionSystem.add(interactable: bunnyFat)
```
Interaction logic can be delegated using the corresponding method of `SKScene` class:

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
	interactionSystem.touchesBegan(touches: touches, with: event)
}
```

And the other systems can process marked objects using their `API`, like so:

```swift
override func update(_ currentTime: TimeInterval) {
	positionUpdatableSystem?.update()
        
	// ...
	// At some point, enemies are added to the Destruction System, this piece of code simulates that:
	if currentTime == 3840578 {
		destructionSystem.add(destructible: bunny)
		destructionSystem.add(destructible: bunnyFat)
	}
        
	// Later on, a bunny killed our player, so we add the player to the Destruction System to be destroyed:
        destructionSystem.add(destructible: player)
        
	// At the end of the update loop we call the destroy method to delegate the destruction to the corresponding system
	destructionSystem.destroy()
}
```
By using `marker`/`system` approach we have separated different responsibilities into systems by creating types that are marked by corresponding `marker` protocols. `Marker` protocols provided run-time metadata which then was used. 

We could achieve similar results by various ways: implementing common functionality into protocols, instead of making them empty. However we would need to provide a common *handler* type anyways, that would store and delegate method calls to the destination points.


## Issues

The main issue with `Marker` pattern is that it's implemented using protocols, that defines contract to be conformed or implemented. Then all the types that inherit from the marked type also have that metadata associated with them. Basically the marker conformance cannot be undone for the child types which may lead to unexpected run-time issues, that are hard to debug.

The described issue can be eliminated with *custom, user-defined attributes* which are not yet supported by Swift - only pre-defined *attributes* can be used. 

## Conclusion
`Marker` pattern may be used in cases when we don't need to actually implement functionality in protocols, instead implementing it in separate types that process the marked types. Such separation makes it very easy to create many processing types for multiple markers without the need to implement it in the protocol itself and then executing each instance somewhere else. 

It provides run-time metadata along with types and can be easily, later on converted to regular protocols with methods, properties and extensions. However the pattern has some issues as well, in cases when the marked type has children that don't suppose to hold unneeded metadata. 