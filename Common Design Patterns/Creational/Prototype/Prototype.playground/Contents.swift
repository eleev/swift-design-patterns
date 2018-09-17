import Foundation
import SpriteKit

protocol Prototype {
    func clone() -> Prototype
}

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

extension AIPatrolCharacter: CustomStringConvertible {
    var description: String {
        return "name: \(name), sprite: \(sprite as Any), patrol behavior type: \(patrolBehaviorType)"
    }
}

//: Usage:


let landPatroller = AIPatrolCharacter(name: "Patroller", sprite: SKSpriteNode(fileNamed: "Patroller.png"), patrolBehaviorType: .land)

print("Land Patroller: ", landPatroller)

let airPatroller = landPatroller.clone() as? AIPatrolCharacter
airPatroller?.patrolBehaviorType = .air

print("Air Patroller: ", airPatroller as Any)
print("Land Patroller: ", landPatroller)
