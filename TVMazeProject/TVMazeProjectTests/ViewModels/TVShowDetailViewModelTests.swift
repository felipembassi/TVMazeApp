//
//  TVShowDetailViewModelTests.swift
//  TVMazeProjectTests
//
//  Created by Felipe Moreira Tarrio Bassi on 07/03/24.
//

import Combine
import XCTest
@testable import TVMazeProject

final class TVShowDetailViewModelTests: XCTestCase {
    var viewModel: TVShowDetailViewModel<MockCoordinator>!
    var mockService: MockTVShowsService!
    var mockCoordinator: MockCoordinator!
    var sampleTVShow: TVShow!
    private var cancellables: Set<AnyCancellable>!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockTVShowsService()
        mockCoordinator = MockCoordinator()
        sampleTVShow = TVShow.preview().first
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockCoordinator = nil
        super.tearDown()
    }
    
    @MainActor
    func testFetchingSeasonsAndEpisodesSuccess() async {
        let mockSeasons = Season.preview()
        let mockEpisodes = Episode.preview()
        mockService.seasonsToReturn = mockSeasons
        mockService.episodesToReturn = mockEpisodes
        viewModel = TVShowDetailViewModel(tvShow: sampleTVShow!, service: mockService, coordinator: mockCoordinator)
        
        let detailExpectation = expectation(description: "Load tv show Season and episodes")
        
        viewModel.$seasons
            .dropFirst(2)
            .sink { _ in
                detailExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchSeasonsAndEpisodes()
        
        await fulfillment(of: [detailExpectation], timeout: 1.0)
        
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.errorMessage == nil)
        XCTAssertEqual(viewModel.seasons.count, Season.preview().count)
        XCTAssertEqual(viewModel.seasons[mockSeasons[0]], mockEpisodes)
    }
    
    @MainActor
    func testFetchingSeasonsError() async {
        mockService.errorToThrow = NSError(domain: "TestError", code: -1, userInfo: nil)
        viewModel = TVShowDetailViewModel(tvShow: sampleTVShow!, service: mockService, coordinator: mockCoordinator)
        
        let showsExpectation = expectation(description: "Load tv shows error")
        showsExpectation.assertForOverFulfill = false
        
        viewModel.$errorMessage
            .dropFirst(3)
            .sink { _ in
                showsExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchSeasonsAndEpisodes()
        
        await fulfillment(of: [showsExpectation], timeout: 1.0)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
