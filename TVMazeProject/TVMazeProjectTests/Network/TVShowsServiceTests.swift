// TVShowsServiceTests.swift

import XCTest
@testable import TVMazeProject

final class TVShowsServiceTests: XCTestCase {
    func testFetchShowsSuccess() async throws {
        let expectedShows = [TVShow(
            id: 1,
            url: "",
            name: "Test Show",
            genres: [],
            status: .running,
            runtime: nil,
            averageRuntime: nil,
            premiered: nil,
            ended: nil,
            officialSite: nil,
            schedule: Schedule(time: "", days: []),
            rating: nil,
            image: SeriesImage(medium: "", original: ""),
            summary: "",
            updated: 0,
            seasons: []
        )]
        let mockNetworkService = MockNetworkService(result: expectedShows)
        let service = TVShowsService(networkService: mockNetworkService)

        do {
            let shows = try await service.fetchShows(page: 1)
            XCTAssertEqual(shows.count, expectedShows.count)
            XCTAssertEqual(shows.first?.name, expectedShows.first?.name)
        } catch {
            XCTFail("Service failed with error: \(error)")
        }
    }
}
