//
//  MockNetworkService.swift
//  TVMazeProjectTests
//
//  Created by Felipe Moreira Tarrio Bassi on 03/03/24.
//

import Foundation
@testable import TVMazeProject


struct MockNetworkService: NetworkServiceProtocol {
    var result: Any
    
    func fetchData<T>(from urlString: String) async throws -> T where T: Decodable {
        return try cast(result)
    }
    
    private func cast<T>(_ value: Any) throws -> T {
        guard let value = value as? T else {
            throw URLError(.cannotParseResponse)
        }
        return value
    }
}

