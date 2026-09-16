//
//  PokemonListViewModelTests.swift
//  FundamentalsTests
//
//  Created by Anthony on 9/12/26.
//
@testable import Fundamentals
import Testing
import Foundation

@Suite(.serialized)
struct PokemonListViewModelTests {

    @MainActor
    @Test
    func getPokemonList() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
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
        await sut.getPokemonList(limit: 20, offset: 1)
        #expect(sut.filteredList.count == 20)
    }
    
    @MainActor
    @Test
    func getPokemonListWithError() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        MockURLProtocol.requestHandler = { request in
            throw NetworkError.unauthorized
        }
        await sut.getPokemonList(limit: 0, offset: 1)
        #expect(sut.filteredList.count == 0)
        #expect(sut.listState == .error)
    }
    
    @MainActor
    @Test
    func getPokemonListdeduplication() async {
        let service = MockPokemonAPIService()
        let deduplicatedService = DeduplicatingPokemonAPIService(
            wrapping: service
        )
        async let first = await deduplicatedService.getPokemonList(limit: 1, offset: 0)
        async let second = await deduplicatedService.getPokemonList(limit: 1, offset: 0)
        
        _ = try? await (first, second )
        
        #expect(service.getpokemonListCalls == 1)
    }
    
    @MainActor
    @Test
    func paginationFormat() async {
        let service = getService()
        let sut = PokemonListViewModel(service: service)
        MockURLProtocol.requestHandler = { request in
            let url = try #require(request.url)
            let components = try #require(
                URLComponents(
                    url: url,
                    resolvingAgainstBaseURL: false
                )
            )
            let limit = components.queryItems?
                .first(where: { $0.name == "limit" })?
                .value

            let offset = components.queryItems?
                .first(where: { $0.name == "offset" })?
                .value

            #expect(limit == "20")
            #expect(offset == "1")
            let response = HTTPURLResponse(
                url: url,
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
        await sut.getPokemonList(limit: 20, offset: 1)
        #expect(sut.filteredList.count == 20)
        
    }

    @MainActor
    @Test
    func retryMaxAttemptsFail() async {
        let service = MockPokemonAPIService(isRetrying: true, successOn: 5)
        let retryService = RetryAPIService(wrapped: service)
        let sut = PokemonListViewModel(service: retryService)
        await sut.getPokemonList(limit: 20, offset: 0)
        #expect(sut.listState == .error)
    }

    @MainActor
    @Test
    func retryMaxSuccess() async {
        let service = MockPokemonAPIService(isRetrying: true, successOn: 3)
        let retryService = RetryAPIService(wrapped: service)
        let sut = PokemonListViewModel(service: retryService)
        await sut.getPokemonList(limit: 20, offset: 0)
        #expect(sut.listState == .content)
    }

    @MainActor
    @Test
    func getPokemonDetailDeduplication () async {
        let service = MockPokemonAPIService()
        let deduplicatedService = DeduplicatingPokemonAPIService(wrapping: service)
        async let first = await deduplicatedService.getPokemon(name: "")
        async let second = await deduplicatedService.getPokemon(name: "")
        _ = try? await (first, second)
        #expect(service.getPokemonCalls == 1)
    }
    
    class MockPokemonAPIService: PokemonAPIServiceProtocol {
        var getPokemonCalls: Int = 0
        var getpokemonListCalls: Int = 0
        var isRetrying: Bool = false
        let successOn: Int // viewModel try 5 times
        var attempts: Int = 0
        let pokemon = Pokemon(id: 1,
                       name: "",
                       types: [],
                       moves: [],
                       defense: 1,
                       attack: 1,
                       baseHp: 1
        )

        init(isRetrying: Bool = false, successOn: Int = 0) {
            self.isRetrying = isRetrying
            self.successOn = successOn
        }
        func getPokemon(name: String) async throws -> Fundamentals.Pokemon {
            getPokemonCalls += 1
            try await Task.sleep(for: .milliseconds(100))
            return pokemon
        }
        
        func getPokemonList(limit: Int, offset: Int) async throws -> Fundamentals.PokemonList {
            getpokemonListCalls += 1
            try await Task.sleep(for: .milliseconds(100))
            if isRetrying,
               attempts < successOn {
                attempts += 1
                throw NetworkError.noConnection
            } else {
                return PokemonList(pokemonItem: [])
            }
        }
    }

    func getService() -> PokemonAPIService {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        return service
    }
    
}
