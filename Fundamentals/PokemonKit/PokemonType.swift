enum PokemonType : String, Codable {
    case normal = "normal"
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
}

extension PokemonType: DamageCalculatorProtocol {

    func calculateDamage(against defender: PokemonType) -> Double {
        //Tabla efectividad
        switch (self, defender) {
        case (.electric, .ground):
            return 0
        case (.grass, .poison):
            return 0.5
        case (.ghost, .normal):
            return 0
        case (.ground, .grass):
            return 0.5
        case (.ground, .electric):
            return 2.0
        default :
            return 1.0
                  
        }
    }
}
