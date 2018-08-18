//
//  HamburgerBuilder.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 25/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

struct HamburgerBuilder: BurgerBuilder {
    
    // MARK: - Properties
    
    var name: String = "Burger"
    var patties: Int = 1
    var bacon: Bool = false
    var cheese: Bool = false
    var pickles: Bool = true
    var mustard: Bool = true
    var tomato: Bool = false
    
}
