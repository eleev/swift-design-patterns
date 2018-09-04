# Marker Design Pattern
`Marker` is a structural design pattern that is used to provide run-time metadata with objects. The associated information then used to indicate that the marked type requires specific treatment or belongs to a particular gategory that needs to be processed uniquely. 

In Swift the pattern is implemented using `protocols`. We simply crete an *empty protocol* and a *target type* that needs to be marked. Then we can retrienve that information at run-time and perform some custom logic around the corresponding types.

## Example



## Issues

The main issue with `Marker` pattern is that it's implemented using protocols, that defines contract to be conformed or implemented. Then all the types that inherit from the marked type also has that metadata associated with them. Basically the marker conformance cannot be undone for the child types. 

The described issue can be eliminated with *custom, user-defined attribues* which are not yet supported by Swift - only pre-defined *attribues* can used. 

## Conclusion