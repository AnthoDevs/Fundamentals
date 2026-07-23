enum TeamError: Error {
    case teamIsFull
    case duplicatedPokemon
    case pokemonNotFound
}

struct Team {
    static let maxPokemonPerTeam: Int = 6
    private(set) var pokemon: [Pokemon] = []
    var count: Int { pokemon.count}
    var isFull: Bool { count >= Self.maxPokemonPerTeam }
    
    mutating func add(_ newPokemon: Pokemon) throws {
        guard !isFull else {
            throw TeamError.teamIsFull
        }
        guard !self.pokemon.contains(where: { $0.id == newPokemon.id }) else {
            throw TeamError.duplicatedPokemon
        }
        self.pokemon.append(newPokemon)
    }
    
    mutating func remove(_ pokemon: Pokemon) throws {
        guard let index = self.pokemon.firstIndex(where: { $0.id == pokemon.id }) else {
            throw TeamError.pokemonNotFound
        }
        self.pokemon.remove(at: index)
    }
}
