# Null Object Design Pattern

`Null Object` is a behavioral design pattern that is aimed to solve a problem, when `null` or `nil` values need to be handled with optional binding using `if let` or `guard` statements.  

Optionals in Swift represent either one of the two: value or its absence. However in cases when we need something else but not nil, we have to manually check and handle values whether they are optionals or not. In order to solve nil values we can throw an error, manually unwrap objects or use *Null Object*. 

`Null Object` pattern offers a solution for such cases by eliminating optionals and providing special versions of the same objects.

## Context
We are going to take a look at an example that does not use *Null Object* pattern and then make an improvement by adding one.

Let's implement the model for our example:

```swift
struct Product {
    var name: String
    var calories: Int
    var price: NSNumber
}
```
`Product` is a simple *struct* with three properties abstractly describing products that can be bought in a market. 

```swift
class Basket {

    subscript(index: Int) -> Product? {
        get {
            guard index > -1, index < products.count else {
                return nil
            }
            return products[index]
        }
    }
    
    private var products: [Product] = []
    
    func add(product: Product) {
        products += [product]
    }
}
```
`Basket` is a *class* that holds an array of `Product` instances, has a single method called `add(product:)` and a custom *subscript* for accessing contents of itself.

```swift
class MarketViewController: UIViewController {
    
    // MARK: - Properties
    
    var basket = Basket()
    
    // MARK: - Initializers
    
    init() {
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
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```
We have created `MarkerViewController` class that is responsible for holding a data source for `Basket` type, fill it in and display the data. The code related to displaying the data model is not important here, that is why it was not implemented.

Everything works fine, we added some fruits and juice to the basket, until we try access an element. Since we can access any element of our basket, we may get index out of bounds error. However we fixed that by implementing custom *subscript* that, instead returns *nil*. Now we need to check whether a product at a particular index is *nil* or not. Not a big deal, you may think - we can use optional unwrapping. But the thing is that we can remove that code and make it *behave* like there is no optional products.


## Implementation
There are two approaches that we can use to implement `Null Object` pattern: the first one is by using `protocols`, or by using an inheritance. Since Swift is a *Protocol Oriented Language* we use *protocols* in this example. However we will be able to implement the version that uses *inheritance* without any issues, once you conceptually understand this pattern.

We start off by changing our implementation by making the `Product` to be a *protocol* rather than a *struct*:

```swift
protocol Product {
    var name: String { get }
    var calories: Int { get }
    var price: NSNumber { get }
}
```

Then we create the concrete conformances for this protocol for `Apple`, `Banana` and `Juice` types:

```swift
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
```
The key here is that we have a common *protocol* that can be used to introduce a `Null Object` type:

```swift
struct NullObjectProduct: Product {
    var name: String = "Void"
    var calories: Int = 0
    var price: NSNumber = 0
    
    init() { }
}
```
We will use this *struct* instead of optional product. Note that `Basket` class is not touched, it remained the same. All we need to do is to change the data source setup code, in our view controller:

```swift
class MarketViewController: UIViewController {
    
    // MARK: - Properties
    
    var basket = Basket()
    
    // MARK: - Initializers
    
    init() {
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
```
We no longer need to use optional unwrapping to test against nil values. Instead if we access basket outside of the accessible range we get a `Null Object` that can be successfully used in further data related operations. That made our code more cleaner, easy to read and potentially save us from implementing optional-related handling code.

## Issues
The pattern is not a replacement for Swift's optionals or error handling system, and should not be used in every case where optionals need to be handled. The pattern may become a cause of issues, since each of the cases that pattern handles, needs to be separately implemented and maintained.

## Conclusion 