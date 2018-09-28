# Proxy Design Pattern
`Proxy` is a structural design pattern that acts as an agent, wrapper or interface type by hiding some other type under the hood. When proxy functions as an interface to something else, it forwards responsibilities to “real object“ (an object that actually performs actions or processes data) or/and proxy can add additional logic on top of exisiting one.

For instance let’s assume that we have an object that can download files from the Web. We can implement a proxy that will wrap the downloaded files and cache them. Proxy can act as an `umbrella` by hiding part of and interface of a “real object”. That is very useful when the “real object” is extensively used in other places of an app and we need some extra functionality but we don’t want to re-implement most of the “real object“ again. 

Proxy provides means for following one of the `S.O.L.I.D.` principles, which is the `Single Responsibility Principle`: instead of adding additional functionality to the “real object” we create a dedicated one, which is specialized on a specific task. That separates responsibilites in separate types and makes extension, refactoring and the overall complexity of a code-base to be more easily maintained.

## Umbrealla Proxy

Let's assume that we a class that is responsible for making `HTTP` method calls:

```swift
public class Networking {
    
    // MARK: - Initializers
    
    public init() {
        // Set up of the class
    }
    
    // MARK: - API methods
    
    public func dataTask(for url: URL, completion: @escaping (URLResponse?) -> ()) {
        let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            completion(response)
        }
        session.resume()
    }
    
}
```
The class is pretty straightforward, it performs a `data task` using a `URL`. We can implement `Proxy` that will create a slightly different interface around this class, for different purposes:

```swift

public class BackendNetworkingProxy {
    
    public enum DataUpdateStatus {
        case success
        case delayed
        case error
        case uncategorized
    }
    
    // MARK: - Properties
    
    private var url = URL(string: "http://www.ourbackend.com/data-update/")!
    private(set) var networking: Networking
    
    // MARK: - Initializers
    
    public init() {
        networking = Networking()
    }
    
    // MARK: - Methods
    
    public func requestDataUpdate(completion: @escaping (DataUpdateStatus?)->()) {
        
        networking.dataTask(for: url) { response in
            guard let uresponse = response as? HTTPURLResponse else {
                completion(nil)
                return
            }
            
            switch uresponse.statusCode {
            case 200...203: // does not repesent actual status code handling, for demonstration purposes only
                completion(.success)
            case 735: // does not repesent actual status code handling, for demonstration purposes only
                completion(.delayed)
            case 400...600: // does not repesent actual status code handling, for demonstration purposes only
                completion(.error)
            default:
                completion(.uncategorized)
            }
        }
    }
}
```

The presented `BackendNetrworkingProxy` class wrapps `Networking` class and adds extra logic around the `URL` and `status code` handling. It incapsulates already made functionality and creates a slightly more domain-specific interface aroud it - that is why this variation of `Proxy` is called `Umbrella Proxy`. 

## Proxy Framework
`Proxy Framework` enables, so to speak, `Playground-Dirven` development. `Playground-Driven` development  is relatively new concept, many big companies (such as `Uber`, `Alpha Bank` etc.) use this approach is fast prototyping, reduced compilation time for testing and the overall flexibility of development. These are just a few application of *Proxy Frameworks*. `Proxy Frameworks` are used to wrap code that needs to be seen by an internal `.playground` files (*internal* in terms of a software project). Otherwise, `.playgrounds` cannot see the files located outside of the file itself. This type of framework is used to wrap the parts of the application that requires to be accessed by `.playground` files. 

We don't dive deep into this topic here, I think it's just a very useful think to know and moreover, it helps to understand that `Proxy` design pattern is a very flexible concept that can be applied in may contexts.


## Conclusion 
`Proxy` is powerful yet simple to implement structural design pattern. In `iOS` there is even a dedicated abstract class called `NSProxy`.

> An abstract superclass defining an API for objects that act as stand-ins for other objects or for objects that don’t exist yet.
> 
> **Source:** [Apple Developer Documentation](https://developer.apple.com/documentation/foundation/nsproxy)

One key difference of the `NSProxy` is that it can handle `lazy initialization` of objects that are heavy. `Lazy initialization` is yet another design pattern, so instead of implementing two design patterns you can cut the corner and use `NSProxy` for suitable situations. However sometimes it's easier to create your own light-weight version. 
