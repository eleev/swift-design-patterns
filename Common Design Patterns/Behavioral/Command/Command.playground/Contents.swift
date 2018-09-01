//: Playground - noun: a place where people can play

import UIKit

protocol DoorCommandProtocol {
    func close()
    func open()
}

struct MainDoor: DoorCommandProtocol {
    
    func close() {
        print("MainDoor -> " + #function)
    }
    
    func open() {
        print("MainDoor -> " + #function)
    }
}


struct HallDoor: DoorCommandProtocol {
    
    func close() {
        print("HallDoor -> " + #function)
    }
    
    func open() {
        print("HallDoor -> " + #function)
    }
}

struct GarageDoor: DoorCommandProtocol {
    
    func close() {
        print("GarageDoor -> " + #function)
    }
    
    func open() {
        print("GarageDoor -> " + #function)
    }
}

struct SequrityRemoteControl {
    
    // MARK: - Properties
    
    var door: DoorCommandProtocol
    
    // MARK: - Initializers
    
    init(_ door: DoorCommandProtocol) {
        self.door = door
    }
    
    // MARK: - Methods
    
    func openDoor() {
        door.open()
    }
    
    func closeDoor() {
        door.close()
    }
}

//: Usage:

let mainDoor = MainDoor()
let hallDoor = HallDoor()
let garageDoor = GarageDoor()

var remoteControl = SequrityRemoteControl(mainDoor)
remoteControl.openDoor()
remoteControl.closeDoor()

remoteControl.door = hallDoor
remoteControl.openDoor()

remoteControl.door = garageDoor
remoteControl.openDoor()
