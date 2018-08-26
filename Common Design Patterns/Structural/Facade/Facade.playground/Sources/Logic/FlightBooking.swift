//
//  FlightBooking.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public struct FlightBooking: Booking {
    
    // MARK: - Methods
    
    public static func getBookables(from fdate: Date, to tdate: Date) -> [Bookable]? {
        let flights = [Flight]()
        // Here goes the logic for fetching Flights for a given Date range
        return flights
    }
    
    public static func book(_ bookable: Bookable) {
        // Logic for booking a Flight
    }
    
}
