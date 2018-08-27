//
//  Hotel.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public struct Hotel: Bookable {
    // The struct contains the info related to a Hotel
    
    public var pricePerNight: Price
    public var stars: StarsType
}

extension Hotel: CustomStringConvertible {
    
    public var description: String {
        return """
        price per night: \(pricePerNight),
        stars: \(stars)
        """
    }
}

public enum StarsType: Int {
    case one = 1, two, three, four, five
}
