//
//  TravelFacade.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

struct TravelFacade {
    
    // MARK: - Properties
    
    var hotels: [Hotel]?
    var flights: [Flight]?
    var cars: [RentalCar]?
    
    // MARK: - Initializers
    
    init(from fdate: Date, to tdate: Date) {
        hotels = HotelBooking.getBookables(from: fdate, to: tdate) as? [Hotel]
        flights = FlightBooking.getBookables(from: fdate, to: tdate) as? [Flight]
        cars = RentalCarBooking.getBookables(from: fdate, to: tdate) as? [RentalCar]
    }
    
    // MARK: - API methods
    
    func book(hotel: Hotel, flight: Flight, rentalCar: RentalCar) {
        HotelBooking.book(hotel)
        FlightBooking.book(flight)
        RentalCarBooking.book(rentalCar)
    }
    
}
