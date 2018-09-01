# Command Design Pattern
`Command` is a behavioral design pattern that creates a type that can change its behavior at runtime. It's achieved through a protocol that defines an interface which is implemented by conforming types. Those types incapsulate all the information needed to perform an action or logic. `Command` types make very easy to construct generic components that delegate or execute method calls dynamically, depending on concrete implementations that are assigned to *receiver* via *aggrigation*. 

Command pattern is implemented using several building blocks: `command` protocol, `concrete command` types, `receiver` and `caller`. Let's break each component down one by one:

- Command protocol is a protocol that defines actions to be executed
- Concrete command types are types that conform to the Command protocol
- Receiver is a type that is connected with Command protocol via *aggregation*
- Caller is a type that acts as a source of triggers actions and possibly needs to get some resutls back

If you are a bit confused by all the termonology, don't worry, we will implement each building block programmatically. We could skip all of that and dive straight into the code, but it's important to know the exact terms since it is a common practice and it will help to establish common vocabulary when working in a team. [McConnel]() has a dedicated chapter about the importance of professional terminology and ability to give real-world analogies. 

## Dynamic Execution







## Conclusion
