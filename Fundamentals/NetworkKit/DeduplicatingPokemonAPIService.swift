
actor DeduplicatingPokemonAPIService: PokemonAPIServiceProtocol {
    private let wrapped: PokemonAPIServiceProtocol
    private var inFlightDetail: [String: Task<Pokemon, Error>] = [:]
    private var inFlightList: [String: Task<PokemonList, Error>] = [:]

    init(wrapping service: PokemonAPIServiceProtocol) {
        self.wrapped = service
    }

    func getPokemon(name: String) async throws -> Pokemon {
        if let existing = inFlightDetail[name] {
            return try await existing.value
        }
        let task = Task { try await wrapped.getPokemon(name: name) }
        inFlightDetail[name] = task
        defer { inFlightDetail[name] = nil }
        return try await task.value
    }

    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonList {
        if let existing = inFlightList["\(limit)-\(offset)"] {
            return try await existing.value
        }
        let task = Task { try await wrapped.getPokemonList(limit: limit, offset: offset) }
        inFlightList["\(limit)-\(offset)"] = task
        defer { inFlightList["\(limit)-\(offset)"] = nil }
        return try await task.value
    }
}
