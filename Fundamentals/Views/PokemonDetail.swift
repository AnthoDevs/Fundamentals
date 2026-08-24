//
//  PokemonDetail.swift
//  Fundamentals
//
//  Created by Anthony on 8/6/26.
//

import SwiftUI

struct PokemonDetail: View {
    let pokemon: Pokemon
    let isFavorite: Bool
    let toggleFavorite: (Int) -> Void
    var body: some View {
        VStack {
            HStack {
                Text(pokemon.name)
                    .font(.largeTitle)
                Button {
                    toggleFavorite(pokemon.id)
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            Divider()
            Text("Atk: \(pokemon.attack.formatted(.number.precision(.fractionLength(2))))")
                .font(.title2)
            Text("Types: " + pokemon.types.map(\.rawValue).joined(separator: ", "))
                .font(.title2)
        }
    }
}

#Preview {
    PokemonDetail(pokemon: Pokemon(id: 1, name: "Pichachu", types: [.bug, .electric], moves: [.init(name: "Tackle", type: .normal, power: 0)], defense: 10.0, attack: 300.0, baseHp: 100), isFavorite: true) { _ in
        
    }
}
