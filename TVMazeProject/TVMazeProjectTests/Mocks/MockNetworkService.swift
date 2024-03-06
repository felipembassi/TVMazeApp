// MockNetworkService.swift

import Foundation
@testable import TVMazeProject

struct MockNetworkService: NetworkServiceProtocol {
    var result: Any = []
    var errorToThrow: Error?

    func fetchData<T>(from _: String) async throws -> T where T: Decodable {
        if let error = errorToThrow {
            throw error
        }
        return try cast(result)
    }

    private func cast<T>(_ value: Any) throws -> T {
        guard let value = value as? T else {
            throw URLError(.cannotParseResponse)
        }
        return value
    }
}
