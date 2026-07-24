//
//  Move.swift
//  Fundamentals
//
//  Created by Anthony on 7/15/26.
//

import Foundation

struct Move: Codable, Hashable {
    let name: String
    let type: PokemonType
    let power: Int
}
