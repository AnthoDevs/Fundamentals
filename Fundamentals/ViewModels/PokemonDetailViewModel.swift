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
    private var service: PokemonAPIService

    init() {
        self.service = PokemonAPIService()
    }

    func getPokemonDetail(name: String) async {
        viewState = .loading
        do {
            let pokemon = try await service.getPokemon(name: name)
            viewState = .loaded(pokemon)
        } catch let networkError as NetworkError {
            viewState = .error(networkError)
        } catch {
            viewState = .error(.unknown)
        }
    }
}
