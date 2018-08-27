//
//  TravelFacade.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public struct TravelFacade {
    
    // MARK: - Properties
    
    public private(set) var hotels: [Hotel]?
    public private(set) var flights: [Flight]?
    
    // MARK: - Initializers
    
    public init(from fdate: Date, to tdate: Date) {
        hotels = HotelBooking.getBookables(from: fdate, to: tdate) as? [Hotel]
        flights = FlightBooking.getBookables(from: fdate, to: tdate) as? [Flight]
    }
    
    // MARK: - API methods
    
    public func book(hotel: Hotel, flight: Flight) {
        HotelBooking.book(hotel)
        FlightBooking.book(flight)
    }
    
    public func book(flightPrice: Int, hotelPrice: Int, minHotelStars: StarsType) -> BookingResult {
        
        guard let flight = flights?.filter({ $0.price < flightPrice })[0] else {
            return (.missingFlight, nil, nil)
        }
        guard let hotel = hotels?.filter({ $0.stars.rawValue >= minHotelStars.rawValue && $0.pricePerNight < hotelPrice })[0] else {
            return (.missingHotel, nil, nil)
        }
        
        book(hotel: hotel, flight: flight)
        return (.success, flight, hotel)
    }
    
    public typealias BookingResult = (status: BookingStatus, flight: Flight?, hotel: Hotel?)
    
}

public typealias Price = Int

public enum BookingStatus: String {
    case wrongPrice = "Provided price(s) have wrong format"
    case missingFlight = "Flight with the specified filter could not be found"
    case missingHotel = "Hotel with the specified filter could not be found"
    case success
}

