import Foundation
struct PokemonList {
    var next: String?
    var previous: String?
    var pokemonItem: [PokemonListItem]
}

struct PokemonListItem: Identifiable {
    let id: String
    var name: String
    var url: String
}
