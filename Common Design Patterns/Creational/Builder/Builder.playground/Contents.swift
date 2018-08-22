//
//  Builder
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/08/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

let cheeseBurgerPlain = Burger(name: "Cheese Burger", patties: 1, bacon: false, cheese: true, pickles: true, mustard: true, tomato: false)

let hamburgerBurgerPlain = Burger(name: "Hamburger", patties: 1, bacon: false, cheese: false, pickles: true, mustard: true, tomato: false)

let cheeseBurger = Burger(builder: CheeseBurgerBuilder())
let hamburgerBurger = Burger(builder: HamburgerBuilder())

let burgerInjectableClosureHam: BurgerInjectable.BurgerInjectasbleClosure = { burger in
    
    burger.name = "Hamburger"
    burger.patties = 1
    burger.bacon = false
    burger.cheese = false
    burger.pickles = true
    burger.mustard = true
    burger.tomato = false
}

let burgerInjectableHam = BurgerInjectable(builder: burgerInjectableClosureHam)


