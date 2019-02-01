# Type Erasure Pattern
`Type Erasure` is a structural design pattern that allows to turn an associated type into a generic constraint. That resolves an issue that does not allow to treat a collection of objects that conform to a protocol with an associated type as a collection of regular protocols. The protocol has various implementation approaches, however they all can be described by a single pattern: an associated type of a protocol is erased by a generic constraint. The rest is implementation details. 

## Problem Definition 
Let's assume that we have a protocol with an associated type:

```swift
protocol ShelfProtocol: class {
    
    associatedtype Contents: Storable

    var contents: [Contents] { get set }
    
    func open()
    func close()
    func isEmpty() -> Bool
}

extension ShelfProtocol {
    func isEmpty() -> Bool {
        return contents.isEmpty
    }
}
```

The protocol describes a shelf with some contents that conform to `Storable` protocol. `Storable` is a marker protocol that has no implementation and is used to pass metadata to the conforming types. 

```swift
protocol Storable { /* marker protocol */ }
```

The good thing about such a marker protocol that it can be extended later on and it better describes what kind of objects out `ShelfProtocol` should store. 

Next, let's implement a couple of structs that will be used as our associated types for more specialized shelves:

```swift
struct Book: Storable {
    var name: String
    var author: String
}

struct CompactDisk: Storable {
    typealias Date = String
    
    var name: String
    var release: Date
}
```

The first struct defines a `Book` type that holds two properties for `name` and `author`. The next struct is quite similar to the `Book` struct and is called `CompactDisk`. It will describe any compact disk in our shelf. 

So far, so good. Now we need to implement concrete shelves:

```swift
class BookShelf: ShelfProtocol {
    typealias Contents = Book

    var contents: [Contents] = []
    
    func open() {
        print("Opened BookShelf")
    }
    
    func close() {
        print("Closed BookShelf")
    }
}

class CompactDiskShelf: ShelfProtocol {
    typealias Contents = CompactDisk
    
    var contents: [Contents] = []
    
    func open() {
        print("Opened CompactDiskShelf")
    }
    
    func close() {
        print("Closed CompactDiskShelf")
    }
}
```

The implementations are almost identical, the only difference is the type of our associated type. For `BookShelf` it's `Book` struct and for `CompactDiskShelf` it's `CompactDisk` struct.

Now, we create a couple of book shelves and a single compact disk shelf:

```swift
// Harry Potter books
let hpBookShelf = BookShelf()
hpBookShelf.contents += [harryPotterPS, harryPotterCS, harryPotterPZ]

// Lord of the Rings books
let lotrBookShelf = BookShelf()
lotrBookShelf.contents += [lotrFOTR, lotrTT, lotrROTK]

// Shelf with Rock and Jazz compact disks
let compactDiskShelf = CompactDiskShelf()
compactDiskShelf.contents += [rock, jazz]
```

We have created two concrete instances for `BookShelf` type. One of them holds `Harry Potter` books and the other one holds `Lord of the Rings` books. Also, we created a compact disk shelf that holds Rock and Jazz compact disks. Let's try to create an array that holds those two book shelves and a shelf with compact disks:

```swift
let bookShelves: [ShelfProtocol] = [hpBookShelf, lotrBookShelf, compactDiskShelf]
```

Compile time error! We cannot create such an array. `Xcode` will give as the following error:

```swift
Protocol 'ShelfProtocol' can only be used as a generic constraint because it has Self or associated type requirements
```

Sure, we can just skip the part where we explicitly define the constraining protocol for our shelves array, but we lose all the typesafity in such a case. As a result we have a heterogeneous array of objects, that needs to explicitly casted to `AnyObject`:

```swift
let shelves = [hpBookShelf, lotrBookShelf, compactDiskShelf] as [AnyObject]
```

That will perfectly work, however we will need to explicitly type-cast in order to get work with an instance:

```swift
if let compactDiskShelf = shelves.first as? CompactDiskShelf {
    print("We just got the compactDiskShelf instance: ", compactDiskShelf)
}
```
You may be wondering why cant we have an array that is constrained by the protocol's type? We can use a regular protocol in store a bunch of conforming types in a type-safe way, but why can't we do that with `PATs` (Protocols with Associated Types).

The thing is that the latter is statically resolved, where the regular protocols are dynamically dispatched. That is the limitation of `PATs` in the current version of `Swift` (which is 5.0). In the next section, we will implement `Type Erasure` pattern in order to resolve some of the issue that we have faced.

## Wrapping Type
In order to create a workaround for the issue, we need to erase the type by implementing the `Type Erasure` pattern. Conceptually it works pretty much the same in most of the OOP-related languages, with differences in implementation details. This pattern is even used in the Swift's standard library. All the types that are marked as `Any` are basically type-erasure containers e.g. `AnyIterator`, `AnyObject`, `AnySequence` etc.

We need to start off from declaring a new type called `AnyShelf`. Add conformance to the target protocol, define a generic parameter and create an initializer that will erase the associated type with the one that is specified as a constraining type:

```swift
final class AnyShelf<T>: ShelfProtocol where T: Storable {
   
    // MARK: - Properties
    
    typealias Contents = T
    
    var contents: [T]
    
    // MARK: - Private properties
    
    private let _open: () -> ()
    private let _close: () -> ()
    private let _isEmpty: () -> Bool
    
    // MARK: - Initializers
    
    init<P: ShelfProtocol>(protocol: P) where P.Contents == T {
        contents = `protocol`.contents
        _open = `protocol`.open
        _close = `protocol`.close
        _isEmpty = `protocol`.isEmpty
    }
    
    // MARK: - Methods
    
    func open() {
        _open()
    }
    
    func close() {
        _close()
    }
    
    func isEmpty() -> Bool {
        return _isEmpty()
    }
}
```
We also need to be able to forward the method calls to the target type. That is why we defined a set of private closures that are initialized in the initializer. We use more complicated approach, where `two` or `three` private super-type are involved. However, it makes thing harder to understand and provides some minor advantages. 

The `AnyShelf` allows us to store a collection of shelves, in the following manner:

```swift
let anyBookShelf: [AnyShelf<Book>] = [AnyShelf(protocol: hpBookShelf), AnyShelf(protocol: lotrBookShelf)]

for (index, shelf) in anyBookShelf.enumerated() {
    print("index: \(index), ", shelf.contents)
    print()
}
```

Great! We are now able to store various book shelves in a single homogenous array. 

However, we don't get the same level of flexibility as if we would use regular protocols without associated types. That means we still cannot mix and match various shelves with different associated types, since we cannot mark our array as `AnyShelf<Storable>` because of the following compile time error:

```swift
error: using 'Storable' as a concrete type conforming to protocol 'Storable' is not supported
```

Basically, the compiler told us that we cannot use protocol and we should use a concrete type. But, if we use a concrete type, even a super-type, we still will not be able to store both `Book` and `CompactDisk` shelves together. 

`Type Erasure` pattern gave us some flexibility, but it's not an absolute weapon that can resolve the described issue.


## Conclusion 
Swift's generics manifesto looks promising, which contains information about generalized existentials that simply remove the need to write such boilerplate code. However, it will take a while before we see more powerful and flexible type system. Right now, we should either design our code to fit the current standards, or we need to use sophisticated workarounds such as `Type Erasure` pattern.