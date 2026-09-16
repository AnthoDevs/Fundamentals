//
//  APIServicesTests.swift
//  Fundamentals
//
//  Created by Anthony on 8/26/26.
//
import Testing
@testable import Fundamentals
import Foundation

@Suite(.serialized)
struct APIServicesTests {

    @Test
    @MainActor
    func testLoadedState() async {
        defer {
            MockURLProtocol.requestHandler = nil
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            let data = try TestJSONLoader.load("pikachu")
            return (
                response,
                Data(data)
            )
        }

        await sut.getPokemonDetail(name: "pikachu")
        
        switch sut.viewState {
        case .loaded(let pokemon):
            #expect(pokemon.name == "pikachu")
        default:
            Issue.record("Expected loaded state")
        }
        
    }
    
    @MainActor
    @Test func testNotFoundError() async {
        defer {
            MockURLProtocol.requestHandler = nil
        }
        MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(
                    url: request.url!,
                    statusCode: 404,
                    httpVersion: nil,
                    headerFields: nil
                )!

                return (response, Data())
            }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)
        
        await sut.getPokemonDetail(name: "mr mime")
        switch sut.viewState {
        case .error(let networkError):
            #expect(networkError == .notFound)
        default:
            Issue.record("Expected error")
        }
    }
    
    @MainActor
    @Test
    func serverError() async {
        defer {
            MockURLProtocol.requestHandler = nil
        }
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, Data())
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)
        
        await sut.getPokemonDetail(name: ":P")
        
        switch sut.viewState {
        case .error(let networkError):
            #expect(networkError == .serverError)
        default:
            Issue.record("Error expected")
        }
    }

    @MainActor
    @Test
    func unknown400Error() async {
        defer {
            MockURLProtocol.requestHandler = nil
        }
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, Data())
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)

        await sut.getPokemonDetail(name: "togepi")
        
        switch sut.viewState {
        case .error(let networkError):
            #expect(networkError == .unknown)
        default:
            Issue.record("Expected error")
        }
    }

    @MainActor
    @Test
    func unauthorized() async {
        defer {
            MockURLProtocol.requestHandler = nil
        }
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, Data())
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)

        await sut.getPokemonDetail(name: "togepi")
        
        switch sut.viewState {
        case .error(let networkError):
            #expect(networkError == .unauthorized)
        default:
            Issue.record("Expected error")
        }
    }
    
    @MainActor
    @Test func unknown() async {
        defer {
            MockURLProtocol.requestHandler = nil
        }
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 123,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)
        
        await sut.getPokemonDetail(name: "togepi")
        
        switch sut.viewState {
         case .error (let error):
            #expect(error == .unknown)
        default:
            Issue.record("Expected unknown")
        }
    }
    
    @Test
    @MainActor
    func invalidJSON() async {
        defer {
            MockURLProtocol.requestHandler = nil
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("invalid".utf8))
        }
        
        await sut.getPokemonDetail(name: "pikachu")
        
        switch sut.viewState {
        case .error (let error):
            #expect(error == .decodingError)
        default:
            Issue.record("Error expected")
        }
    }
    
    @Test
    @MainActor
    func emptyJSON() async {
        defer {
            MockURLProtocol.requestHandler = nil
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data("{}".utf8))
        }
        await sut.getPokemonDetail(name: "bulbasaur")
        switch sut.viewState {
        case .error(let error):
            #expect(error == .decodingError)
            break
        default:
            Issue.record("Error expected")
        }
    }
    
    @Test
    @MainActor
    func timeOut() async {
        defer {
            MockURLProtocol.requestHandler = nil
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)
        
        MockURLProtocol.requestHandler = { request in
            throw URLError(.timedOut)
        }
        await sut.getPokemonDetail(name: "pikachu")
        switch sut.viewState {
        case .error(let networkError):
            #expect(networkError == .timeout)
        default:
            Issue.record("Error expected")
        }
    }
    
    @Test
    @MainActor
    func cancellationError() async {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        let service = PokemonAPIService(session: session)
        let sut = PokemonDetailViewModel(service: service)
        
        let task = Task {
             await sut.getPokemonDetail(name: "pikachu")
        }
        task.cancel()
            _ =  await task.value
            switch sut.viewState {
            case .error(let networkError):
                #expect(networkError == .cancelled)
            default:
                Issue.record ("")
            }
        
    }
}
