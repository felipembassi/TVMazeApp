//
//  TVShowsViewModelTests.swift
//  TVMazeProjectTests
//
//  Created by Felipe Moreira Tarrio Bassi on 03/03/24.
//

import XCTest
@testable import TVMazeProject // Use your actual module name
import Combine

@MainActor
final class TVShowsViewModelTests: XCTestCase {
    private var viewModel: TVShowsViewModel!
    private var mockService: MockTVShowsService!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockTVShowsService()
        viewModel = TVShowsViewModel(service: mockService, debounceDelay: .zero)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertFalse(viewModel.isLoading, "ViewModel should not be in loading state initially")
        XCTAssertTrue(viewModel.shows.isEmpty, "ViewModel should initially have no shows")
    }

    func testLoadMoreContentInitially() async {
        mockService.showsToReturn = [TVShow](repeating: TVShow.mock, count: 10)
        
        let showsLoaded = expectation(description: "Shows are loaded")
        
        // Observe changes to the `shows` property
        viewModel.$shows
            .dropFirst() // Ignore the initial value
            .sink { shows in
                if shows.count == 10 {
                    showsLoaded.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadMoreContentIfNeeded(currentItem: nil)
        
        // Use the new await syntax for waiting on the expectation
        await fulfillment(of: [showsLoaded], timeout: 1.0)
        
        XCTAssertEqual(viewModel.shows.count, 10, "Expected 10 shows to be loaded initially")
    }
    
    func testNoShowsAvailable() async {
        mockService.showsToReturn = []
        viewModel.loadMoreContentIfNeeded(currentItem: nil)
        XCTAssertEqual(viewModel.shows.count, 0, "Expected no shows to be loaded")
    }
    
    func testErrorHandlingOnFetchFailure() async {
        mockService.errorToThrow = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock fetch error"])
        
        let errorExpectation = expectation(description: "Error handling")
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    errorExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadMoreContentIfNeeded(currentItem: nil)
        
        // Wait for the observable error message
        await fulfillment(of: [errorExpectation], timeout: 5.0)
        
        XCTAssertNotNil(viewModel.errorMessage, "Expected an error message after fetch failure")
    }
}

extension TVShowsViewModelTests {
    enum MockError: Error {
        case test
    }
}

extension TVShow {
    static var mock: TVShow {
        return TVShow(id: 1, url: "", name: "Mock Show", genres: [], status: .running, runtime: nil, averageRuntime: nil, premiered: nil, ended: nil, officialSite: nil, schedule: Schedule(time: "", days: []), rating: nil, image: SeriesImage(medium: "", original: ""), summary: "", updated: 0, seasons: [])
    }
}

