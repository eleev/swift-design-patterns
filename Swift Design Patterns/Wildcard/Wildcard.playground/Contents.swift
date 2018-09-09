import Foundation

func function(param: Int) -> Int{
    print(#function, param)
    return param + 1
}

_ = function(param: 5)


func function() {
    print(#function)
}

for _ in 0...10 {
    function()
}

func optionalFunction() -> Int? {
    return 5
}

if let _ = optionalFunction() {
    print("Function passed the optional unwrapping")
}
