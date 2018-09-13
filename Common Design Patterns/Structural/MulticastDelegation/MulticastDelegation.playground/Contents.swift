//
//  MulticastDelegation.swift
//  swift-design-patterns
//
//  Created by Astemir Eleev on 30/08/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import Foundation

public class MulticastDelegate<T> {
    
    // MARK: - Subscripts
    
    /// Convenience subscript for accessing delegate by index, returns nil if there is no object found
    public subscript(index: Int) -> T? {
        get {
            guard index > -1, index < delegates.count else {
                return nil
            }
            return delegates[index].value as? T
        }
    }
    
    /// Searches for the delegate and returns its index
    public subscript(delegate: T) -> Int? {
        get {
            guard let index = delegates.index(where: { $0.value  === delegate as AnyObject }) else {
                return nil
            }
            return index
        }
    }
    
    // MARK: - Properties
    
    private var delegates = [Weak]()
    
    // MARK: - Methods
    
    public func add(delegate: T) {
        delegates.append(Weak(delegate as AnyObject))
    }
    
    public func remove(delegate: T) {
        guard let index = self[delegate] else {
            return
        }
        delegates.remove(at: index)
    }
    
    func dispose(delegate: T) {
        if let index = self[delegate] {
            delegates[index].value = nil
        }
    }
    
    public func update(_ completion: @escaping(T) -> ()) {
        // Recycle the values that are nil so the completion closure is called for non nil values
        recycle()
        
        delegates.forEach { delegate in
            // Additional anti-nil check
            if let udelegate = delegate.value as? T {
                completion(udelegate)
            }
        }
    }
    
    // MARK: - Private
    
    private func recycle() {
        for (index, element) in delegates.enumerated().reversed() where element.value == nil {
            delegates.remove(at: index)
        }
    }
    
    private final class Weak {
        
        // MARK: - Properties
        
        weak var value: AnyObject?
        
        // MARK: - Initializers
        
        init(_ value: AnyObject) {
            self.value = value
        }
    }
}

// MARK: - Extension that adds custom operators for the MulticastDelegate class. The motivation behind this extension is to provide Swity-like API interface e.g.
//
// Adding new delegate:
// model.delegates += viewControllerDelegate
//
// Removes the specified delegate:
// model.delegate -= viewControllerDelegate
//
// Adds an update closure outside of the delegate caller side and notify all the delegates:
// model.delegate ~> { delegate in
//      delegate.saveModel()
// }
extension MulticastDelegate {
    static func +=(lhs: MulticastDelegate, rhs: T) {
        lhs.add(delegate: rhs)
    }
    
    static func +=(lhs: MulticastDelegate, rhs: [T]) {
        rhs.forEach { lhs.add(delegate: $0) }
    }
    
    static func -=(lhs: MulticastDelegate, rhs: T) {
        lhs.remove(delegate: rhs)
    }
    
    static func -=(lhs: MulticastDelegate, rhs: [T]) {
        rhs.forEach { lhs.remove(delegate: $0) }
    }
    
    static func ~>(lhs: MulticastDelegate, rhs: @escaping (T) -> ()) {
        lhs.update(rhs)
    }
    
    static func ~>(lhs: MulticastDelegate, rhs: [(T) -> ()]) {
        rhs.forEach { lhs.update($0) }
    }
}

extension MulticastDelegate: Sequence {
    
    public func makeIterator() -> AnyIterator<T>{
        var iterator = delegates.makeIterator()

        return AnyIterator {
            while let next = iterator.next() {
                if let value = next.value as? T {
                    return value
                }
            }
            return nil
        }
    }
}


//: Implementation of the Model and ViewController layers

import UIKit


protocol ModelDelegate: class {
    func didUpdate(name: String)
    func didUpdate(city: String)
    func didSave()
}


class ContainerViewController: UIViewController, ModelDelegate {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Conformance to ModelDelegate protocol
    
    func didUpdate(name: String) {
        print("ContainerViewControllers: ", #function, " value: ", name)
    }
    
    func didUpdate(city: String) {
        print("ContainerViewControllers: ", #function, " value: ", city)
    }
    
    func didSave() {
        print("ContainerViewControllers: ", #function)

    }
}

class ProfileViewController: UIViewController, ModelDelegate {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Conformance to ModelDelegate protocol
    
    func didUpdate(name: String) {
        print("ProfileViewController: ", #function, " value: ", name)
    }
    
    func didUpdate(city: String) {
        print("ProfileViewController: ", #function, " value: ", city)
    }
    
    func didSave() {
        print("ProfileViewController: ", #function)
    }
}


class ProfileModel {

    // MARK: - Properties
    
    var delegates = MulticastDelegate<ModelDelegate>()
    
    var name: String = UUID.init().uuidString {
        didSet {
            delegates.update { [unowned self] modelDelegate in
                modelDelegate.didUpdate(name: self.name)
            }
        }
    }
    
    var city: String = UUID.init().uuidString {
        didSet {
            delegates.update { [unowned self] modelDelegate in
                modelDelegate.didUpdate(city: self.city)
            }
        }
    }
    
    // MARK: - Methods
    
    func completedUpdate() {
        delegates.update { modelDelegate in
            modelDelegate.didSave()
        }
    }
    
}

//: Usage

print("Hello Multicast Delegate!")


let containerViewController = ContainerViewController()
var profileViewController: ProfileViewController? = ProfileViewController()

let profileModel = ProfileModel()
// Attach the delegates
profileModel.delegates += containerViewController
profileModel.delegates += profileViewController!

profileModel.name = "John"

profileModel.delegates -= profileViewController!

profileModel.city = "New York"

// We again attach ProfileViewController
profileModel.delegates += profileViewController!

// Custom closure that is called outside of the model layer, for cases when something custom is required without the need to touch the original code-base. For instance we may implement this function in our view-model layer when using MVVM architecture
profileModel.delegates ~> { modelDelegate in
    modelDelegate.didSave()
}

let delegateZero = profileModel.delegates[0]
// ContainerViewController will be returned since it was added first

let profleIndexViewControllerIndex = profileModel.delegates[profileViewController!]
// ProfileViewController was added as a second delegate and its indes will be equal to 1

profileViewController = nil
print("Profile View Controller is : ", profileViewController as Any)

// Since we conformed to the Sequence protocol we can easily iterate throught the delegates as it is a collection
for delegate in profileModel.delegates {
    print("Delegate: " , delegate)
}
