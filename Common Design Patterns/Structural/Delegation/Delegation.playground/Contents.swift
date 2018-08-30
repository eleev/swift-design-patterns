//
//  Delegation.swift
//  swift-design-patterns
//
//  Created by Astemir Eleev on 22/08/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

let delegate = Delegate()

let foo = Foo(delegate: delegate)
foo.getColor()
foo.someFunc()
foo.someOtherFunc()

