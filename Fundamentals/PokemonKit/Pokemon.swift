import Foundation
struct Pokemon: Codable, Hashable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let moves: [Move]
    let defense: Int
    let attack: Int
    let baseHp: Int
    var isDualType: Bool { types.count > 1 }
}
