# Prototype Design Pattern
`Prototype` is a creational design pattern that is aimed to create new instances of objects using a prototypical instance. That prototypical instance is cloned to produce new objects. The pattern is used in situations when subclassing needs to be avoided and when construction of a new object is inefficient. Another application of the pattern is it allows to create snapshots of a given state for an object. 

## Prototype
We start off by declaring a common `Prototype` protocol:

```swift
protocol Prototype {
    func clone() -> Prototype
}
```
The protocol defined a common contract for all the types that need to support *prototyping* feature. Next we create an `AIPatrolCharacter` class for a hypothetical game.

```swift
enum PatrolBehaviorType {
    case land
    case air
    case underground
}

class AIPatrolCharacter: Prototype {
    
    // MARK: - Properties
    
    private(set) var name: String
    private var sprite: SKSpriteNode?
    var patrolBehaviorType: PatrolBehaviorType
    
    // MARK: - Initializers
    
    init(name: String, sprite: SKSpriteNode?, patrolBehaviorType: PatrolBehaviorType) {
        self.name = name
        self.sprite = sprite
        self.patrolBehaviorType = patrolBehaviorType
    }
    
    // MARK: - Conformance to Prototype prtocol
    
    func clone() -> Prototype {
        return AIPatrolCharacter(name: name, sprite: sprite, patrolBehaviorType: patrolBehaviorType)
    }
}
```

The class presents an *AI* character that is designed to patrolls a specific area: `land`, `air` or `underground`. Next, let's take a look how `Prototype` pattern is used:

```swift
let landPatroller = AIPatrolCharacter(name: "Patroller", sprite: SKSpriteNode(fileNamed: "Patroller.png"), patrolBehaviorType: .land)
// Land Patroller:  name: Patroller, sprite: nil, patrol behavior type: land

// Prototype the AI character for air:
let airPatroller = landPatroller.clone() as? AIPatrolCharacter
airPatroller?.patrolBehaviorType = .air
// Air Patroller:  Optional(name: Patroller, sprite: nil, patrol behavior type: air)
```
We have created the initial character that patrols `land` area. Then we `cloned` it and changed the patrol type to `air`. As a result we got a new patroller for air space with a few lines of code. You may be thinking: 
> Well, we could just create that air patroller with a line of code. 

Indeed, we could and can do that for the aforementioned example - it just changed a single property to create new patroller! But it's inefficient in cases when we need to reuse many more properties to change the state of an object. Also, remember the other, earlier mentioned benefits that we get using `Prototype` pattern.

## Conclusion
`Prototype` pattern is pretty easy to implement from scratch and add to existing types. It also can be used in combination with `Factory Method` pattern, in order to further simplify creation of objects: rather than having one protocol as a resulting type of a factory, we can just use the concrete `Prototype` type, which is cloned and re-configured based on run-time requirements.