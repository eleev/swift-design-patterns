//
//  CheeseBurgerBuilder.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 25/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public struct CheeseBurgerBuilder: BurgerBuilder {
    
    // MARK: - Properties
    
    public var name: String = "CheeseBurger"
    public var patties: Int = 1
    public var bacon: Bool = false
    public var cheese: Bool = true
    public var pickles: Bool = true
    public var mustard: Bool = true
    public var tomato: Bool = false
    
    // MARK: - Initializers
    
    public init() {
        // Empty initializer, just overriden the access modifier
    }
}
