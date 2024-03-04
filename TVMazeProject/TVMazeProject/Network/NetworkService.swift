//
//  TVShowsServiceProtocol.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 03/03/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(from urlString: String) async throws -> T
}

struct NetworkService: NetworkServiceProtocol {
    func fetchData<T>(from urlString: String) async throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(T.self, from: data)
    }
}


