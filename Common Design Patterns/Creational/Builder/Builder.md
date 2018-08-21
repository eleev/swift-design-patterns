# Builder Design Pattern

Builder is a cretional design pattern which purpose is aimed to simplify creation of objects. There are cases when object needs to accept too many parameters. For instance let's take a look at hte following example:

```
struct Burger {

    // MARK: - Properties 

    var name: String
    var patties: Int
    var bacon: Bool 
    var cheese: Bool
    var pickles: Bool
    var mustard: Bool
    var tomato: Bool

    // MARK: - Initializers
    
    init(name: String, patties: Int, bacon: Bool, cheese: Bool, pickles: Bool, mustard: Bool, tomato: Bool) {
        self.name = builder.name
        self.patties = builder.patties
        self.bacon = builder.bacon
        self.cheese = builder.cheese
        self.pickles = builder.pickles
        self.mustard = builder.mustard
        self.tomato = builder.tomato
    }
}
```

We defined a simple  `struct` called Burger. The struct defines a set of properties that define a particular burger. However there are too many properties to be defined each time when we need to create new burger: 

```
let cheeseBurger = Burger(name: "Cheese Burger", patties: 1, bacon: false, cheese: true, pickles: true, mustard: true, tomato: false)

let hamburgerBurger = Burger(name: "Hamburger", patties: 1, bacon: false, cheese: false, pickles: true, mustard: true, tomato: false)
```

The problem here is that it is very easy to make a mistake when passing all those parameters and aestetically the code not that good. If you extrapolate the example, and imagine that you have pretty big code-base, you will realise that so many parameters create boilerplate code that is really hard to look at. 

We can resolve this issue by decoupling the parameters into separate code-blocks. Then reuse those blocks in order to be able to build objects of value or reference types. We are going to start from declaring a common protocol which defines public data that needs to be set up at initialization time of object. 

```
protocol BurgerBuilder {

    var name: String { get }
    var patties: Int { get }
    var bacon: Bool { get }
    var cheese: Bool { get }
    var pickles: Bool { get }
    var mustard: Bool { get }
    var tomato: Bool { get }
}
```

Then we create structures that conform to the BurgerProtocol and we initialize each of the properties in the specialized structures: 

```
struct CheeseBurgerBuilder: BurgerBuilder {

    // MARK: - Properties

    var name: String = "CheeseBurger"
    var patties: Int = 1
    var bacon: Bool = false
    var cheese: Bool = true
    var pickles: Bool = true
    var mustard: Bool = true
    var tomato: Bool = false
}

struct HamburgerBuilder: BurgerBuilder {

    // MARK: - Properties

    var name: String = "Hamburger"
    var patties: Int = 1
    var bacon: Bool = false
    var cheese: Bool = false
    var pickles: Bool = true
    var mustard: Bool = true
    var tomato: Bool = false
}

```

As a result we no longer need to pass all those parameters into `Burger struct` :

```
struct Burger: BurgerBuilder {

    // MARK: - Properties

    var name: String
    var patties: Int
    var bacon: Bool
    var cheese: Bool
    var pickles: Bool
    var mustard: Bool
    var tomato: Bool


    // MARK: - Initializers

    init(builder: BurgerBuilder) {
        self.name = builder.name
        self.patties = builder.patties
        self.bacon = builder.bacon
        self.cheese = builder.cheese
        self.pickles = builder.pickles
        self.mustard = builder.mustard
        self.tomato = builder.tomato
    }
}
```

The only thing that was changed is the parameter list for the initializer. Instead of passing each property of the `Burger` we pass a type tha conforms to BurgerBuilder protocol. 

```
let cheeseBurger = Burger(builder: CheeseBurgerBuilder())

let hamburgerBurger = Burger(builder: HamburgerBuilder())
```

We eliminated the boilerplateness of the code, made it easy to look at and the changes that we miss something are grethly reduced. `Builder` pattern is a simple and effective solution that allows to more elegantly create objects of value or reference types. Also you can use it in cases when a method takes too many parameters. However, in that case you may probably need to use some other design solution, since `Builder` is aimed to create objects. 

