//
//  Bridge.swift
//  swift-design-patterns
//
//  Created by Astemir Eleev on 29/08/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import UIKit

public protocol Chargeable: class {
    
    // MARK: - Properties
    
    var device: MobilePhone { get set }
    
    // MARK: - Methods
    
    func charge()
}

public class Charger: Chargeable {
    
    public var device: MobilePhone
    
    public init(device: MobilePhone) {
        self.device = device
    }
    
    public func charge() {
        print("Charging device named: ", device)
    }
}

public enum PhoneNumber: Int {
    case mom = 348957
    case dad = 133412
    case brother = 82398
    case friend = 38740
    case cat = 666 // Evil cat that dropps everything 👹😄
}

public protocol Callable {
    func call(number: PhoneNumber)
    func hangOut()
}

public protocol MobilePhone {
    
    // MARK: - Properties
    
    var name: String { get set }
    var model: String { get set }
    
    // MARK: - Methods
    
    func turnOn()
    func turnOff()
}


public class iPhone: MobilePhone, Callable {
    
    // MARK: - Conformance to MobilePhone protocol
    
    // MARK: - Properties
    
    public var name: String = "iPhone"
    public var model: String = "XXVIXI"
    
    // MARK: - Methods
    
    public func turnOn() {
        print("Turned On: ", name)
    }
    
    public func turnOff() {
        print("Turned Off: ", name)
    }
    
    // MARK: - Conformance to Callable protocol
    
    public private(set) var callConnected: PhoneNumber?
    
    public func call(number: PhoneNumber) {
        print("Calling to: ", number)
    }
    
    public func hangOut() {
        print("Hang out call: ", callConnected as Any)
    }
    
}

public class ApplePhone: MobilePhone, Callable {
    
    // MARK: - Conformance to MobilePhone protocol
    
    // MARK: - Properties
    
    public var name: String = "ApplePhone"
    public var model: String = "13s-"
    
    // MARK: - Methods
    
    public func turnOn() {
        print("Turned On: ", name)
    }
    
    public func turnOff() {
        print("Turned Off: ", name)
    }
    
    // MARK: - Conformance to Callable protocol
    
    public private(set) var callConnected: PhoneNumber?
    
    public func call(number: PhoneNumber) {
        print("Calling to: ", number)
    }
    
    public func hangOut() {
        print("Hang out call: ", callConnected as Any)
    }
}


//: Usage

let iphone = iPhone()
iphone.call(number: .cat)
// After the conversation with our cat, the phone is dead and needs to be recharged
let applePhone = ApplePhone()
applePhone.call(number: .friend)
// The same story with our Apple Phone here

// Create a single charger and attach iPhone to it
let charger = Charger(device: iphone)
// Charge the device
charger.charge()

// Deattach the iPhone and connect ApplePhone
charger.device = applePhone
// Charge the ApplePhone
charger.charge()


// Sometimes an additional Bridge type is used to allow the two hierarchies of abstraction and implementation to interfere with each other. In this example Chargable protocol represents abstraction and MobilePhone represents the concrete implementation; Implementation is referred as Implementor and the layer that holds a reference to Implementor is the abstraction layer.

class ChargingDockBridge {
    
    func connect(charger: Chargeable, with device: MobilePhone) {
        charger.device = device
        charger.charge()
    }

}


let dockStation = ChargingDockBridge()
// The bridging type simplifies the intercommunication between the abstraction and the implementation futher by decomposing the interference code into a separate API method call
dockStation.connect(charger: charger, with: iphone)
