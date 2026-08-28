//
//  PokemonAPIServiceProtocol.swift
//  Fundamentals
//
//  Created by Anthony on 8/26/26.
//

import Foundation

protocol PokemonAPIServiceProtocol {
    func getPokemon(name: String) async throws -> Pokemon
}
