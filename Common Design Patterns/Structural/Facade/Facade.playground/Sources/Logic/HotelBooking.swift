//
//  HotelBooking.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public struct HotelBooking: Booking {
    
    // MARK: - Methods
    
    public static func getBookables(from fdate: Date, to tdate: Date) -> [Bookable]? {
        // The logic related to the date filtering is missing, it is declared here for demostration purposes
        
        var hotels = [Hotel]()

        // Dummy data
        let fiveStarsHotel = Hotel(pricePerNight: 300, stars: .five)
        let fourStarsHotel = Hotel(pricePerNight: 200, stars: .four)
        let fourCheapStarsHotel = Hotel(pricePerNight: 140, stars: .four)
        let threeStarsHotel = Hotel(pricePerNight: 50, stars: .three)
        hotels += [fiveStarsHotel, fourStarsHotel, fourCheapStarsHotel, threeStarsHotel]

        return hotels
    }
    
    public static func book(_ bookable: Bookable) {
        // Here goes the logic for booking a Hotel
    }
    
}
