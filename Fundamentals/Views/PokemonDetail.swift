//
//  PokemonDetail.swift
//  Fundamentals
//
//  Created by Anthony on 8/6/26.
//

import SwiftUI

struct PokemonDetail: View {
    let isFavorite: Bool
    let toggleFavorite: (Int) -> Void
    @State var pokemonDetailViewModel: PokemonDetailViewModel
    let pokemonName: String
    @ScaledMetric var iconSize: CGFloat = 20

    var body: some View {
        Group {
            switch pokemonDetailViewModel.viewState {
            case .loaded(let pokemon):
                VStack {
                    HStack {
                        Text(pokemon.name)
                            .font(.largeTitle)
                        Button {
                            toggleFavorite(pokemon.id)
                        } label: {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .resizable()
                                .frame(width: iconSize, height: iconSize)
                                .accessibilityLabel(isFavorite ? "Unmark as favorite" : "Mark as favorite")
                        }
                    }
                    Divider()
                    Text("Attack: \(pokemon.attack.formatted(.number.precision(.fractionLength(2))))")
                        .font(.title2)
                    Text("Types: " + pokemon.types.map(\.rawValue).joined(separator: ", "))
                        .font(.title2)
                }
            case .loading:
                ProgressView()
            case .error:
                Text("Error")
                Button("Retry")  {
                    Task{
                        await pokemonDetailViewModel.getPokemonDetail(name: pokemonName)
                    }
                }
            }
        }.task {
            await pokemonDetailViewModel.getPokemonDetail(name: pokemonName)
        }
    }
}

#Preview {
    let service = PokemonAPIService(session: URLSession.shared)
    PokemonDetail(isFavorite: true,
                  toggleFavorite:  {_ in return },
                  pokemonDetailViewModel: PokemonDetailViewModel(service: service),
                  pokemonName: "pikachu")
}
