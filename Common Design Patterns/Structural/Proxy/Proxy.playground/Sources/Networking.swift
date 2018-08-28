//
//  Networking.swift
//  swift-design-patterns
//
//  Created by Astemir Eleev on 28/06/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public class Networking {
    
    public init() {
        
    }
    
    public func dataTask(for url: URL, completion: @escaping (URLResponse?) -> ()) {
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            completion(response)
        }
        session.resume()
    }
    
}
