import SwiftUI

@MainActor
@Observable
final class PokemonListViewModel {
    private var pokemonList: [PokemonListItem] = []
    private var service: PokemonAPIServiceProtocol
    var sortByNameAsc: Bool = false
    var listState: ListState = .empty
    private(set) var showFavorites: Bool = false
    private(set) var favorites: Set<String> = []
    var search: String = "" {
        didSet {
            updateListState()
        }
    }
    var filteredList: [PokemonListItem] {
        var filteredResult: [PokemonListItem] = []

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
        
        if showFavorites {
            filteredResult = GenericFunctions.search(filteredResult) { pokemon in
                favorites.contains(pokemon.name)
            }
        }
        return filteredResult
    }
    init(service: PokemonAPIServiceProtocol) {
        self.service = service
    }
    func getPokemonList(limit: Int, offset: Int) async {
        self.listState = .loading
        do {
            let pokemonList =  try await service.getPokemonList(limit: limit, offset: offset)
            self.pokemonList = pokemonList.pokemonItem
            self.listState = .content
        } catch {
            self.listState = .error
        }
    }


    func filterFavorites() {
        showFavorites.toggle()
        updateListState()
    }
    
    func toggleFavorite(name: String) {
        if favorites.contains(name) {
            favorites.remove(name)
        } else {
            favorites.insert(name)
        }
        updateListState()
    }
    
    func isFavorite(name: String) -> Bool {
        favorites.contains(name)
    }

    func getError() {
        listState = .error
    }
    
    func updateListState() {
        listState = filteredList.isEmpty ? .empty : .content
    }
}
