# Lazy Initialization Design Pattern

`Lazy Initialization` is a creational design pattern that delays type construction, value calculation or any other computationally expensive operation until it's needed. The patter is very helpful, especially in mobile software development, that for example may improve the overall app performance and launching time. 

Swift has direct support for the pattern with the `lazy` keyword that can be used to mark properties. Properties marked with the `lazy` keyword have to be variable since constant properties must have values before the initialization is finished.

## Delayed Initialization

In practice, it's very simple to implement and use this pattern:

```swift
lazy var customView = UIView(frame: rect)
```
`customView` has been marked as `lazy` and it will be initialized only when it's accessed for the first time. 

We may use initialization closures to setup a lazy property:

```swift 
lazy var nextButton: UIButton = {
	let button = UIButton(frame: CGRect(x: 140, y: 500, width: 110, height: 44))
	button.setTitle("Next Screen", for: .normal)
	button.backgroundColor = .lightGray
        
	button.addTarget(self, action: #selector(ViewController.handleNextViewController(_:)), for: .touchUpInside)
        
	return button
}()
```
The closure example works exactly the same as the previous example - the only difference is the assignment of the closure that returns configured `UIButton` instance. Note that the closure will be called just once, when the `nextButton` property will be first accessed.

Another approach is that we can use instance methods to setup lazy property:

```swift
lazy var label: UILabel = prepareMessage()    
    
private func prepareMessage() -> UILabel {
	let label = UILabel(frame: CGRect(x: 100, y: 300, width: 250, height: 56))
	label.text = "Hello Next View Controller!"
	label.textColor = .black
	label.alpha = 0.0
        
	return label
}    
```

Basically it's the same as assigning closures to the lazy properties, since functions are first class types in Swift. 

## Conclusion
`Lazy Initialization` is a great way to improve app's launch time, delay complex `UI` control initialization or data source processing. The usage of this pattern in trivial in Swift, since it has integrated support for delayed initialization. 