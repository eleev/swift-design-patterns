
import Foundation

let singleton = Singleton.instnage
singleton.counter
singleton.increment()
singleton.counter

let anotherSingleton = Singleton.instnage
anotherSingleton.counter
anotherSingleton.increment()

singleton.counter


let structSingleton = StructSignleton.sharedInstance
structSingleton.increment()
structSingleton.counter


let anotherStructSingleton = StructSignleton.sharedInstance
anotherStructSingleton.increment()
anotherStructSingleton.counter

let dispatchSingleton = DispatchSingleton.sharedInstance
dispatchSingleton.counter
dispatchSingleton.increment()

let anotherDispatchSingleton = DispatchSingleton.sharedInstance
anotherDispatchSingleton.counter
anotherDispatchSingleton.increment()
anotherDispatchSingleton.counter
