final class Trainer {
    let name: String
    let level: Int
    let pokemon: [Pokemon]
    let region: String
    var gym: Gym?

    init(name: String, level: Int, pokemon: [Pokemon], region: String) {
        self.name = name
        self.level = level
        self.pokemon = pokemon
        self.region = region
    }
    
    deinit{
        print("Trainer \(name) is deinitialized")
    }
}
