//
//  Repository.swift
//  Fundamentals
//
//  Created by Anthony on 8/24/26.
//

import Foundation

class Repository {
    func getPokemon(completion: @escaping (Result<[Pokemon], Error>) -> Void ){
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/pikachu")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error {
                print(error)
                completion(.failure(error))
                return
            }
            guard let data,
                  let jsonData = String(data: data, encoding: .utf8)
            else { return }
            print(jsonData)
        }.resume()
    }
}
