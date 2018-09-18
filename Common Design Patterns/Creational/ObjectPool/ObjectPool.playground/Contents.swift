import Foundation

class ObjectPool<T> {
    
    // MARK: - Properties
    
    private var objects = [T]()
    
    // MARK: - Initializers
    
    init(objects: T...) {
        self.objects.reserveCapacity(objects.count)
        objects.forEach { self.objects += [$0] }
    }
    
    // MARK: - Mehtods
    
    func returnObject(_ object: T) {
        
    }
    
    func getObject() -> T? {
        return nil
    }
}
