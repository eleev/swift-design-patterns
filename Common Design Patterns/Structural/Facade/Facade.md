# Facade Design Pattern
Facade is a structural design pattern. The pattern is used when a set of related `APIs` needs to be grouped together and wrapped into more simplified interface. As the name suggests, `Facade` is exterior side of something bigger and more complicated. `Facade` simplifies access to certain features that are incapsulated inside a `Facade` type. 

In order to implement the pattern we need to have a group of related types that operate under logically connected set of data of functions. For instance we may have several types that are design to give us an ability to book `flight` and `hotel`. 


Let's begin from declaring protocols for our models: 

```swift
public protocol Bookable {
    // Defines a set of requirements for Bookable item e.g. Flight, Hotel, House, Car etc.
}
```
The `Bookable` protocol acts as a `Marker Interface` (which is a design pattern) - it represents everything that can be booked. The next step is to add conformances to the protocol and create the actual types:

```swift
public struct Flight: Bookable {
    
    // Information about current flight
    
    public var departure: Airport
    public var destination: Airport
    public var duration: TimeInterval
    public var price: Price
}

public struct Hotel: Bookable {
    // The struct contains the info related to a Hotel
    
    public var pricePerNight: Price
    public var stars: StarsType
}
```
We implemented two model `structs` called `Flight` and `Hotel`. They are simply data containers. Don't worry about `Airport`, `Price` and `StartType` types: they are either `typealias` or data containers as well. 

The next step that we need to illustrate the pattern is to define logic around the `Bookable` data containers:

```swift
public protocol Booking {
    
    // MARK: - Methods
    
    static func getBookables(from fdate: Date, to tdate: Date) -> [Bookable]?
    static func book(_ bookable: Bookable)
}

```

The protocol `Booking` defines requirements for the types that provide concrete mechanisms for booking the bookables e.g. `Flight` and `Hotel`. Let's implement `FlightBooking` and `HotelBooking` types:

```swift
public struct FlightBooking: Booking {
    
    // MARK: - Methods
    
    public static func getBookables(from fdate: Date, to tdate: Date) -> [Bookable]? {
        var flights = [Flight]()
        
        // Dummy data
        let JFK = Airport(name: "John F. Kennedy International Airport")
        let VKO = Airport(name: "Vnukovo International Airport")
        let SFO = Airport(name: "San Francisco International Airport")
        let OSL = Airport(name: "Gardermoen Airport / Oslo Airport")
        
        let JFKVKO = Flight(departure: JFK, destination: VKO, duration: 10.20, price: 650)
        let JFKSFO = Flight(departure: JFK, destination: SFO, duration: 7.10, price: 350)
        let VKOOSL = Flight(departure: VKO, destination: OSL, duration: 2.40, price: 220)
        flights += [JFKVKO, JFKSFO, VKOOSL]

        return flights
    }
    
    public static func book(_ bookable: Bookable) {
        // Logic for booking a Flight
    }
    
}

public struct HotelBooking: Booking {
    
    // MARK: - Methods
    
    public static func getBookables(from fdate: Date, to tdate: Date) -> [Bookable]? {
        var hotels = [Hotel]()

        // Dummy data
        let fiveStarsHotel = Hotel(pricePerNight: 300, stars: .five)
        let fourStarsHotel = Hotel(pricePerNight: 200, stars: .four)
        let fourCheapStarsHotel = Hotel(pricePerNight: 140, stars: .four)
        let threeStarsHotel = Hotel(pricePerNight: 50, stars: .three)
        hotels += [fiveStarsHotel, fourStarsHotel, fourCheapStarsHotel, threeStarsHotel]

        return hotels
    }
    
    public static func book(_ bookable: Bookable) {
        // Here goes the logic for booking a Hotel
    }
    
}

```

The `structs` provide a simple `API` for booking hotels and flights by filling in the `data-source` by dummy data. 

Right now we can use both of the classes `HotelBooking` and `FlightBooking` and book either hotel or/and flight. However if we need to create an `API` with higher level of abstraction, we need to wrap the types into another type. Here goes `Facade` pattern - it incapsulates the related functionality and provides high-level interface. 

## Facade
We start from defining the signatures for our `APIs` which is going to be one initializer and two methods. 


```swift
public struct TravelFacade {
    
    // MARK: - Properties
    
    public private(set) var hotels: [Hotel]?
    public private(set) var flights: [Flight]?
    
    // MARK: - Initializers
    
    public init(from fdate: Date, to tdate: Date) {
        hotels = HotelBooking.getBookables(from: fdate, to: tdate) as? [Hotel]
        flights = FlightBooking.getBookables(from: fdate, to: tdate) as? [Flight]
    }
    
    // MARK: - API methods
    
    public func book(hotel: Hotel, flight: Flight) {
        HotelBooking.book(hotel)
        FlightBooking.book(flight)
    }
    
    public func book(flightPrice: Int, hotelPrice: Int, minHotelStars: StarsType) -> BookingResult {
        
        guard let flight = flights?.filter({ $0.price < flightPrice })[0] else {
            return (.missingFlight, nil, nil)
        }
        guard let hotel = hotels?.filter({ $0.stars.rawValue >= minHotelStars.rawValue && $0.pricePerNight < hotelPrice })[0] else {
            return (.missingHotel, nil, nil)
        }
        
        book(hotel: hotel, flight: flight)
        return (.success, flight, hotel)
    }
    
    public typealias BookingResult = (status: BookingStatus, flight: Flight?, hotel: Hotel?)
    
}
```
Let's break the example down: 

- We defined two collection properties for both hotel and flight types. Those properties will hold the filtered, preprocessed data for the specified date range
- The next step is we implemented the `initializer` that accepts two arguments for data range and we called the corresponding `getBookables(from: , to:) -> [Bookable]` methods, in order to get hotels and flights for the specified date range
- The final part is the `API` methods: 
	- The first method called `book(hotel:, flight:)`. It accepts two arguments and performs the related operations for booking suitable hotel and flight. 
	- The second method called `book(flightPrice:, hotelPrice:, minHotelStars) -> BookingResult`. It accepts three arguments for flight and hotel prices and minimum star rating for hotels. The method hides all the implementation details by providing very straightforward interface - it filters out the hotels and flight that don't match the provided criteria and then returns the resulting type called `BookingResult` that is a typealias for tuple containing the booking status, the exact hotel and flight information. 

The usage of the travel facade is also pretty straightforward and simple:

```swift
// Assume that the dates are pre-defined
let travel = TravelFacade(from: fromDate, to: toDate)

// Perform a single method call in order to book the travel, instead of calling a set of methods from different types and filtering out the boilerplate code
let bookingResult = travel.book(flightPrice: 500, hotelPrice: 150, minHotelStars: .four)

// bookingResult contains valid information about the travel with respect to the given price restrictions
```

`Facade` hides all the boilerplate code and provides clean, conscious interface that also easer to test, refactor and extend. 

## Conclusion
The `Facade` pattern is a great way to make your code easer to work with and as the pattern's category suggests, make your code-base more structured. A number of related but independent `APIs` can be grouped together to provide high-level interface. The pattern is not always recognizable when starting building software, since you may not have matching or enough types in order to immediately implement a facade for them. However the pattern can be easily added later on, it does not require you to change anything else in related types. The only thing that needs to be done is to refactor the calling side and wrap the types into a facade.
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  