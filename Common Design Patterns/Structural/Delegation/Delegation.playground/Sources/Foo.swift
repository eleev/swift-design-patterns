//
//  Delegate.swift
//  ios-design-patterns
//
//  Created by Astemir Eleev on 22/04/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation
import UIKit

public class Foo {

    // MARK: - Delegate property
    
    weak var delegate: DelegateProtocol?
    
    // MARK: - Initializers
    
    public init(delegate: DelegateProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    
    public func someFunc() {
        guard let delegate = delegate else {
            debugPrint(#function + " delegate protocol has not been set, the method will be aborted")
            return
        }
        delegate.methodOne()
    }
    
    public func someOtherFunc() {
        guard let delegate = delegate else {
            debugPrint(#function + " delegate protocol has not been set, the method will be aborted")
            return
        }
        delegate.methodTwo()
    }
    
    public func getColor() {
        // This method gets UIColor instance from a user, remove-server, color picker or anywhere else and passes it to the delegate type that need that color in order to perform its tasks
        guard let delegate = delegate else {
            debugPrint(#function + " delegate protocol has not been set, the method will be aborted")
            return
        }
        delegate.set(color: .orange)
    }
}
