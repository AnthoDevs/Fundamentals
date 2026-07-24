final class Gym {
    let id: Int
    let name: String
    let address: String
    weak var trainer: Trainer?
    
    init(id: Int, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
    
    deinit {
        print("Gym \(name) is being deinitialized")
    }
}
