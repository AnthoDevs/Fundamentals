//
//  ContentView.swift
//  Fundamentals
//
//  Created by Anthony on 15/07/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @State private var isGrid: Bool = false
    @State private var isUIKIT: Bool = true // Hardcoded to test viewController
    let pokemonService: PokemonAPIServiceProtocol = PokemonAPIService(session: URLSession.shared)
    @State private var pokemonViewModel: PokemonListViewModel
    @State private var pokemonDetailViewModel: PokemonDetailViewModel
    var limit: Int = 20
    var offset: Int = 0

    init() {
        let retryService: PokemonAPIServiceProtocol = RetryAPIService(wrapped: pokemonService)
        let deduplicatedPokemonService: PokemonAPIServiceProtocol = DeduplicatingPokemonAPIService(wrapping: retryService)
        self.pokemonViewModel = PokemonListViewModel(service: deduplicatedPokemonService)
        self.pokemonDetailViewModel = PokemonDetailViewModel(service: deduplicatedPokemonService)
    }

    var body: some View {
        NavigationStack {
            VStack{
                Text("Pokemon List")
                HStack {
                    TextField("Search pokemon by name", text: $pokemonViewModel.search)
                        .padding()
                        .background(.gray.opacity(0.15))
                        .foregroundStyle(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    #if DEBUG
                    Button {
                        pokemonViewModel.getError()
                    } label: {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .accessibilityLabel("Simulate an error")
                    }
                    #endif // DEBUG
                    Button {
                        pokemonViewModel.filterFavorites()
                    } label: {
                            Image(systemName: pokemonViewModel.showFavorites ? "star.fill" : "star")
                                .font(.title2)
                                .foregroundStyle(.yellow)
                                .accessibilityLabel(pokemonViewModel.showFavorites ? "Show all pokemon" : "Show only favorites")
                    }
                    .padding(10)
                }
                HStack(spacing: 0) {
                    Toggle("Sort by name", isOn: $pokemonViewModel.sortByNameAsc)
                        .fixedSize()
                    Spacer()
                    Button {
                        isGrid.toggle()
                    } label: {
                        Image(systemName: isGrid ? "grid" : "list.bullet")
                            .font(.title2)
                            .accessibilityLabel(!isGrid ? "Show grid" : "Show list")
                        
                    }.padding(10)
                }.padding()
                switch pokemonViewModel.listState {
                case .loading:
                    Spacer()
                    ProgressView("Loading pokemon...")
                    Spacer()
                case .empty:
                    Spacer()
                    Text("No pokemon registered")
                    Spacer()
                case .error:
                    Spacer()
                    Text("Error")
                    Button {
                        Task {
                            await pokemonViewModel.getPokemonList(limit: limit, offset: offset)
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .accessibilityLabel("Retry")
                    }
                    Spacer()
                case .content:
                    if isUIKIT {
                        uikitView()
                    } else {
                        if isGrid {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 200))]) {
                                ForEach(pokemonViewModel.filteredList){ pokemon in
                                    pokemonCell(pokemon: pokemon)
                                }
                            }
                            Spacer()
                        } else {
                            List (pokemonViewModel.filteredList){ pokemon in
                                pokemonCell(pokemon: pokemon)
                            }
                        }
                    }
                case .retryable:
                    Text("Something went wrong, please try again")
                    Button("Try again") {
                        Task {
                            await pokemonViewModel.getPokemonList(limit: limit, offset: offset)
                        }
                    }
                }
            }
            .padding()
        }
        .task {
            await pokemonViewModel.getPokemonList(limit: limit, offset: offset)
        }
    }
    
    @ViewBuilder
    func pokemonCell(pokemon: PokemonListItem ) -> some View {
        NavigationLink {
            PokemonDetail(
                isFavorite: pokemonViewModel.isFavorite(name: pokemon.name),
                toggleFavorite: pokemonViewModel.toggleFavorite(name: ),
                pokemonDetailViewModel: pokemonDetailViewModel,
                pokemonName: pokemon.name
            )
        } label: {
            if isGrid {
                VStack{
                    Image(systemName: "person")
                        .font(.title)
                        .accessibilityHidden(true)
                    Text(pokemon.name)
                        .accessibilityLabel(pokemon.name)
                }.padding()
            } else {
                Image(systemName: "person")
                    .font(.callout)
                    .accessibilityHidden(true)
                Text(pokemon.name)
                    .accessibilityLabel(pokemon.name)
            }
        }
        .accessibilityElement(children: .combine)
    }
    
    struct uikitView : UIViewControllerRepresentable {
        typealias UIViewControllerType = PokemonListViewController

        func makeUIViewController(context: Context) -> PokemonListViewController {
            PokemonListViewController()
        }

        func updateUIViewController(_ uiViewController: PokemonListViewController, context: Context) {
            
        }
    }
}

#Preview {
    ContentView()
}
