//
//  MulticastDelegation.swift
//  swift-design-patterns
//
//  Created by Astemir Eleev on 30/08/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public class MulticastDelegate<T: AnyObject>: NSObject {
    
    // MARK: - Subscripts
    
    /// Convenience subscript for accessing delegate by index, returns nil if there is no object found
    public subscript(index: Int) -> T? {
        get {
            guard index < 0, index > delegates.count - 1 else {
                return nil
            }
            return delegates[index].value
        }
    }
    
    /// Searches for the delegate and returns its index
    public subscript(delegate: T) -> Int? {
        get {
            guard let index = delegates.index(where: { $0.value === delegate }) else {
                return nil
            }
            return index
        }
    }
    
    // MARK: - Properties
    
    private var delegates: [Weak<T>] = []
    
    // MARK: - Initializers
    
    public override init() {
        super.init()
    }
    
    // MARK: - Methods
    
    public func add(delegate: T) {
        delegates += [Weak(delegate)]
    }
    
    public func remove(delegate: T) {
        guard let index = self[delegate] else {
            return
        }
        delegates.remove(at: index)
    }
    
    public func invoke(_ completion: @escaping(T) -> ()) {
        // Recycle the values that are nil so the completion closure is called for non nil values
        recycle()
        
        delegates.forEach { delegate in
            // Additional anti-nil check
            if let udelegate = delegate.value {
                completion(udelegate)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func recycle() {
        for (index, element) in delegates.enumerated().reversed() where element.value == nil {
            delegates.remove(at: index)
        }
    }
}

// MARK: - Extension that adds custom operators for the MulticastDelegate class
extension MulticastDelegate {
    static func +=(lhs: inout MulticastDelegate, rhs: T) {
        lhs.add(delegate: rhs)
    }
    
    static func -=(lhs: inout MulticastDelegate, rhs: T) {
        lhs.remove(delegate: rhs)
    }
    
    static func ~>(lhs: inout MulticastDelegate, rhs: @escaping (T) -> ()) {
        lhs.invoke(rhs)
    }
}

public final class Weak<Value: AnyObject> {
    
    // MARK: - Properties
    
    weak var value: Value?
    
    // MARK: - Initializers
    
    init(_ value: Value) {
        self.value = value
    }
}

extension Weak: Equatable {
    
    public static func ==(lhs: Weak, rhs: Weak) -> Bool {
        // Sintatic sugar for the reference comparison operator
        return lhs.value === rhs.value
    }
}
