//
//  ContentView.swift
//  Fundamentals
//
//  Created by Anthony on 15/07/26.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemonViewModel: PokemonListViewModel = .init(pokemonList: pokemonArray)
    var body: some View {
        VStack{
            Text("Pokemon List")
            HStack {
                TextField("Search pokemon by name", text: $pokemonViewModel.search)
                    .textFieldStyle(.roundedBorder)
                Toggle("Sort by name", isOn: $pokemonViewModel.sortByNameAsc)
            }
            
            List (pokemonViewModel.filteredList){ pokemon in
                Text("Name: \(pokemon.name)")
            }
        }
        .padding()
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
