// PinViewModelTests.swift

import XCTest
@testable import TVMazeProject

final class PinViewModelTests: XCTestCase {
    var viewModel: PinViewModel<MockCoordinator>!
    var mockKeychainService: MockKeychainService!
    var mockCoordinator: MockCoordinator!

    @MainActor
    override func setUp() {
        super.setUp()
        mockKeychainService = MockKeychainService()
        mockCoordinator = MockCoordinator()
        viewModel = PinViewModel(keychainService: mockKeychainService, coordinator: mockCoordinator)
    }

    @MainActor
    func testVerifyPinCorrectly() {
        mockKeychainService.pin = "1234"
        viewModel.pin = "1234"

        viewModel.verifyPin()

        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(mockCoordinator.rootPage, .home, "Initial view was not set correctly for user without pin.")
    }

    @MainActor
    func testVerifyPinIncorrectly() {
        mockKeychainService.pin = "1234"
        viewModel.pin = "0000"

        viewModel.verifyPin()

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertNotEqual(mockCoordinator.rootPage, .home, "Initial view was not set correctly for user without pin.")
    }
}
