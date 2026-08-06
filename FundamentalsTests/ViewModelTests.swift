@testable import Fundamentals
import Testing

struct ViewModelTests {
    let pokemonArray = MockData.pokemonArray
    
    @Test()
    func emptySearch() {
        // GIVEN
        let sut = PokemonListViewModel(pokemonList: pokemonArray)
        // WHEN
        let expected = sut.filteredList.count
        // THEN
        #expect(expected == pokemonArray.count)
    }
    
    @Test
    func filterByName() {
        let sut = PokemonListViewModel(pokemonList: pokemonArray)
        sut.search = "ch"
        let expected = sut.filteredList.count
        #expect(expected == 2)
    }
    
    @Test
    func filterReturnEmpty() {
        let sut = PokemonListViewModel(pokemonList: pokemonArray)
        sut.search = "anthony"
        let expected = sut.filteredList.count
        #expect(expected == 0)
    }
    
    @Test
    func sortOrderOnFilter() {
        let sut = PokemonListViewModel(pokemonList: pokemonArray)
        let fullList = sut.filteredList.count
        let firstPokemonUnordered = sut.filteredList.first?.name
        sut.sortByNameAsc = true
        let firstPokemonSorted = sut.filteredList.first?.name
        
        #expect(firstPokemonUnordered != firstPokemonSorted)
        #expect(firstPokemonSorted == "Bulbasaur")
        #expect(firstPokemonUnordered == "Squirtle")
        #expect(fullList == 6)
    }
}
