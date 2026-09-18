import Foundation
struct PokemonList: Hashable {
    var next: String?
    var previous: String?
    var pokemonItem: [PokemonListItem]
}

nonisolated struct PokemonListItem: Hashable, Identifiable {
    let id: String
    var name: String
    var url: String
}
