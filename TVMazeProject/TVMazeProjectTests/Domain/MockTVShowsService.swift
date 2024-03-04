// MockTVShowsService.swift

import Foundation
@testable import TVMazeProject

class MockTVShowsService: TVShowsServiceProtocol {
    var showsToReturn: [TVShow] = []
    var errorToThrow: Error?

    func fetchShows(page _: Int) async throws -> [TVShow] {
        if let error = errorToThrow {
            throw error
        }
        return showsToReturn
    }

    func searchShows(query: String) async throws -> [TVShow] {
        if let error = errorToThrow {
            throw error
        }
        return showsToReturn.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
}
