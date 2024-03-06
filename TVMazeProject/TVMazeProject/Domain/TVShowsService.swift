// TVShowsService.swift

import Combine
import Foundation

protocol HasTVShowsService {
    var service: TVShowsServiceProtocol { get }
}

protocol TVShowsServiceProtocol {
    func fetchShows(page: Int) async throws -> [TVShow]
    func searchShows(query: String) async throws -> [TVShow]
    func fetchSeasons(for showID: Int) async throws -> [Season]
    func fetchEpisodes(for seasonID: Int) async throws -> [Episode]
}

struct TVShowsService: TVShowsServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchShows(page: Int) async throws -> [TVShow] {
        let endpoint = APIEndpoints.shows(page: page).urlString
        return try await networkService.fetchData(from: endpoint)
    }

    func searchShows(query: String) async throws -> [TVShow] {
        let endpoint = APIEndpoints.search(query: query).urlString
        let searchResults: [Searched] = try await networkService.fetchData(from: endpoint)
        return searchResults.compactMap { $0.show }
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
