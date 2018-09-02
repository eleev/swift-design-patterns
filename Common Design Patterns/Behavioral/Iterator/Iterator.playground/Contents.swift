import Foundation

struct Book {
    var author: String
    var name: String
}

struct Books {
    var books: [Book]
}

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
    
//    func makeIterator() -> BooksIterator {
//        return BooksIterator(books: books)
//    }
    
}

let books = Books(books: [Book(author: "King", name: "Game of Owls"), Book(author: "Martin", name: "Candy Factory and Crazy Cat")])

books.forEach { book in
    print(book)
}
