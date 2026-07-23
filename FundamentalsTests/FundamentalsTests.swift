@testable import Fundamentals
import Testing

struct FundamentalsTests {

    @Test func pikachuNameIsPikachu() {
        let pokemon: Pokemon = .init(
            id: 1,
            name: "Pikachu",
            types: [.bug],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 100,
            baseHp: 100)

        #expect(pokemon.name == "Pikachu")
    }
    
    @Test
    func maxLimitTeam() throws {
        var team = Team(pokemon: pokemonArray)
        #expect(team.count == 6)
        #expect(throws: TeamError.teamIsFull) {
            try team.add(
                Pokemon(
                    id: 7,
                    name: "Blaistoise",
                    types: [.water],
                    moves: [.init(
                        name: "watter gun",
                        type: .water,
                        power: 12)],
                    defense: 200,
                    attack: 100,
                    baseHp: 1000))
        }
    }
    
    @Test
    func pokemonIsDuplicated() throws {
        var pokemonList = Team(pokemon: [pokemonArray[1], pokemonArray[2]])
        let pokemonToAdd = pokemonArray[1]
        #expect(pokemonList.count == 2)
        #expect(throws: TeamError.duplicatedPokemon) {
            try pokemonList.add(pokemonToAdd)
        }
        #expect(pokemonList.count == 2)
    }
    
    @Test
    func pokemonRemovedSucess() throws {
        var pokemonList = Team(pokemon: pokemonArray)
        
        #expect(pokemonList.count == 6)
        let pokemonToRemove = pokemonArray[0]
        try pokemonList.remove(pokemonToRemove)
        #expect(pokemonList.count == 5)
    }

    @Test
    func pokemonNotFound() throws {
        var pokemonList = Team(pokemon: [pokemonArray[1], pokemonArray[2]])
        let pokemonToRemove = pokemonArray[0]
        #expect(throws: TeamError.pokemonNotFound) {
            try pokemonList.remove(pokemonToRemove)
        }
    }
    
    let pokemonArray: [Pokemon] = [
        .init(
            id: 1,
            name: "Bulbasaur",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 100, baseHp: 100),
        .init(
            id: 2,
            name: "Charmander",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 100, baseHp: 100),
        .init(
            id: 3,
            name: "Squirtle",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 100, baseHp: 100),
        .init(
            id: 4,
            name: "Pikachu",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 100, baseHp: 100),
        .init(
            id: 5,
            name: "Jigglypuff",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 100, baseHp: 100),
        .init(
            id: 6,
            name: "Meowth",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 100, baseHp: 100),
        ]
}
