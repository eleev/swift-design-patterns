import Foundation
import UIKit

// Type Erasure is a structural pattern that allows to turn an associated type into a generic constraint. That resolves an issue that does not allow to treat a collection of objects that conform to a protocol with an associated type as a collection of regular protocols.

// Let's assume that we have aprotocol with an associated type

protocol ShelfProtocol: AnyObject {
    
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

protocol Storable { /* marker protocol */ }

struct Book: Storable {
    var name: String
    var author: String
}

struct CompactDisk: Storable {
    typealias Date = String
    
    var name: String
    var release: Date
}

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


// Now we want to have an array of all the concrete types that conform to ShelfProtocol protocol. Let's try to do that:

let harryPotterAuthor = "J.K. Rowling"
let harryPotterPS = Book(name: "Harry Potter and The Philosopher's Stone",  author: harryPotterAuthor)
let harryPotterCS = Book(name: "Harry Potter and The Chamber of Secrets",   author: harryPotterAuthor)
let harryPotterPZ = Book(name: "Harry Potter and The Prisoner of Azkaban",  author: harryPotterAuthor)

let hpBookShelf = BookShelf()
hpBookShelf.contents += [harryPotterPS, harryPotterCS, harryPotterPZ]

let lotrAuthor = "J. R. R. Tolkien"
let lotrFOTR = Book(name: "The Lord of the Rings: The Fellowship of the Ring",  author: lotrAuthor)
let lotrTT = Book(name: "The Lord of the Rings: The Two Towers",                author: lotrAuthor)
let lotrROTK = Book(name: "The Lord of the Rings: The Return of the King",      author:  lotrAuthor)


let lotrBookShelf = BookShelf()
lotrBookShelf.contents += [lotrFOTR, lotrTT, lotrROTK]


let rock = CompactDisk(name: "The best classic Rock", release: "1960 - 2015")
let jazz = CompactDisk(name: "My favorite Jazz", release: "1930 - 1962")

let compactDiskShelf = CompactDiskShelf()
compactDiskShelf.contents += [rock, jazz]


// Here we get the following warning:
// Protocol 'ShelfProtocol' can only be used as a generic constraint because it has Self or associated type requirements
// let bookShelves: [ShelfProtocol] = [hpBookShelf, lotrBookShelf, compactDiskShelf]

// Sure we can just skip the part where we explicitly define the constraining protocol for our coordinators array, but we lose all the typesafety in such a case. As a result we have a heterogeneous array of objects, that needs to explicitly casted to `AnyObject`:

let shelves = [hpBookShelf, lotrBookShelf, compactDiskShelf] as [AnyObject]

// That will perfectly work, however we will need to explicitly type-cast in order to get work with an instnace:

if let compactDiskShelf = shelves.first as? CompactDiskShelf {
    print("We just got the compactDiskShelf instance: ", compactDiskShelf)
}

// You may be wondering why cant we do that? We can use a regular protocol in store a bunch of conforming types in a type-safe way, but why can't we do that with PATs (Protocols with Associated Types).

// The thing is that the latter is statically resolved, where the regular protocols are dynamically dispatched. That is the limitaion of PATs.

// In order to create a workaround for this issue, we need to erase the type by implementing the Type Erasure pattern. Conceptually it works pretty much the same in most of the OOP-related languages, with differentes in implementation details. This pattern is even used in the Swift's standard library. All the types that are marked as `Any` are basically type-erasure containers e.g. `AnyIterator`, `AnyObject`, `AnySequence` etc.

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


// What we have done here, is basically we defined a class called `AnyShelf`

let anyBookShelf: [AnyShelf<Book>] = [AnyShelf(protocol: hpBookShelf), AnyShelf(protocol: lotrBookShelf)]

for (index, shelf) in anyBookShelf.enumerated() {
    print("index: \(index), ", shelf.contents)
    print()
}

// However we don't get the same level of flexibility as if we would use regular protocols without associated types. That means we still cannot mix and match various shelves with different associted types, since we cannot mark our array as `AnyShelf<Storable>` because of the following compile time error:
// error: using 'Storable' as a concrete type conforming to protocol 'Storable' is not supported
// let anyShelf: [AnyShelf<Storable>] = [AnyShelf(protocol: hpBookShelf), AnyShelf(protocol: lotrBookShelf), AnyShelf(protocol: compactDiskShelf)]

// Swift's generics manifesto looks promising, which contains information about generalized existentials that simply remove the need to write such boilerplate code. Will see how Swift will be evolving. Personally I belive in this language and I the evolution of Swift will open new horizons for us.
