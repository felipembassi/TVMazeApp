// TVShowsViewModelTests.swift

import Combine
import XCTest
@testable import TVMazeProject

final class TVShowsViewModelTests: XCTestCase {
    private var mockService: MockTVShowsService!
    private var mockCoordinator: MockCoordinator!
    private var cancellables: Set<AnyCancellable>!
    
    enum MockError: Error {
        case test
    }

    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockTVShowsService()
        mockCoordinator = MockCoordinator()
        cancellables = []
    }

    override func tearDown() {
        mockService = nil
        mockCoordinator = nil
        cancellables = nil
        super.tearDown()
    }

    @MainActor
    func testInitialization() {
        let viewModel = TVShowsViewModel(
            service: mockService,
            coordinator: mockCoordinator,
            debounceDelay: .milliseconds(0)
        )
        XCTAssertTrue(viewModel.shows.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    @MainActor
    func testLoadMoreShowsSuccess() async {
        mockService.showsToReturn = TVShow.preview()
        
        let viewModel = TVShowsViewModel(
            service: mockService,
            coordinator: MockCoordinator(),
            debounceDelay: .milliseconds(0)
        )
        
        let showsExpectation = expectation(description: "Load tv shows")
        var shows: [TVShow] = []
        
        viewModel.$shows
            .dropFirst(2)
            .sink { loadedShows in
                shows = loadedShows
                showsExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.refreshShows()
        
        await fulfillment(of: [showsExpectation], timeout: 1.0)
        
        XCTAssertEqual(shows.count, mockService.showsToReturn.count)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    @MainActor
    func testLoadMoreShowsFailure() async {
        mockService.errorToThrow = MockError.test
        
        let viewModel = TVShowsViewModel(
            service: mockService,
            coordinator: MockCoordinator(),
            debounceDelay: .milliseconds(0)
        )
        
        let showsExpectation = expectation(description: "Load tv shows error")
        showsExpectation.assertForOverFulfill = false
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { _ in
                showsExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.refreshShows()
        
        await fulfillment(of: [showsExpectation], timeout: 1.0)
        
        XCTAssertTrue(viewModel.shows.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    @MainActor
    func testSearchShowsSuccess() async {
        let expectation = XCTestExpectation(description: "Debounce expectation")
        let showsExpectation = XCTestExpectation(description: "Load tv shows")
        mockService.showsToReturn = TVShow.preview()

        let viewModel = TVShowsViewModel(
            service: mockService,
            coordinator: mockCoordinator,
            debounceDelay: .milliseconds(0)
        )
        
        viewModel.$searchText
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.$shows
            .dropFirst(2)
            .sink { _ in
                showsExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.searchText = "Query"

        await fulfillment(of: [expectation, showsExpectation], timeout: 1.0)

        XCTAssertEqual(viewModel.shows.count, TVShow.preview().count)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    @MainActor
    func testSelectShowTriggersNavigation() {
        let show = TVShow.preview().first!

        let viewModel = TVShowsViewModel(
            service: mockService,
            coordinator: mockCoordinator,
            debounceDelay: .milliseconds(0)
        )
        
        viewModel.selectTVShow(show)

        XCTAssertEqual(mockCoordinator.pushedPages.count, 1)
    }
}
