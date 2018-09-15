import Foundation

protocol SortingStrategy {
    func sort <T>(items: [T]) -> [T] where T: Comparable
}

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

extension Array where Element: Comparable {
    
    // MARK: - Typealiases
    
    public typealias ComparisonClosure = (Element, Element) -> Bool
    
    // MARK: - Methods
    
    /// Sorts an array of Comparable elements using Merge sort algorithm
    ///
    /// - Parameter list: is an Array of Comparable elements
    /// - Returns: the same sorted Array
    public static func mergeSort(_ list: [Element], order sign: ComparisonClosure) -> [Element] {
        
        if list.count < 2 { return list }
        let center = (list.count) / 2
        
        let leftMergeSort = mergeSort([Element](list[0..<center]), order: sign)
        let rightMergeSort = mergeSort([Element](list[center..<list.count]), order: sign)
        
        return merge(left: leftMergeSort, right: rightMergeSort, order: sign)
    }
    
    /// Helper method that performs Conquer and Combine stages for the Merge sort algorithm
    ///
    /// - Parameters:
    ///   - lhalf: is an Array containing left half of the target array that needs to be sorted
    ///   - rhalf: is an Array containing right hald of the target array that needs to be sorted
    /// - Returns: a Combined array of Comparable elements
    private static func merge(left lhalf: [Element], right rhalf: [Element], order sign: ComparisonClosure) -> [Element] {
        
        var leftIndex = 0
        var rightIndex = 0
        let totalCapacity = lhalf.count + rhalf.count
        
        var temp = [Element]()
        temp.reserveCapacity(totalCapacity)
        
        while leftIndex < lhalf.count && rightIndex < rhalf.count {
            let leftElement = lhalf[leftIndex]
            let rightElement = rhalf[rightIndex]
            
            let leftGreatherThanRight = sign(leftElement, rightElement)
            let leftSmallerThanRight = !leftGreatherThanRight
            
            if leftGreatherThanRight {
                temp.append(leftElement)
                leftIndex += 1
            } else if leftSmallerThanRight {
                temp.append(rightElement)
                rightIndex += 1
            } else {
                temp.append(leftElement)
                temp.append(rightElement)
                leftIndex += 1
                rightIndex += 1
            }
        }
        
        temp += [Element](lhalf[leftIndex..<lhalf.count])
        temp += [Element](rhalf[rightIndex..<rhalf.count])
        
        return temp
    }
    
}


extension Array where Element: Comparable {
    
    static func quickSort(array: inout [Element], lowest: Int, highest: Int) {
        
        if lowest < highest {
            let pivot = Array.partitionHoare(array: &array, lowest: lowest, highest: highest)
            
            Array.quickSort(array: &array, lowest: lowest, highest: pivot)
            Array.quickSort(array: &array, lowest: pivot + 1, highest: highest)
        } else {
            debugPrint(#function + " lowest param is bigger than highest: ", lowest, highest)
        }
    }
    
    private static func partitionHoare(array: inout [Element], lowest: Int, highest: Int) -> Int {
        let pivot = array[lowest]
        var i = lowest - 1
        var j = highest + 1
        
        while true {
            i += 1
            
            while array[i] < pivot { i += 1 }
            j -= 1
            
            while array[j] > pivot {j -= 1 }
            if i >= j { return j }
            
            array.swapAt(i, j)
        }
    }
    
}

struct Sorter {

    var strategy: SortingStrategy
    
    init(strategy: SortingStrategy) {
        self.strategy = strategy
    }
    
    func sort<T: Comparable>(items: [T]) -> [T] {
        return strategy.sort(items: items)
    }
}


let quickSortStrategy = QuickSortStrategy()
let mergeSortStrategy = MergeSortStrategy()

let items = [1,2,7,4,8,2,4,6,1,8,6]
print("items: ", items)

var sorter = Sorter(strategy: quickSortStrategy)
let quickSortedItems = sorter.sort(items: items)
print("quickSortedItems : ", quickSortedItems)

sorter.strategy = mergeSortStrategy
let mergeSortedItems = sorter.sort(items: items)
print("mergeSortedItems : " , mergeSortedItems)
