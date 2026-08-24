@testable import Fundamentals
import Testing

struct ViewModelTests {
    let pokemonArray = MockData.pokemonArray
    
    @Test()
    @MainActor
    func emptySearch() async {
        // GIVEN
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        await sut.simulateCallAPI(for: 0)
        // WHEN
        let expected = sut.filteredList.count
        // THEN
        #expect(expected == pokemonArray.count)
    }
    
    @Test
    @MainActor
    func filterByName() async {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        await sut.simulateCallAPI(for: 0)
        sut.search = "ch"
        let expected = sut.filteredList.count
        #expect(expected == 2)
    }
    
    @Test
    @MainActor
    func filterReturnEmpty() async {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        await sut.simulateCallAPI(for: 0)
        sut.search = "anthony"
        let expected = sut.filteredList.count
        #expect(expected == 0)
    }
    
    @Test
    @MainActor
    func sortOrderOnFilter() async {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        await sut.simulateCallAPI(for: 0)
        let fullList = sut.filteredList.count
        let firstPokemonUnordered = sut.filteredList.first?.name
        sut.sortByNameAsc = true
        let firstPokemonSorted = sut.filteredList.first?.name
        
        #expect(firstPokemonUnordered != firstPokemonSorted)
        #expect(firstPokemonSorted == "Bulbasaur")
        #expect(firstPokemonUnordered == "Squirtle")
        #expect(fullList == 6)
    }
    
    @Test
    @MainActor
    func filterfavorites() async{
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        await sut.simulateCallAPI(for: 0)
        let firstPokemon = sut.filteredList.first!
        sut.toggleFavorite(id: firstPokemon.id)
        sut.filterFavorites()
        #expect(sut.filteredList.count == 1)
    }
    
    @Test
    @MainActor
    func addAndRemoveFavorite() async {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        await sut.simulateCallAPI(for: 0)
        let firstPokemon = sut.filteredList.first!
        sut.toggleFavorite(id: firstPokemon.id)
        #expect(sut.favorites.count == 1)
        sut.toggleFavorite(id: firstPokemon.id)
        #expect(sut.favorites.count == 0)
    }
    
    @Test
    @MainActor
    func simulateAPICall() async {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        await sut.simulateCallAPI(for: 0)
        #expect(sut.filteredList.count == 6)
    }
    
    @Test
    @MainActor
    func emptyState() async {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        await sut.simulateCallAPI(for: 0)
        sut.search = "asdasd"
        #expect(sut.listState == .empty)
    }
    
    @Test
    @MainActor
    func errorState() async {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        sut.getError()
        #expect(sut.listState == .error)
    }
    
    @Test
    @MainActor
    func successState() async {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        await sut.simulateCallAPI(for: 0)
        #expect(sut.listState == .content)
    }
    
    @Test
    func updateFavoriteList() {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        sut.toggleFavorite(id: 1)
        sut.toggleFavorite(id: 2)
        #expect(sut.favorites.count == 2)
    }

    @Test
    func searchField() {
        let sut = PokemonListViewModel(pokemonList: MockData.pokemonArray)
        let initialFilteredPokemon = sut.filteredList.count
        sut.search = "Ch"
        
        #expect(sut.filteredList.count == 2)
        #expect(sut.listState == .content)

        sut.search = "testing"
        #expect(sut.filteredList.count == 0)
        #expect(sut.listState == .empty)

        sut.search = ""
        #expect(sut.search == "")
        #expect(sut.filteredList.count == initialFilteredPokemon)
        #expect(sut.listState == .content)
    }
}
