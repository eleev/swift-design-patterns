
import UIKit

struct Product {
    var name: String
    var calories: Int
    var price: NSNumber
}

extension Product: CustomStringConvertible {
    
    var description: String {
        return "name: \(name), calories: \(calories), price: \(price)"
    }
}

class Basket {
    
    private var products: [Product]
    
    subscript(index: Int) -> Product? {
        get {
            guard index > -1, index < products.count else {
                return nil
            }
            return products[index]
        }
    }
    
    init() {
        products = []
    }
    
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
    
    init() {
        let banana = Product(name: "Banana", calories: 85, price: 5)
        let apple = Product(name: "Apple", calories: 50, price: 3)
        let juice = Product(name: "Orange Juice", calories: 150, price: 20)
        
        basket.add(product: banana)
        basket.add(product: apple)
        basket.add(product: juice)
        
        print(basket)
        
        if let thirdProduct = basket[2] {
            print("Third product: ", thirdProduct)
        } else {
            print("nil")
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare the view based on the data source
    }
}

let marketViewController = MarketViewController()
