//
//  Burger.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 25/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

struct Burger: BurgerBuilder {

    // MARK: - Properties
    
    var name: String
    var patties: Int
    var bacon: Bool
    var cheese: Bool
    var pickles: Bool
    var mustard: Bool
    var tomato: Bool

    
    // MARK: - Initializers
    
    init(builder: BurgerBuilder) {
        self.name = builder.name
        self.patties = builder.patties
        self.bacon = builder.bacon
        self.cheese = builder.cheese
        self.pickles = builder.pickles
        self.mustard = builder.mustard
        self.tomato = builder.tomato
    }
    
}

extension Burger: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Properties
    
    var description: String {
        return compose()
    }
    
    var debugDescription: String {
        return compose()
    }
    
    // MARK: - Private methods
    
    private func compose() -> String {
        let description = """
        name: \(name),
        patties: \(patties),
        bacon: \(bacon),
        cheese: \(cheese),
        pickles: \(pickles),
        mustard: \(mustard),
        tomato: \(tomato),
        """
        return description
    }
    
    
}
