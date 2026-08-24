//
//  ContentView.swift
//  Fundamentals
//
//  Created by Anthony on 15/07/26.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemonViewModel: PokemonListViewModel = PokemonListViewModel(pokemonList: pokemonArray)
    @State private var isGrid: Bool = false
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
                    }
                    #endif // DEBUG
                    Button {
                        pokemonViewModel.filterFavorites()
                    } label: {
                            Image(systemName: pokemonViewModel.showFavorites ? "star.fill" : "star")
                                .font(.title2)
                                .foregroundStyle(.yellow)
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
                            await pokemonViewModel.simulateCallAPI(for: 2)
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    Spacer()
                case .content:
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
            }
            .padding()
        }
        .task {
            await pokemonViewModel.simulateCallAPI(for: 3)
        }
    }
    
    @ViewBuilder
    func pokemonCell(pokemon: Pokemon ) -> some View {
        NavigationLink {
            PokemonDetail(pokemon: pokemon, isFavorite: pokemonViewModel.isFavorite(id: pokemon.id), toggleFavorite: pokemonViewModel.toggleFavorite(id:))
        } label: {
            if isGrid {
                VStack{
                    Image(systemName: "person")
                        .font(.title)
                    Text(pokemon.name)
                    HStack{
                        ForEach(pokemon.types, id: \.self) { type in
                            Image(systemName: "circle.fill")
                        }
                    }
                }.padding()
            } else {
                Image(systemName: "person")
                    .font(.callout)
                Text(pokemon.name)
                ForEach(pokemon.types, id: \.self) { type in
                 Image(systemName: "circle.fill")
                }
            }
        }
    }
    
    private static let pokemonArray: [Pokemon] = [
        .init(
            id: 1,
            name: "Bulbasaur",
            types: [.bug, .grass],
            moves: [.init(name: "bit",
                          type: .grass,
                          power: 12)],
            defense: 1,
            attack: 110, baseHp: 100),
        .init(
            id: 2,
            name: "Charmander",
            types: [.fire, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 33,
            attack: 100, baseHp: 120),
        .init(
            id: 3,
            name: "Squirtle",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 90, baseHp: 140),
        .init(
            id: 4,
            name: "Pikachu",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 140, baseHp: 90),
        .init(
            id: 5,
            name: "Jigglypuff",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 40, baseHp: 300),
        .init(
            id: 6,
            name: "Meowth",
            types: [.bug, .grass],
            moves: [.init(name: ":D",
                          type: .bug,
                          power: 12)],
            defense: 1,
            attack: 140, baseHp: 80),
        ]
}

#Preview {
    ContentView()
}
