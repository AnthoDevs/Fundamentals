import SwiftUI

@Observable
final class PokemonListViewModel {
    private var pokemonList: [Pokemon]
    var search: String = ""
    var sortByNameAsc: Bool = false

    var filteredList: [Pokemon] {
        var filteredResult: [Pokemon] = []

        if search.isEmpty {
            filteredResult = pokemonList
        } else {
            filteredResult = GenericFunctions.search(pokemonList) { pokemon in
                pokemon.name.localizedCaseInsensitiveContains(search)
            }
        }

        filteredResult = GenericFunctions.localSort(filteredResult) { a, b in
            sortByNameAsc ? a.name < b.name : a.name > b.name
        }

        return filteredResult
    }
    init(pokemonList: [Pokemon]) {
        self.pokemonList = pokemonList
    }
   
}
