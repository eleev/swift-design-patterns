# Marker Design Pattern
`Marker` is a structural design pattern that is used to provide run-time metadata with objects. The associated information then used to indicate that the marked type requires specific treatment or belongs to a particular category that needs to be processed uniquely. 

In Swift the pattern is implemented using `protocols`. We simply create an *empty protocol* and a *target type* that needs to be marked. Then we can retrieve that information at run-time and perform some custom logic around the corresponding types.

## Example



## Issues

The main issue with `Marker` pattern is that it's implemented using protocols, that defines contract to be conformed or implemented. Then all the types that inherit from the marked type also have that metadata associated with them. Basically the marker conformance cannot be undone for the child types which may lead to unexpected run-time issues, that are hard to debug.

The described issue can be eliminated with *custom, user-defined attributes* which are not yet supported by Swift - only pre-defined *attributes* can be used. 

## Conclusion
