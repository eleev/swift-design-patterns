//
//  BurgerInjectasble.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/08/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public class BurgerInjectable {
    
    // MARK: - Properties
    
    public var name: String?
    public var patties: Int?
    public var bacon: Bool?
    public var cheese: Bool?
    public var pickles: Bool?
    public var mustard: Bool?
    public var tomato: Bool?
    
    // MARK: - Typealias
    
    public typealias BurgerInjectasbleClosure = (BurgerInjectable) -> ()
    
    // MARK: - Initializers
    
    public init(builder: BurgerInjectasbleClosure) {
        builder(self)
    }
}

extension BurgerInjectable: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Properties
    
    public var description: String {
        return compose()
    }
    
    public var debugDescription: String {
        return compose()
    }
    
    // MARK: - Private method
    
    private func compose() -> String {
        let description = """
        name: \(name as Any),
        patties: \(patties as Any),
        bacon: \(bacon as Any),
        cheese: \(cheese as Any),
        pickles: \(pickles as Any),
        mustard: \(mustard as Any),
        tomato: \(tomato as Any),
        """
        return description
    }
    
}
