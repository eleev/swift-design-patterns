//
//  RentalCarFacade.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

struct RentalCarBooking: Booking {
    
    // MARK: - Methods
    
    static func getBookables(from fdate: Date, to tdate: Date) -> [Bookable]? {
        let rentalCars = [RentalCar]()
        // Logic for renting cas
        return rentalCars
    }
    
    static func book(_ bookable: Bookable) {
        // Logic to reserve a rental car
    }
    
}
