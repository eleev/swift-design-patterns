import Foundation

protocol Receivable {
    var id: String { get }
    func receive(message: [String : Any])
}

enum MediatorError: Error {
    case missingReceiver
}

protocol Mediator {

    var receivers: [Receivable] { get set }
    
    /// Sends the specified message to all the registered receivers except the sender
    ///
    /// - Parameters:
    ///   - message: is a message that will be delivered to all the receivers
    ///   - sender: is a sender that conforms to Receivable protocol
    func send(message: [String : Any], sender: Receivable)
    
    /// Sends the specified message to the concrete receiver
    ///
    /// - Parameters:
    ///   - message: is a message that will be delivered to all the receivers
    ///   - receiver: is a receiver that conforms to Receivable protocol
    func send(message: [String : Any], receiver: Receivable) throws
}

extension Mediator {
    func send(message: [String : Any], sender: Receivable) {
        for receiver in receivers where receiver.id != sender.id {
            receiver.receive(message: message)
        }
    }
    
    func send(message: [String : Any], receiver: Receivable) throws {
        guard let actualReceiver = receivers.first(where: { $0.id == receiver.id }) else { throw MediatorError.missingReceiver }
        actualReceiver.receive(message: message)
    }
}



class Player: Receivable {
    var id: String = UUID.init().uuidString
    var name: String

    init(name: String) {
        self.name = name
    }
    
    func receive(message: [String : Any])  {
        print("Player under id: ", id, " has received a message: ", message)
    }
}

class FlyingMob: Receivable {
    var id: String = UUID.init().uuidString
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func receive(message: [String : Any]) {
        print("FlyingMod under id: ", id, " has received a message: ", message)
    }
}


class CharactersMediator: Mediator {
    var receivers: [Receivable] = []
}


let player = Player(name: "Mario")
debugPrint("Player id: ", player.id)

let flyingMobBlue = FlyingMob(name: "Blue")
debugPrint("FlyingMobBlue id: ", flyingMobBlue.id)

let flyingMobYellow = FlyingMob(name: "Yellow")
debugPrint("FlyingMobYellow id: ", flyingMobYellow.id)

let flyingMobBoss = FlyingMob(name: "Boss")
debugPrint("FlyingMobBoss id: ", flyingMobBoss.id)

let mediator = CharactersMediator()
let characters: [Receivable] = [ player, flyingMobBlue, flyingMobYellow, flyingMobBoss ]
mediator.receivers += characters

mediator.send(message: ["death note" : "you are going to die soon!😄"], sender: player)
try? mediator.send(message: ["you are going to be slapped at" : (x: 10, y: 23)], receiver: player)
