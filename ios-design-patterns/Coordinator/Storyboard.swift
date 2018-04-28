//
//  Storyboard.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 28/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

protocol Storyboard {
    static func instantiate() -> Self
}

extension Storyboard where Self: UIViewController {
    
    static func instantiate() -> Self {
        let name = NSStringFromClass(self)
        debugPrint("name: " , name)
        let className = name.components(separatedBy: ".")[1]
        debugPrint("class name: " , className)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
