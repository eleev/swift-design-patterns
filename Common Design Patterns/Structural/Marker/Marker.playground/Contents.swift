
import SpriteKit

protocol Interactable {  /* empty */ }
protocol Destructable { /* empty */ }
protocol PositionUpdatable { /* empty */ }

class BunnyEnemy: SKSpriteNode, Interactable, Destructable, PositionUpdatable {
    
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

class Player: SKSpriteNode, PositionUpdatable {
    
    // MARK: - Initializers
    
    init(position: CGPoint, texture: SKTexture) {
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) has not been implemented")
    }
}


struct InteractionSystem {
    
    typealias InteractableSprite = SKSpriteNode & Interactable
    
    private(set) var interactables: [InteractableSprite]
    
    init() {
        interactables = []
    }
    
    mutating func add(interactable: InteractableSprite) {
        interactables += [interactable]
    }
    
    func touchesBegan(touches: Set<UITouch>, with event: UIEvent?) {
        for interactable in interactables {
            interactable.touchesBegan(touches, with: event)
        }
    }
}

struct DestructionSystem {
    
    typealias DestructableSprite = SKSpriteNode & Destructable
    
    private(set) var destructables: [DestructableSprite]
    
    init() {
        destructables = []
    }
    
    private lazy var animationSequence: SKAction = {
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        return sequence
    }()
    
    mutating func add(destructable: DestructableSprite) {
        destructables += [destructable]
    }
    
    mutating func destroy() {
        for destructable in destructables {
            destructable.run(animationSequence)
        }
    }
}

struct PositionUpdatableSystem {
    
    typealias PositionUpdatableSprite = SKSpriteNode & PositionUpdatable
    
    private(set) var updatables: [PositionUpdatableSprite]
    var inputSource: InputSource
    
    init(inputSource: InputSource) {
        self.inputSource = inputSource
        updatables = []
    }
    
    mutating func add(updatable: PositionUpdatableSprite) {
        updatables += [updatable]
    }
    
    mutating func update() {
        
        for updatable in updatables {
            updatable.position = inputSource.move(currentPosition: updatable.position)
        }
    }
}

protocol InputSource {
    func move(currentPosition position: CGPoint) -> CGPoint
    func rotate(currentAngle angle: CGFloat) -> CGFloat
}

struct CharacterMovement: InputSource {
    
    func move(currentPosition position: CGPoint) -> CGPoint {
        print("Character-specific logic for movement from position: ", position)
        return .zero // implement character movement logic and return right CGPoint position
    }
    
    func rotate(currentAngle angle: CGFloat) -> CGFloat {
        print("Character-specific rotatation from angle: ", angle)
        return 0.0 // implement character rotation logic and return right CGFloat angle
    }

}


class Scene: SKScene {
    
    // MARK: - Properties
    
    let player = Player(position: CGPoint(x: 50, y: 120), texture: SKTexture(imageNamed: "player.png"))
    let bunny = BunnyEnemy(position: CGPoint(x: 140, y: 165), texture: SKTexture(imageNamed: "bunny-mad.png"), movementSpeed: 3.24)
    let bunnyFat = BunnyEnemy(position: CGPoint(x: 180, y: 165), texture: SKTexture(imageNamed: "bunny-fat"), movementSpeed: 1.03)

    var interactionSystem = InteractionSystem()
    var positionUpdatableSystem: PositionUpdatableSystem?
    var destructionSystem = DestructionSystem()
    
    let characterMovementController = CharacterMovement()
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        physicsWorld.contactDelegate = self
        
        positionUpdatableSystem = PositionUpdatableSystem(inputSource: characterMovementController)
        
        interactionSystem.add(interactable: bunny)
        interactionSystem.add(interactable: bunnyFat)
        
        positionUpdatableSystem?.add(updatable: player)

    }

    override func update(_ currentTime: TimeInterval) {
        positionUpdatableSystem?.update()
        
        // ...
        // At some point, enemies are added to the Destruction System, this piece of code simulates that:
        if currentTime == 3840578 {
            destructionSystem.add(destructable: bunny)
            destructionSystem.add(destructable: bunnyFat)
        }
    }
    
    // MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        interactionSystem.touchesBegan(touches: touches, with: event)
    }
}

extension Scene: SKPhysicsContactDelegate {
    
    override func didSimulatePhysics() {
        destructionSystem.destroy()
    }
}
