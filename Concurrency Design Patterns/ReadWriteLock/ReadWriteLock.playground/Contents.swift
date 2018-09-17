import Foundation

final public class ReadWriteLock {
    
    // MARK: - Properties
    
    private var rwLock: pthread_rwlock_t = {
        var rwLock = pthread_rwlock_t()
        pthread_rwlock_init(&rwLock, nil)
        return rwLock
    }()
    
    // MARK: - Deinit
    
    deinit {
        destroy()
    }
    
    // MARK: - Methods
    
    func readLock() {
        pthread_rwlock_rdlock(&rwLock)
    }
    
    func tryReadLock() {
        pthread_rwlock_tryrdlock(&rwLock)
    }
    
    func writeLock() {
        pthread_rwlock_wrlock(&rwLock)
    }
    
    func tryWriteLock() {
        pthread_rwlock_trywrlock(&rwLock)
    }
    
    // MARK: - Private methods
    private func destroy() {
        pthread_rwlock_destroy(&rwLock)
    }
    
    func unlock() {
        pthread_rwlock_unlock(&rwLock)
    }
}
