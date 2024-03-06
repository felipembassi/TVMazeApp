// TVShowsServiceTests.swift

import XCTest
@testable import TVMazeProject

final class TVShowsServiceTests: XCTestCase {
    var service: TVShowsService!
    var mockNetworkService: MockNetworkService!

    enum MockError: Error {
        case test
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockNetworkService()
    }

    override func tearDownWithError() throws {
        service = nil
        mockNetworkService = nil
        try super.tearDownWithError()
    }

    @MainActor
    func testFetchShowsSuccess() async throws {
        let expectedShows = TVShow.preview()
        mockNetworkService.result = expectedShows
        service = TVShowsService(networkService: mockNetworkService)
        do {
            let shows = try await service.fetchShows(page: 1)
            XCTAssertEqual(shows.count, expectedShows.count)
        } catch {
            XCTFail("Fetch shows failed with unexpected error: \(error)")
        }
    }

    @MainActor
    func testFetchShowsFailure() async throws {
        mockNetworkService.errorToThrow = MockError.test
        service = TVShowsService(networkService: mockNetworkService)
        await XCTAssertThrowsError(try await service.fetchShows(page: 1))
    }

    @MainActor
    func testSearchShowsSuccess() async throws {
        let expectedShows = Searched.preview()
        mockNetworkService.result = expectedShows
        service = TVShowsService(networkService: mockNetworkService)
        do {
            let shows = try await service.searchShows(query: "Query")
            XCTAssertEqual(shows.count, expectedShows.count)
        } catch {
            XCTFail("Search shows failed with unexpected error: \(error)")
        }
    }

    @MainActor
    func testSearchShowsFailure() async throws {
        mockNetworkService.errorToThrow = MockError.test
        service = TVShowsService(networkService: mockNetworkService)
        await XCTAssertThrowsError(try await service.searchShows(query: "Query"))
    }

    @MainActor
    func testFetchSeasonsSuccess() async throws {
        let expectedSeasons = Season.preview()
        mockNetworkService.result = expectedSeasons
        service = TVShowsService(networkService: mockNetworkService)
        do {
            let seasons = try await service.fetchSeasons(for: 1)
            XCTAssertEqual(seasons.count, expectedSeasons.count)
        } catch {
            XCTFail("Fetch seasons failed with unexpected error: \(error)")
        }
    }

    @MainActor
    func testFetchSeasonsFailure() async throws {
        mockNetworkService.errorToThrow = MockError.test
        service = TVShowsService(networkService: mockNetworkService)
        await XCTAssertThrowsError(try await service.fetchSeasons(for: 1))
    }

    @MainActor
    func testFetchEpisodesSuccess() async throws {
        let expectedEpisodes = Episode.preview()
        mockNetworkService.result = expectedEpisodes
        service = TVShowsService(networkService: mockNetworkService)
        do {
            let episodes = try await service.fetchEpisodes(for: 1)
            XCTAssertEqual(episodes.count, expectedEpisodes.count)
        } catch {
            XCTFail("Fetch episodes failed with unexpected error: \(error)")
        }
    }

    @MainActor
    func testFetchEpisodesFailure() async throws {
        mockNetworkService.errorToThrow = MockError.test
        service = TVShowsService(networkService: mockNetworkService)
        await XCTAssertThrowsError(try await service.fetchEpisodes(for: 1))
    }
}
