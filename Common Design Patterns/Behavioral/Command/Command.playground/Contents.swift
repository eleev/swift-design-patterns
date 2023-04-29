//: Playground - noun: a place where people can play

import Foundation

protocol DoorCloseCommand {
    func close()
}
protocol DoorOpenCommand {
    func open()
}

struct MainDoor: DoorCloseCommand, DoorOpenCommand {

    func close() {
        print("MainDoor -> " + #function)
    }

    func open() {
        print("MainDoor -> " + #function)
    }
}


struct HallDoor: DoorCloseCommand, DoorOpenCommand {

    func close() {
        print("HallDoor -> " + #function)
    }

    func open() {
        print("HallDoor -> " + #function)
    }
}

struct GarageDoor: DoorCloseCommand, DoorOpenCommand {

    func close() {
        print("GarageDoor -> " + #function)
    }

    func open() {
        print("GarageDoor -> " + #function)
    }
}

struct SequrityRemoteControl {

    // MARK: - Properties

    var door: DoorCloseCommand & DoorOpenCommand

    // MARK: - Initializers

    init(_ door: DoorCloseCommand & DoorOpenCommand) {
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
