actor RetryAPIService: PokemonAPIServiceProtocol {
    private let wrapped: PokemonAPIServiceProtocol
    private let maxAttempts: Int
    
    init(wrapped: PokemonAPIServiceProtocol, maxAttempts: Int =  5) {
        self.wrapped = wrapped
        self.maxAttempts = maxAttempts
    }
    
    func getPokemon(name: String) async throws -> Pokemon {
        try await  retry {
            try await wrapped.getPokemon(name: name)
        }
    }
    
    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonList {
        try await retry {
            try await wrapped.getPokemonList(limit: limit, offset: offset)
        }
    }
    
    private func retry<T>(operation: () async throws -> T) async throws -> T {
        var attempts: Int = 0
        while true {
            attempts += 1
            do {
                return try await operation()
            } catch let error as NetworkError
                        where error.isRetryable && attempts < maxAttempts{
                try? await Task.sleep(for: .seconds(1))
            } catch {
                throw error
            }
        }
    }
    
}
