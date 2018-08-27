//
//  Flight.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public struct Flight: Bookable {
    
    // Information about current flight
    
    public var departure: Airport
    public var destination: Airport
    public var duration: TimeInterval
    public var price: Price
}

extension Flight: CustomStringConvertible {
    public var description: String {
        return """
        departure: \(departure),
        destination: \(destination),
        duration: \(duration)h,
        price: \(price)
        """
    }
}


public struct Airport {
    public var name: String
}
