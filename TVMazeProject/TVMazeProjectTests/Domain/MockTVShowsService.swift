//
//  MockTVShowsService.swift
//  TVMazeProjectTests
//
//  Created by Felipe Moreira Tarrio Bassi on 03/03/24.
//

import Foundation
@testable import TVMazeProject

class MockTVShowsService: TVShowsServiceProtocol {
    var showsToReturn: [TVShow] = []
    var errorToThrow: Error?

    func fetchShows(page: Int) async throws -> [TVShow] {
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
