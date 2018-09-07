
import SpriteKit

protocol Interactable {  /* empty */ }
protocol Destructible { /* empty */ }
protocol PositionUpdatable { /* empty */ }

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
            destructionSystem.add(destructible: bunny)
            destructionSystem.add(destructible: bunnyFat)
        }
        
        // Later on, a bunny killed our player, so we add the player to the Destruction System to be destroyed:
        destructionSystem.add(destructible: player)
        
        // At the end of the update loop we call the destroy method to delegate the destruction to the corresponding system
        destructionSystem.destroy()
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
