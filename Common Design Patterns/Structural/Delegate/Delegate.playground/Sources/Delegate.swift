//
//  Delegate.swift
//  swift-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import UIKit

public class Delegate: DelegateProtocol {
    
    // MARK: - Initializer
    
    public init() {
        // Empty initializer
    }
    
    // MARK: - Conformance to DelegateProtocol
    
    public func methodOne() {
        print(#function + " delegated method call for methodOne")
    }
    
    public func methodTwo() {
        print(#function + " delegated method call for methoTwo")
    }
    
    public func set(color: UIColor) {
        print(#function + " delegated method call for set(color:)")
    }
    
}
