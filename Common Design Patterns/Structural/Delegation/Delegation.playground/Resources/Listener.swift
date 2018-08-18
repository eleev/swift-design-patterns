//
//  Listener.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

class Listener: DelegateProtocol {
    
    // MARK: - Properties
    
    var delegateClass: Delegate?
    
    // MARK: - Initializers
    
    init() {
        delegateClass = Delegate(delegate: self)
    }
    
    // MARK: - Conformance to DelegateProtocol
    
    func methodOne() {
        print(#function + " delegated method call for methodOne")
    }
    
    func methodTwo() {
        print(#function + " delegated method call for methoTwo")
    }
    
}
