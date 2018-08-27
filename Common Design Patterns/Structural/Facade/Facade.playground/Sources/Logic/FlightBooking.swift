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
        // The logic related to the date filtering is missing, it is declared here for demostration purposes
        
        var flights = [Flight]()
        
        // Dummy data
        let JFK = Airport(name: "John F. Kennedy International Airport")
        let VKO = Airport(name: "Vnukovo International Airport")
        let SFO = Airport(name: "San Francisco International Airport")
        let OSL = Airport(name: "Gardermoen Airport / Oslo Airport")
        
        let JFKVKO = Flight(departure: JFK, destination: VKO, duration: 10.20, price: 650)
        let JFKSFO = Flight(departure: JFK, destination: SFO, duration: 7.10, price: 350)
        let VKOOSL = Flight(departure: VKO, destination: OSL, duration: 2.40, price: 220)
        flights += [JFKVKO, JFKSFO, VKOOSL]

        return flights
    }
    
    public static func book(_ bookable: Bookable) {
        // Logic for booking a Flight
    }
    
}
