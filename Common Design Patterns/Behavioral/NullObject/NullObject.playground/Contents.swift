
import UIKit

protocol Product {
    var name: String { get }
    var calories: Int { get }
    var price: NSNumber { get }
}

struct Apple: Product {
    var name: String = "Apple"
    var calories: Int = 50
    var price: NSNumber = 3
    
    init() { }
}

struct Banana: Product {
    var name: String = "Banana"
    var calories: Int = 85
    var price: NSNumber = 5
    
    init() { }
}

struct Juice: Product {
    var name: String = "Orange Juice"
    var calories: Int = 150
    var price: NSNumber = 20
    
    init() { }
}

struct NullObjectProduct: Product {
    var name: String = "Void"
    var calories: Int = 0
    var price: NSNumber = 0
    
    init() { }
}

extension Apple: CustomStringConvertible {
    
    var description: String {
        return "name: \(name), calories: \(calories), price: \(price)"
    }
}

extension Banana: CustomStringConvertible {
    
    var description: String {
        return "name: \(name), calories: \(calories), price: \(price)"
    }
}

extension Juice: CustomStringConvertible {
    
    var description: String {
        return "name: \(name), calories: \(calories), price: \(price)"
    }
}

extension NullObjectProduct: CustomStringConvertible {
    
    var description: String {
        return "name: \(name), calories: \(calories), price: \(price)"
    }
}

class Basket {

    subscript(index: Int) -> Product {
        get {
            guard index > -1, index < products.count else {
                return NullObjectProduct()
            }
            return products[index]
        }
    }
    
    private var products: [Product] = []
    
    func add(product: Product) {
        products += [product]
    }
}

extension Basket: CustomStringConvertible {
    
    var description: String {
        return "products: \(products)"
    }
}



class MarketViewController: UIViewController {
    
    // MARK: - Properties
    
    var basket = Basket()
    
    // MARK: - Initializers
    
    init() {
        /*
        let banana = Product(name: "Banana", calories: 85, price: 5)
        let apple = Product(name: "Apple", calories: 50, price: 3)
        let juice = Product(name: "Orange Juice", calories: 150, price: 20)
        
        basket.add(product: banana)
        basket.add(product: apple)
        basket.add(product: juice)

        print(basket)

        if let thirdProduct = basket[3] {
            print("Third product: ", thirdProduct)
        } else {
            print("nil")
        }
         */
         
        basket.add(product: Banana())
        basket.add(product: Apple())
        basket.add(product: Juice())
        
        print(basket)
        
        let thirdProduct = basket[3]
        print(thirdProduct)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let marketViewController = MarketViewController()
