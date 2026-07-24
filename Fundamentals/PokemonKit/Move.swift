enum MoveError: Error {
    case moveNotFound
}

struct Move: Codable, Hashable {
    let name: String
    let type: PokemonType
    let power: Double
}
