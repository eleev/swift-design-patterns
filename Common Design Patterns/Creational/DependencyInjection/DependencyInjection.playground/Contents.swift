import Foundation

//class DataStorage {
//
//    // MARK: - Properties
//
//    private let dataBase: DataBase
//
//    // MARK: - Initailizers
//
//    init() {
//        dataBase = DataBase(schemeType: .queue)
//    }
//    // ... the rest of the implementation
//}

//class DataStorage {
//
//    // MARK: - Properties
//
//    private let dataBase: Persistance
//
//    // MARK: - Initailizers
//
//    init(dataBase: Persistance) {
//        self.dataBase = dataBase
//    }
//
//    // ... the rest of the implementation
//}

class DataStorage {
    
    // MARK: - Properties
    
    var dataBase: Persistence
    
    // MARK: - Initailizers
    
    init(dataBase: Persistence) {
        self.dataBase = dataBase
    }
    
    // ... the rest of the implementation
}

enum PersistenceSchemeType {
    case queue
    case query
    case graph
}

protocol Serializable {
    func serialize() -> Serializable
}

protocol Persistence {
    
    // MARK: - Properties
    
    var schemeType: PersistenceSchemeType { get }
    
    // MARK: - Initialisers
    
    init(schemeType: PersistenceSchemeType)
    
    // MARK: - Methods
    
    func save(serializable: Serializable)
    func load(_ id: String, completion: @escaping (_ record: Serializable) -> Void)
}

class DataBase: Persistence {
 
    // MARK: - Properties
    
    var schemeType: PersistenceSchemeType
    
    // MARK: - Initializers
    
    required init(schemeType: PersistenceSchemeType) {
        self.schemeType = schemeType
    }
    
    // MARK: - Methods
    
    func save(serializable: Serializable) {
        print(#function + " serializable is saved!")
    }
    
    func load(_ id: String, completion: @escaping (Serializable) -> Void) {
        print(#function + " serializable for id: ", id, " has been read!")
    }
}


class PropertyList: Persistence {
    
    // MARK: - Propeties
    
    var schemeType: PersistenceSchemeType
    
    // MARK: - Initializers
    
    required init(schemeType: PersistenceSchemeType) {
        self.schemeType = schemeType
    }
    
    // MARK: - Methods
    
    func save(serializable: Serializable) {
        print(#function + " serializable is saved!")
    }
    
    func load(_ id: String, completion: @escaping (Serializable) -> Void) {
        print(#function + " serializable for id: ", id, " has been read!")
    }
}


// ?
//let storage = DataStorage()

let dataBase = DataBase(schemeType: .graph)
let storage = DataStorage(dataBase: dataBase)

let propertyList = PropertyList(schemeType: .query)
storage.dataBase = propertyList

