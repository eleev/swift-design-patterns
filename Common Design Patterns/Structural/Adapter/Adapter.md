# Adapter Design Pattern
`Adapter` is a structural design pattern that is aimed to resolve an issue with incompatible interfaces (in our case it  is protocols). The resolution consists of creating an `Adapter` type that wraps the incompatible `Adaptee` type, so the `Target` type will be able to use it. As it was just mentioned, the pattern has three  building blocks: 

- `Adaptee` - is **what** needs to be adopted
- `Adapter`- is a type that specifies **how** it needs to be adopted
- `Target` - is a type that specifies **where** `Adaptee` needs to be used

The pattern can be used to solve several problems. For instance when there is a client code that requires a specific type of interface from its types. Also the pattern can be used in cases when two or more types need to work together, but they have incompatible interfaces (protocols). 

The pattern can be implemented by using *inheritance* or *composition*. I personally prefer *composition* over *inheritance*, when there is a choice. That is why we are going to focus on an example where we will use an `Adapter` type as a composite type of our `Target` type.


## USB-C Charger for iPhone



## Conclusion