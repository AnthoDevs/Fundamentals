//
//  PokemonDetailViewModel.swift
//  Fundamentals
//
//  Created by Anthony on 8/26/26.
//

import Foundation

enum ViewState {
    case loaded(Pokemon)
    case loading
    case error(NetworkError)
}

@Observable
final class PokemonDetailViewModel {
    var viewState: ViewState = .loading
    private var service: PokemonAPIServiceProtocol

    init(service: PokemonAPIServiceProtocol) {
        self.service = service
    }

    func getPokemonDetail(name: String) async {
        viewState = .loading
        do {
            let pokemon = try await service.getPokemon(name: name)
            viewState = .loaded(pokemon)
        } catch is CancellationError {
            viewState = .error(.cancelled)
        } catch let networkError as NetworkError {
            viewState = .error(networkError)
        } catch {
            viewState = .error(.unknown)
        }
    }
}
