import SwiftUI

@MainActor
@Observable
final class PokemonListViewModel {
    private var pokemonList: [Pokemon]
    private(set) var favorites: Set<Int> = []
    private var repository: Repository

    var search: String = "" {
        didSet {
            updateListState()
        }
    }
    var sortByNameAsc: Bool = false
    var listState: ListState = .empty
    private(set) var showFavorites: Bool = false
    
    init(pokemonList: [Pokemon]) {
        self.pokemonList = pokemonList
        self.repository = Repository()
    }

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
        
        if showFavorites {
            filteredResult = GenericFunctions.search(filteredResult) { pokemon in
                favorites.contains(pokemon.id)
            }
        }
        return filteredResult
    }
    
    func simulateCallAPI(for seconds: Int) async {
        self.listState = .loading
        repository.getPokemon { result in
            switch result {
            case .success(let list):
                self.pokemonList = list
                self.updateListState()
                break
            case .failure(_):
                self.listState = .error
                break
            }
        }
    }

    func filterFavorites() {
        showFavorites.toggle()
        updateListState()
    }
    
    func toggleFavorite(id: Int) {
        if favorites.contains(id){
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        updateListState()
    }
    
    func isFavorite(id: Int) -> Bool {
        favorites.contains(id)
    }

    func getError() {
        listState = .error
    }
    
    func updateListState() {
        listState = filteredList.isEmpty ? .empty : .content
    }
}
