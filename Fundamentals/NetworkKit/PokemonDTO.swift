import Foundation

struct PokemonDTO: Codable {
    let abilities: [AbilityDTO]
    let baseExperience: Int
    let id: Int
    let moves: [MoveDTO]
    let name: String
    let species: NamedResourceDTO
    let sprites: SpritesDTO
    let stats: [StatDTO]
    let types: [TypeDTO]
    let weight: Int

    struct AbilityDTO: Codable {
        let ability: NamedResourceDTO
        let isHidden: Bool
        let slot: Int
    }

    struct MoveDTO: Codable {
        let move: NamedResourceDTO
    }

    struct StatDTO: Codable {
        let baseStat: Int
        let effort: Int
        let stat: NamedResourceDTO
    }

    struct TypeDTO: Codable {
        let slot: Int
        let type: NamedResourceDTO
    }

    struct SpritesDTO: Codable {
        let backDefault: String?
        let backFemale: String?
        let backShiny: String?
        let backShinyFemale: String?
        let frontDefault: String?
        let frontFemale: String?
        let frontShiny: String?
        let frontShinyFemale: String?
    }

    struct NamedResourceDTO: Codable {
        let name: String
        let url: String
    }
}

// MARK: - Decode

func decodePokemon(from data: Data) throws -> PokemonDTO {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return try decoder.decode(PokemonDTO.self, from: data)
}

// MARK: - Extension
/*
 ** PokemonType has unowned in case the API returns an unexpected value
 ** Move type is .normal until new request implementation with power with 100 as default
*/
extension PokemonDTO {
    func toDomain() -> Pokemon {
        let types: [PokemonType] = self.types.map { dtoMap in
            PokemonType(rawValue: dtoMap.type.name) ?? .unknown
        }
        let moves = self.moves.map { move in
            Move(name: move.move.name, type: .normal, power: 100)
        }
        let attack = self.stats.first { $0.stat.name == "attack" }
        let deffense = self.stats.first { $0.stat.name == "defense" }
        let hp = self.stats.first { $0.stat.name == "hp" }
        return Pokemon(id: id,
                       name: name,
                       types: types,
                       moves: moves,
                       defense: Double(deffense?.baseStat ?? 0),
                       attack: Double(attack?.baseStat ?? 0),
                       baseHp: hp?.baseStat ?? 0
        )
    }
}
