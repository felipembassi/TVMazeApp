//
//  TVShowsService.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 03/03/24.
//

import Combine
import Foundation

protocol TVShowsServiceProtocol {
    func fetchShows(page: Int) async throws -> [TVShow]
    func searchShows(query: String) async throws -> [TVShow]
    func fetchSeasons(for showID: Int) async throws -> [Season]
    func fetchEpisodes(for seasonID: Int) async throws -> [Episode]
}

struct TVShowsService: TVShowsServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchShows(page: Int) async throws -> [TVShow] {
        let endpoint = APIEndpoints.shows(page: page).urlString
        return try await networkService.fetchData(from: endpoint)
    }

    func searchShows(query: String) async throws -> [TVShow] {
        let endpoint = APIEndpoints.search(query: query).urlString
        let searchResults: [TVShow] = try await networkService.fetchData(from: endpoint)
        return searchResults.compactMap { $0 }
    }
    
    func fetchSeasons(for showID: Int) async throws -> [Season] {
        let endpoint = APIEndpoints.seasons(tvShow: showID).urlString
        return try await networkService.fetchData(from: endpoint)
    }
    
    func fetchEpisodes(for seasonID: Int) async throws -> [Episode] {
        let endpoint = APIEndpoints.episodes(season: seasonID).urlString
        return try await networkService.fetchData(from: endpoint)
    }
}

