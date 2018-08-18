//
//  Delegate.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

class Delegate {

    // MARK: - Delegate property
    
    weak var delegate: DelegateProtocol?
    
    init(delegate: DelegateProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    
    func someFunc() {
        guard let delegate = delegate else {
            debugPrint(#function + " delegate protocol has not been set, the method will be aborted")
            return
        }
        delegate.methodOne()
    }
    
    func someOtherFunc() {
        guard let delegate = delegate else {
            debugPrint(#function + " delegate protocol has not been set, the method will be aborted")
            return
        }
        delegate.methodTwo()
    }
}
