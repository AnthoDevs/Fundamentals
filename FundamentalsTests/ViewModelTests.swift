@testable import Fundamentals
import Foundation
import Testing

struct ViewModelTests {
    let pokemonArray = MockData.pokemonArray
    func getService() -> PokemonAPIService {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        return service
    }

    @Test()
    @MainActor
    func emptySearch() async {
        // GIVEN
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        // WHEN
        let expected = sut.filteredList.count
        // THEN
        #expect(expected == 20)
    }
    
    @Test
    @MainActor
    func filterByName() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        sut.search = "ch"
        let expected = sut.filteredList.count
        #expect(expected == 3)
    }
    
    @Test
    @MainActor
    func filterReturnEmpty() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        sut.search = "anthony"
        let expected = sut.filteredList.count
        #expect(expected == 0)
    }
    
    @Test
    @MainActor
    func sortOrderOnFilter() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        let fullList = sut.filteredList.count
        let firstPokemonUnordered = sut.filteredList.first?.name
        sut.sortByNameAsc = true
        let firstPokemonSorted = sut.filteredList.first?.name
        
        #expect(firstPokemonUnordered != firstPokemonSorted)
        #expect(firstPokemonSorted == "beedrill")
        #expect(firstPokemonUnordered == "weedle")
        #expect(fullList == 20)
    }
    
    @Test
    @MainActor
    func filterfavorites() async{
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        let firstPokemon = sut.filteredList.first!
        sut.toggleFavorite(name: firstPokemon.id)
        sut.filterFavorites()
        #expect(sut.filteredList.count == 1)
    }
    
    @Test
    @MainActor
    func addAndRemoveFavorite() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        let firstPokemon = sut.filteredList.first!
        sut.toggleFavorite(name: firstPokemon.id)
        #expect(sut.favorites.count == 1)
        sut.toggleFavorite(name: firstPokemon.id)
        #expect(sut.favorites.count == 0)
    }
    
    @Test
    @MainActor
    func simulateAPICall() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        #expect(sut.filteredList.count == 20)
    }
    
    @Test
    @MainActor
    func emptyState() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        sut.search = "asdasd"
        #expect(sut.listState == .empty)
    }
    
    @Test
    @MainActor
    func errorState() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        sut.getError()
        #expect(sut.listState == .error)
    }
    
    @Test
    @MainActor
    func successState() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        #expect(sut.listState == .content)
    }
    
    @Test
    @MainActor
    func updateFavoriteList() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            let data = try TestJSONLoader.load("pokemonList")
            return (
                response,
                Data(data)
            )
        }
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        sut.toggleFavorite(name: "bulbasaur")
        sut.toggleFavorite(name: "ivysaur")
        #expect(sut.favorites.count == 2)
    }

    @Test
    @MainActor
    func searchField() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        await sut.getPokemonList(limit: 20, offset: 0)
        let initialFilteredPokemon = sut.filteredList.count
        sut.search = "Ch"
        
        #expect(sut.filteredList.count == 3)
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
