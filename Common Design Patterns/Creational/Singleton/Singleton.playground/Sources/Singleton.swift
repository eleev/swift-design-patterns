//
//  Singleton.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public class Singleton {
    
    // MARK: - Singleton property
    
    public static let instnage = Singleton()
    
    // MARK: - Properties
    
    public private(set) var counter: Int
    
    // MARK: - Private initializer
    
    private init() {
        // Private initialier ensires that there will not access it from the outside, so instances can only be created inside the class
        counter = 0
    }
    
    // MARK: - Methods
    
    public func foo() {
        print(#function + " foo")
    }
    
    public func bar() {
        print(#function + " bar")
    }
    
    public func increment() {
        counter += 1
    }
    
    public func decrement() {
        counter -= 1
    }
}


public class StructSignleton {
    
    // MARK: - Sharead instance class property
    
    public class var sharedInstance: StructSignleton {
        struct Static {
            static let instance = StructSignleton()
        }
        return Static.instance
    }
    
    // MARK: - Properties
    
    public private(set) var counter: Int
    
    // MARK: - Initializers
    
    private init() {
        counter = 0
    }
    
    // MARK: - Methods
    
    public func foo() {
        print(#function + " foo")
    }
    
    public func bar() {
        print(#function + " bar")
    }
    
    public func increment() {
        counter += 1
    }
    
    public func decrement() {
        counter -= 1
    }
}

public class DispatchSingleton {
    
    // MARK: - Thread safe shared instance
    
    public class var sharedInstance: DispatchSingleton {
        struct Static {
            static var onceToken: String = "DispatchSingleton"
            static var instance: DispatchSingleton? = nil
        }
        DispatchQueue.once(token: Static.onceToken) {
            Static.instance = DispatchSingleton()
        }
        return Static.instance!
    }
    
    // MARK: - Properties
    
    public private(set) var counter: Int
    
    // MARK: - Initializers
    
    private init() {
        counter = 0
    }
    
    // MARK: - Methods
    
    public func foo() {
        print(#function + " foo")
    }
    
    public func bar() {
        print(#function + " bar")
    }
    
    public func increment() {
        counter += 1
    }
    
    public func decrement() {
        counter -= 1
    }
    
}

public extension DispatchQueue {
    
    // MARK: - Properties
    
    private static var _onceTracker = [String]()
    
    // MARK: - Methods
    
    /// Executes a block of code, associated with a unique token, only once.  The code is thread safe and will onle execute the code once even in the presence of multithreaded calls.
    ///
    /// - Parameters:
    ///   - token: is a unique reverse DNS-style name such as io.eleev.astemir or a GUID
    ///   - block: is a non-escaping closure that is executed only once
    class func once(token: String, block: () -> Void ) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
