//
//  Coordinator.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 28/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    // MARK: - Methods
    
    func start()
}

