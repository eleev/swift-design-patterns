//
//  BackendNetworkingProxy.swift
//  swift-design-patterns
//
//  Created by Astemir Eleev on 28/06/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public class BackendNetworkingProxy {
    
    public enum DataUpdateStatus {
        case success
        case delayed
        case error
        case uncategorized
    }
    
    // MARK: - Properties
    
    private var url = URL(string: "http://www.ourbackend.com/data-update/")!
    private(set) var networking: Networking
    
    // MARK: - Initializers
    
    public init() {
        networking = Networking()
    }
    
    // MARK: - Methods
    
    public func requestDataUpdate(completion: @escaping (DataUpdateStatus?)->()) {
        
        networking.dataTask(for: url) { response in
            guard let uresponse = response as? HTTPURLResponse else {
                completion(nil)
                return
            }
            
            switch uresponse.statusCode {
            case 200...203: // does not repesent actual status code handling, for demonstration purposes only
                completion(.success)
            case 735: // does not repesent actual status code handling, for demonstration purposes only
                completion(.delayed)
            case 400...600: // does not repesent actual status code handling, for demonstration purposes only
                completion(.error)
            default:
                completion(.uncategorized)
            }
        }
    }
}
