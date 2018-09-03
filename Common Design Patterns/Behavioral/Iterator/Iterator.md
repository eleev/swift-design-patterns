# Iterator Design Pattern
`Iterator` is a behavioural design pattern that provides a standardized interface for a collection of traversing elements. The collection of elements is represented as an *aggregate* object. The pattern decomposes iteration logic into separate *iterator* object. 

We can implement this pattern in a couple of different ways: by creating the *iterator* and *iteratable* protocols from scratch or we can use similar protocols that already are offered by the Swift standard library. The differences between the approaches will be minimal, except you need some very sophisticated features. 

## Prerequisites
We start off from a simple, custom model type. It will represent a single book:

```swift
struct Book {
    var author: String
    var name: String
}
```
The struct is oversimplified for demonstration purposes. It holds two `String` properties for *author* and *name* of a book.

The next step is that we create a book storage simply called `Books`:

```swift
struct Books {
    var category: String
    var books: [Book]
}
```
The book storage is described by two properties: *category* represented by `String` type and `array` of *books*. Swift provides a default designated initializers for both of the struct types.

We can iterate through the books by accessing the `books` property of the `Books` type. However if we mark `books` property as *private*, the access will be restricted and we will not be able to iterate through the `books` array. This is the example where we need to adopt `Iterator` pattern to have such a possibility.

## Iterator Protocol
Swift already has a protocol called `IteratorProtocol` that is responsible for supplying the values of a sequence one at a time. In order to create a custom iterator that fits our needs, we need to create a type that conforms to the `IteratorProtocol`:

```swift
struct BooksIterator: IteratorProtocol {

    // MARK: - Properties
    
    private var current = 0
    private let books: [Book]

    // MARK: - Initializers
    
    init(books: [Book]) {
        self.books = books
    }

    // MARK: - Methods
    
    mutating func next() -> Book? {
        defer { current += 1 }
        return books.count > current ? books[current] : nil
    }
}
```
The presented `BooksIterator` struct adds an ability to iterate through `books` array by implementing a single required method of the `IteratorProtocol` called `next`. Inside this method we describe which element will be returned next by implementing  our custom logic. 

However we cannot use our `Books` type in a `for-each` loop yet, we need to conform to another protocol called `Sequence`. 

## Sequence Protocol
`IteratorProtocol` and `Sequence` protocols are tightly connected. `Sequence` protocol is responsible for providing access to its elements in a sequential, iterated manner. Basically `Sequence` protocol returns an iterator that is then used to traverse elements of a sequence.

```swift
extension Books: Sequence {
    
	func makeIterator() -> BooksIterator {
		return BooksIterator(books: books)
	} 
}
```

In order to conform to the `Sequence` protocol we need to implement a single method called `makeIterator` and return type that conforms to the `IteratorPrtocol`. In our case we simply created an extension for `Books` type and returned the `BooksIterator` type that describes the way books can be iterated. 

```swift
let gameOfOwls = Book(author: "King", name: "Game of Owls")
let candyFactory = Book(author: "Martin", name: "Candy Factory and Crazy Cat")

let books = Books(category: “Favorite Books", books: [gameOfOwls, candyFactory])

books.forEach { book in
    print(book)
}
```
In order to check if everything works as planned, we have created a couple of books and a collection of books with a category `Favorite Books`. Then we used a standard `forEach` loop to traverse the books and print them out to the console, which gives us the following output:

```swift
Book(author: "King", name: "Game of Owls")
Book(author: "Martin", name: "Candy Factory and Crazy Cat")
```
However, we can use even more simplified approach for this particular case, where we don't need to create (sort of) a separate type that conforms to `IteratorProtocol`. 

## Simplified Iterator
Since we use an array to store our books, we can simply add a conformance to `Sequence` type and wrap our iteration logic into `AnyIterator` type:

```swift
extension Books: Sequence {

    func makeIterator() -> AnyIterator<Book> {
        var iterator = books.makeIterator()

        return AnyIterator {
            while let next = iterator.next() {
                return next
            }
            return nil
        }
    }
}
```
When we use a standard collection, we don't always need to create a custom type for `IteratorProtocol`. The thing is that array type already conforms to `MutableCollection` protocol. `MutableCollection` is a derivative of `Collection` and `Collection` is a derivative of `Sequence` protocol. 

That means we already have conformance to `Sequence` protocol for our array, and we can make a method call for `makeIterator` method and get the "default" iterator which can then be used to get the next element in a sequence. Then we simply wrapped the iteration logic into `AnyIterator` of type `Book` and returned it. `AnyIterator` is simply a type-erased iterator for current sequence. 

Please note that it may not always be the case: we may have a [Linked List](https://github.com/jVirus/swift-algorithms-data-structs/blob/master/Data%20Structures.playground/Pages/Linked%20List.xcplaygroundpage/Contents.swift), or we may want to add iteration logic to our [Binary Search Tree](https://github.com/jVirus/swift-algorithms-data-structs/blob/master/Data%20Structures.playground/Pages/BinarySearchTree.xcplaygroundpage/Contents.swift) data structures.

## Conclusion
When you have a type that needs to be accessed and processed in a loop, use `Iterator` pattern. It hides the type's underlying representation and creates logic for accessing and traversing elements. The implementation in Swift is pretty straightforward, all you need to understand is how to use a couple of building blocks such as `IteratorProtocol` and `Sequence` protocols. For more advanced usages take a look at `Collection` protocol, that adds index subscripting capability and futher extends iteration capabilites.
