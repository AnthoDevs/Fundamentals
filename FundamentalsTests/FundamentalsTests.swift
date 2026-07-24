@testable import Fundamentals
import Foundation
import Testing

struct FundamentalsTests {

    @Test func computedPropertyDualType() {
        let pokemon: Pokemon = .init(
            id: 1,
            name: "Pikachu",
            types: [.bug, .electric],
            moves: [.init(name: ":P",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 100,
            baseHp: 100)

        #expect(pokemon.isDualType == true)
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
    
    @Test
    func verifyEqualsPokemon() {
        let pokemonA = pokemonArray[0]
        let pokemonB = pokemonArray[0]
        #expect(pokemonA == pokemonB)
    }

    @Test
    func verifyUnequalsPokemon() {
        let pokemonA = pokemonArray[0]
        let pokemonB = pokemonArray[1]
        #expect(pokemonA != pokemonB)
    }
    
    @Test func decodeJsonToPokemon() throws{
        let json = """
        {
            "id": 1,
            "name": "Bulbasaur",
            "types": [
                "bug",
                "grass"
            ],
            "moves": [
                {
                    "name": ":D",
                    "type": "bug",
                    "power": 12
                }
            ],
            "defense": 1,
            "attack": 100,
            "baseHp": 100
        }
        """
        let data = Data(json.utf8)
        let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
        #expect(pokemon.id == 1)
        #expect(pokemon.name == "Bulbasaur")
        #expect(pokemon.baseHp == 100)
        
    }
    
    @Test
    func pokemonMakeAttack() throws {
        let pkmAttacker = pokemonArray[0]
        let pkmDeffender = pokemonArray[1]
        
        let result = try pkmAttacker.makeAttack(with: "bit", to: pkmDeffender)
        let expected = 15.030303030303031
        #expect(abs(expected - result) < 0.01)
    }
    
    @Test func movementNotFound() async throws {
        let pkmAttacker = pokemonArray[0]
        let pkmDeffender = pokemonArray[1]
        
        #expect(throws: MoveError.moveNotFound) {
            try pkmAttacker.makeAttack(with: "solarbeem", to: pkmDeffender)
        }
    }
    
    @Test
    func localsortPokemons() {
        let pokemon = pokemonArray.shuffled()
        let sortedPokemon = GenericFunctions.localSort(pokemon) { pokemonA, pokemonB in
            pokemonA.name > pokemonB.name
        }
        #expect(sortedPokemon[0].name == "Squirtle")
    }

    @Test
    func genericLocalSort() {
        let shuffledArray = [1,10,2,30,0,23,44]
        let sortedArray = GenericFunctions.localSort(shuffledArray) { itemA, itemB in
            itemA > itemB
        }
        #expect(sortedArray[0] == 44)
    }

    @Test
    func genericLocalSearch() {
        let array = ["Anthony", "Vaporeon", "Paola", "Ambkor"]
        let result = GenericFunctions.search(array) { item in
            item == "Paola"
        }
        #expect(result.count == 1)
    }

    @Test
    func trainerReference() {
        weak var trainerObserver: Trainer?
        weak var gymObserver: Gym?
        do {
            let trainer = Trainer(name: "Anthony", level: 100, pokemon: pokemonArray, region: "Sinnon")
            let gym = Gym(id: 1, name: "First Gym", address: "")
            trainer.gym = gym
            gym.trainer = trainer
            gymObserver = gym
            trainerObserver = trainer
            #expect(gymObserver != nil)
            #expect(trainerObserver != nil)
        }
        #expect(gymObserver == nil)
        #expect(trainerObserver == nil)
    }

    let pokemonArray: [Pokemon] = [
        .init(
            id: 1,
            name: "Bulbasaur",
            types: [.bug, .grass],
            moves: [.init(name: "bit",
                          type: .grass,
                          power: 12)],
            defense: 1,
            attack: 100, baseHp: 100),
        .init(
            id: 2,
            name: "Charmander",
            types: [.fire, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 33,
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
