//
//  File.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import UIKit

public protocol DelegateProtocol: class {
    
    // MARK: - Methods
    
    func methodOne()
    func methodTwo()
    func set(color: UIColor)
}
