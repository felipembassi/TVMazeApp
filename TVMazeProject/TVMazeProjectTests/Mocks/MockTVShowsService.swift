// MockTVShowsService.swift

import Foundation
@testable import TVMazeProject

final class MockTVShowsService: TVShowsServiceProtocol {
    var showsToReturn: [TVShow] = []
    var seasonsToReturn: [Season] = []
    var episodesToReturn: [Episode] = []
    var personToReturn: [Person] = []
    var castcreditToReturn: [CastCredit] = []
    var errorToThrow: Error?

    func fetchShows(page _: Int) async throws -> [TVShow] {
        if let error = errorToThrow {
            throw error
        }
        return showsToReturn
    }

    func searchShows(query _: String) async throws -> [TVShow] {
        if let error = errorToThrow {
            throw error
        }
        return showsToReturn
    }

    func fetchSeasons(for _: Int) async throws -> [Season] {
        if let error = errorToThrow {
            throw error
        }

        return seasonsToReturn
    }

    func fetchEpisodes(for _: Int) async throws -> [Episode] {
        if let error = errorToThrow {
            throw error
        }

        return episodesToReturn
    }

    func fetchPerson(for _: Int) async throws -> [Person] {
        if let error = errorToThrow {
            throw error
        }
        return personToReturn
    }

    func fetchCastCredits(for _: Int) async throws -> [CastCredit] {
        if let error = errorToThrow {
            throw error
        }
        return castcreditToReturn
    }

    func searchPerson(query _: String) async throws -> [Person] {
        if let error = errorToThrow {
            throw error
        }
        return personToReturn
    }
}
