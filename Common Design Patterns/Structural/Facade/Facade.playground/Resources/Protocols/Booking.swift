//
//  Booking.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

protocol Booking {
    
    // MARK: - Methods
    
    static func getBookables(from fdate: Date, to tdate: Date) -> [Bookable]?
    static func book(_ bookable: Bookable)
}
