//
//  Builder
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/08/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

// Approach #1 (Classic, based on POP)

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


// Approach #2 (Dynamic, Modern, may cause run-time crash, based on POP & Swift's keypaths)


class Song {
    
    private static let UNKNOWN: String = "unknown"
    
    enum Genre {
        case rock
        case classic
        case electro
        case rap
        case pop
        case other(name: String)
    }
    
    var name:           String  = Song.UNKNOWN
    var author:         String  = Song.UNKNOWN
    var genre:          Genre   = .other(name: Song.UNKNOWN)
    var duration:       Int     = -1
    var releaseDate:    String  = Song.UNKNOWN
    
    init() { /* empty implementation */ }
    
    init(name: String, author: String, genre: Genre, duration: Int, releaseDate: String) {
        self.name = name
        self.author = author
        self.genre = genre
        self.duration = duration
        self.releaseDate = releaseDate
    }
}

protocol BuilderProtocol { /* empty, implementation is added to the protocol extension*/ }

extension BuilderProtocol where Self: AnyObject {
    
    @discardableResult
    func `init`<T>(_ property: ReferenceWritableKeyPath<Self, T>, with value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
}

extension Song: BuilderProtocol { /* empty implementation */ }

let song = Song()
    .init(\.author,         with: "The Heavy")
    .init(\.name,           with: "Same Ol`")
    .init(\.genre,          with: .rock)
    .init(\.duration,       with: 184)
    .init(\.releaseDate,    with: "2012")
