//
//  FlowCoordinator.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 28/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import UIKit

class FlowCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    // MARK: - Initialiers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    
    func start() {
        let viewController = ViewController.instantiate()
        navigationController.pushViewController(viewController, animated: true)
    }
}
