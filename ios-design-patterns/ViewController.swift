//
//  ViewController.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Storyboard {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension ViewController {
    
    func builder() {
        let hamburger = Burger(builder: HamburgerBuilder())
        print(#function + " hamburger ",  hamburger)
        
        let cheeseBurger = Burger(builder: CheeseBurgerBuilder())
        print(#function + " cheeseburger ", cheeseBurger)
    }
    
    func facade() {
        var fromDateComponents = DateComponents()
        fromDateComponents.year = 2018
        fromDateComponents.month = 01
        fromDateComponents.day = 01
        
        var toDateComponents = DateComponents()
        toDateComponents.year = 2019
        toDateComponents.month = 02
        toDateComponents.day = 15
        
        let currentCalendar = Calendar.current
        guard let from = currentCalendar.date(from: fromDateComponents) else {
            return
        }
        guard let to = currentCalendar.date(from: toDateComponents) else {
            return
        }
        
        // Prepare the Facade
        let travelFacade = TravelFacade(from: from, to: to)
        
        let hotel = Hotel()
        let flight = Flight()
        let rentalCar = RentalCar()
        
        travelFacade.book(hotel: hotel, flight: flight, rentalCar: rentalCar)
    }
    
    func delegation() {
        let listener = Listener()
        
        // Trigger some event in the Delegate instance so the listener will be notified about the action
        listener.delegateClass?.someFunc()
        
    }
    
    func singleton() {
        let singleton = Singleton.instnage
        singleton.foo()
        singleton.bar()
    }
    
}

