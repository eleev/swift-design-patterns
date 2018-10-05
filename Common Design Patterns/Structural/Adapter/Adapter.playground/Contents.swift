import Foundation

// Components:
// Adaptee
// Adapter
// Target

// Types:
// Extension adapter
// Class adapter


// Let's assume by some reasons our Lightning Socket protocol has no ability to be programmatically connected, just attached and it immediately stars charging
protocol LightningSocketType {
    func attach()
    func charge()
}

/// Adaptee that needs to be adapted to work with USB-C port
class iPhone: LightningSocketType {
    
    var isLoggingEnabled: Bool = true
    
    /// ...
    /// Among other possbilities, our iPhone struct has an ability to charge our phone
    ///...
    
    // MARK: - Conformance to LightningSocketType protocol
    
    func attach() {
        if isLoggingEnabled {
            print("iPhone is being attached using Lightning Socket")
        }
    }
    
    func charge() {
        if isLoggingEnabled {
            print("iPhone is being charged using Lightning Socket")
        }
    }
}


protocol USBCSocketType {
    func connect()
    func charge()
}

/// Adapter
class USBCAdapter: USBCSocketType {
    
    // MARK: - Properties
    
    var lightningSocket: LightningSocketType {
        didSet {
            disableLogging()
        }
    }
    
    // MARK: - Initializers
    
    init(for lightningSocket: LightningSocketType) {
        self.lightningSocket = lightningSocket
        disableLogging()
    }
    
    // MARK: - Methods
    
    private func disableLogging() {
        (self.lightningSocket as? iPhone)?.isLoggingEnabled = false
    }
    
    // MARK: - Conformance to USBCSocketType protocol
    
    func connect() {
        print("iPhone is being connected using USB-C Socket Adapter")
        lightningSocket.attach()
    }
    
    func charge() {
        print("iPhone is being charged using USB-C Socket Adapter")
        lightningSocket.charge()
    }
}

/// Target
class USBCCharger {
    
    var socket: USBCSocketType {
        didSet {
            connect()
        }
    }
    
    init(using socket: USBCSocketType) {
        self.socket = socket
        connect()
    }
    
    func charge() {
        socket.charge()
    }
    
    private func connect() {
        self.socket.connect()
    }
}

//: Usage:

let phone = iPhone()
let usbcAdapter = USBCAdapter(for: phone)

let charger = USBCCharger(using: usbcAdapter)
charger.charge()


// Created new iPhone
let newiPhone = iPhone()
// Reused the old USB-C socket adapter in order to be able to connect to the USB-C charger
usbcAdapter.lightningSocket = newiPhone
// Reattached the adapter with a new iPhone device
charger.socket = usbcAdapter
