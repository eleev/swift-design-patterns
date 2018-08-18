//
//  Singleton.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

class Singleton {
    
    // MARK: - Singleton property
    
    static let instnage = Singleton()
    
    // MARK: - Private initializer
    
    private init() {
        // Private initialier ensires that there will no access to from the outside, so instances can only be created inside the class
    }
    
    // MARK: - Methods
    
    func foo() {
        print(#function + " foo")
    }
    
    func bar() {
        print(#function + " bar")
    }
}
