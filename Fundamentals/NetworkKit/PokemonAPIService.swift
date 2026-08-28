//
//  PokemonAPIService.swift
//  Fundamentals
//
//  Created by Anthony on 8/24/26.
//

import Foundation
enum NetworkError: Error, Equatable {
    case notFound
    case unauthorized
    case serverError
    case decodingError
    case badUrl
    case timeout
    case unknown
    case noConnection
    case cancelled
}
enum ApiUrl: String {
    case detail = "https://pokeapi.co/api/v2/pokemon/"
}
class PokemonAPIService: PokemonAPIServiceProtocol {
    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    let pokemonUrl: ApiUrl = .detail
    func getPokemon(name: String) async throws -> Pokemon {
        try Task.checkCancellation()
        
        guard let url = URL(string: "\(pokemonUrl.rawValue)\(name)") else { throw NetworkError.badUrl }
        
        let data: Data
        let apiResponse: URLResponse

        do {
            (data, apiResponse) = try await session.data(from: url)
            try Task.checkCancellation()
        } catch let cancellError as CancellationError {
            throw NetworkError.cancelled
        } catch let urlError as URLError {
            switch urlError.code {
                case .timedOut: throw NetworkError.timeout
                case .notConnectedToInternet: throw NetworkError.noConnection
                case .cancelled: throw NetworkError.cancelled
                default: throw NetworkError.unknown
            }
            
        } catch {
            throw NetworkError.unknown
        }

        guard let response = apiResponse as? HTTPURLResponse else { throw NetworkError.unknown }
            switch response.statusCode {
            case 200:
                do {
                    let dto = try  decodePokemon(from: data)
                    let pokemon = dto.toDomain()
                    return pokemon
                } catch {
                    throw NetworkError.decodingError
                }
            case 404:
                throw NetworkError.notFound
            case 401:
                throw NetworkError.unauthorized
            case 500:
                throw NetworkError.serverError
            default:
                throw NetworkError.unknown
            }
    }
    
    // MARK: - Keep old version as example
    func getPokemonWithClosure(completion: @escaping (Result<[Pokemon], Error>) -> Void ){
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/pikachu")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error {
                print(error)
                completion(.failure(error))
                return
            }
            guard let data,
                  let jsonData = String(data: data, encoding: .utf8)
            else { return }
            print(jsonData)
        }.resume()
    }
}
