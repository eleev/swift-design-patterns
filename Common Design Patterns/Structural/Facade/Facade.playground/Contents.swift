//
//  Facade.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 27/08/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//


import Foundation

public extension String {
    
    /// Creates a Date instance from Self String based in the specified format
    ///
    /// - Parameter format: is a String format that is used in parsing
    /// - Returns: a Date instance
    public func date(inFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: self)
    }
}


//: Usage
// Travel Facade usage 

let dateFormat = "yyyy-MM-DD"
guard let fromDate = "2018-10-01".date(inFormat: dateFormat), let toDate = "2018-10-15".date(inFormat: dateFormat) else {
    fatalError("Could not format date for format: \(dateFormat)")
}

let travel = TravelFacade(from: fromDate, to: toDate)

// Use case #1

// get the first flight that is less than $500 & get the first hotel that has 4 or 5 stars rating and price per night less than $150
if let flight = travel.flights?.filter({ $0.price < 500 })[0], let hotel = travel.hotels?.filter({ $0.stars.rawValue > 3 && $0.pricePerNight < 150 })[0] {

    travel.book(hotel: hotel, flight: flight)
}

// Use case #2

let bookingResult = travel.book(flightPrice: 500, hotelPrice: 150, minHotelStars: .four)
print("**Booking result**: ", bookingResult.status)
print("**Booked Flight**: ", bookingResult.flight ?? (Any).self)
print("**Bookied Hotel**: ", bookingResult.hotel ?? (Any).self)

