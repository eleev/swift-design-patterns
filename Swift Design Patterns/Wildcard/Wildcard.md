# Wildcard Swift Pattern

`Wildcard` pattern matches and ignores the assigned value. It helps in a number of situations where we don't care about the matched values.

Consider the following example:

```swift
_ = function(param: 5)
```

We may use this pattern to silence the warning raised by *Xcode*, in cases when we don't know yet where to use the returned value. 

```swift
for _ in 0...10 {
	function()
}
```

In other cases we may not need to assing the current value in *for in* loop, we just want to iterate a number of times.

```swift
if let _ = optionalFunction() {
    print("Function passed the optional unwrapping")
}
```

Finally we may more *Swiftly* check whether the function returns non-nil value.