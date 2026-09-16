struct PokemonListDTO: Decodable{
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonListItemDTO]
    
    struct PokemonListItemDTO: Decodable {
        var name: String
        var url: String
    }
    
    func toDomain() -> PokemonList {
        let pokemonItems = results.map { pokemon in
            PokemonListItem(id: pokemon.name, name: pokemon.name, url: pokemon.url)
        }
        return PokemonList(next: next,
                    previous: previous,
                    pokemonItem: pokemonItems,
                    )
    }
}


