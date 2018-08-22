//
//  Burger.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 25/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public struct Burger: BurgerBuilder {

    // MARK: - Properties
    
    public var name: String
    public var patties: Int
    public var bacon: Bool
    public var cheese: Bool
    public var pickles: Bool
    public var mustard: Bool
    public var tomato: Bool
    
    // MARK: - Initializers
    
    public init(builder: BurgerBuilder) {
        self.init(name: builder.name,
                  patties: builder.patties,
                  bacon: builder.bacon,
                  cheese: builder.cheese,
                  pickles: builder.pickles,
                  mustard: builder.mustard,
                  tomato: builder.tomato)
    }
    
    public init(name: String, patties: Int, bacon: Bool, cheese: Bool, pickles: Bool, mustard: Bool, tomato: Bool) {
        self.name = name
        self.patties = patties
        self.bacon = bacon
        self.cheese = cheese
        self.pickles = pickles
        self.mustard = mustard
        self.tomato = tomato
    }
    
}

extension Burger: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Properties
    
    public var description: String {
        return compose()
    }
    
    public var debugDescription: String {
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
