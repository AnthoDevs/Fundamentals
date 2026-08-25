//
//  PokemonDTOTests.swift
//  Fundamentals
//
//  Created by Anthony on 8/24/26.
//
@testable import Fundamentals
import Testing
import Foundation

class PokemonDTOTests {

    @Test
    func decodeDataToPokemonDTO() throws {
        let data = try TestJSONLoader.load("pikachu")
        let dto = try decodePokemon(from: data)
        #expect(dto.name == "pikachu")
        #expect(dto.id == 25)
    }
    
    @Test
    func pokemonDTOToDomain() throws {
        let data = try TestJSONLoader.load("pikachu")
        let dto = try decodePokemon(from: data)
        
        let pokemon = dto.toDomain()
        
        #expect(pokemon.name == "pikachu")
        #expect(pokemon.attack == 55)
    }
}
