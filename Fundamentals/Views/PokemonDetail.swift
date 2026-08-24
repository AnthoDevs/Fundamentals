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
    @ScaledMetric var iconSize: CGFloat = 20
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
    }
}

#Preview {
    PokemonDetail(pokemon: Pokemon(id: 1, name: "Pichachu", types: [.bug, .electric], moves: [.init(name: "Tackle", type: .normal, power: 0)], defense: 10.0, attack: 300.0, baseHp: 100), isFavorite: true) { _ in
        
    }
}
