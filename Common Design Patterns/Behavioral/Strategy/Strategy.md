# Strategy Design Pattern
`Strategy` is a behavioral design pattern that provides means to swap an algorithm at runtime. The pattern lets an algorithm to vary independently from the invokers that use it. The implementation is quite simple yet powerful when applied correctly. All you need to do is to declare a common `Strategy` protocol and create several implementations, where each one wraps a different algorithm. 

## Sorter
We are going to create a `Sorter` that will be capable of swapping out `Quick` and `Merge` sort algorithms. The first thing that we will do is to declare a common *Strategy* protocol:

```swift
protocol SortingStrategy {
    func sort <T>(items: [T]) -> [T] where T: Comparable
}
```
We called our protocol `SortingStrategy` in order to provide some context. It has a single method called `sort(items:)` that accepts types that conform to *Comparable* protocol, since  sorting algorithms need to compare items (not always but generally).

The next step is that we create two types that conform to `SortingStrategy` protocol:

```swift
struct QuickSortStrategy: SortingStrategy {
    
    func sort<T>(items: [T]) -> [T] where T : Comparable {
        var items = items
        Array.quickSort(array: &items, lowest: 0, highest: items.count - 1)
        return items
    }
}

struct MergeSortStrategy: SortingStrategy {
    
    func sort<T>(items: [T]) -> [T] where T : Comparable {
        return Array.mergeSort(items, order: <)
    }
}
```

The first type provides strategy for `Quick` sort sorting, and the second one for `Merge` sort. Internally they use *Array Extensions* that perform actual sorting. You may take a look at the concrete implementations in my other repository called [`Swift Algorithms and Data Structures`](https://github.com/jVirus/swift-algorithms-data-structs).

The final part is the `Invoker` part. It's represented as a separate type that holds a property for *Sorting Strategy* and a wrapper method that calls the `sort(items:)` method:

```swift
struct Sorter {

    // MARK: - Properties
    
    var strategy: SortingStrategy
    
    // MARK: - Initializers
    
    init(strategy: SortingStrategy) {
        self.strategy = strategy
    }
    
    // MARK: - Methods
    
    func sort<T: Comparable>(items: [T]) -> [T] {
        return strategy.sort(items: items)
    }
}


let quickSortStrategy = QuickSortStrategy()
let mergeSortStrategy = MergeSortStrategy()

let items = [1,2,7,4,8,2,4,6,1,8,6]

var sorter = Sorter(strategy: quickSortStrategy)
let quickSortedItems = sorter.sort(items: items)

// Output: 
// quickSortedItems :  [1, 1, 2, 2, 4, 4, 6, 6, 7, 8, 8]

sorter.strategy = mergeSortStrategy
let mergeSortedItems = sorter.sort(items: items)

// Output: 
// mergeSortedItems :  [1, 1, 2, 2, 4, 4, 6, 6, 7, 8, 8]

```
The `Sorter` struct serves as an intermediate type between the `Invoker` and the concrete `Strategy`. It provides a unified interface for communicating with various types of *Strategies* without the need to manually manage them, refactor (when *Strategy* related code changes) and deal with its internals. 

We also created `QuickSortStrategy` and `MergeSortStrategy` and set *quickSortStrategy* as a default sorting strategy for our *Sorter*. Then we called `sort(items:)` method and got the sorted collection. The next step was to swap out the sorting strategy to *Merge* sort and call the `sort(items:)` again. The results of calling the method are identical but internally different algorithms performed the actual sorting. 

You can use `Strategy` pattern for any kind of algorithm or data processing: filtering data, searching text, compressing video files, rendering image filters and the list goes on. 

## Conclusion
