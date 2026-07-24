import Foundation
struct Pokemon: Codable, Hashable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let moves: [Move]
    let defense: Double
    let attack: Double
    let baseHp: Int
    var isDualType: Bool { types.count > 1 }
    
    func makeAttack(with moveString: String , to pokemon: Pokemon) throws -> Double   {
        guard let move = moves.first(where: { $0.name == moveString })  else { throw MoveError.moveNotFound }
        var maxMultiplier: Double = 0
        for type in pokemon.types {
            let multiplier: Double = move.type.calculateDamage( against: type)
            maxMultiplier = maxMultiplier > multiplier ? maxMultiplier : multiplier
        }
        let totalDamage: Double = ((attack/pokemon.defense) + move.power) * maxMultiplier
        return totalDamage
    }
}
