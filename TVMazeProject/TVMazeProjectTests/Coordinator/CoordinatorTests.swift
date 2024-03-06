// CoordinatorTests.swift

import XCTest
@testable import TVMazeProject

final class CoordinatorTests: XCTestCase {
    var coordinator: (any CoordinatorProtocol)!
    var mockDIContainer: MockAppDependencyContainer!

    @MainActor
    override func setUpWithError() throws {
        mockDIContainer = MockAppDependencyContainer()
        coordinator = AppCoordinator(diContainer: mockDIContainer)
    }

    override func tearDownWithError() throws {
        coordinator = nil
        mockDIContainer = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testBuildFunction() {
        let resultView = coordinator.build(.home)
        XCTAssertNotNil(resultView, "Build home not returned a View.")
    }

    @MainActor
    func testPushFunctionUpdatesPathCorrectly() {
        let initialCount = coordinator.path.count
        coordinator.push(.home)
        XCTAssertEqual(coordinator.path.count, initialCount + 1, "Push did not add view to path.")
    }

    @MainActor
    func testPopFunctionUpdatesPathCorrectly() {
        coordinator.push(.home)
        let initialCount = coordinator.path.count
        coordinator.pop()
        XCTAssertEqual(coordinator.path.count, initialCount - 1, "Pop did not remove view from path.")
    }

    @MainActor
    func testPopToRootFunctionResetsPathCorrectly() {
        coordinator.push(.home)
        coordinator.push(.settings)
        coordinator.push(.favorites)
        XCTAssertNotEqual(coordinator.path.count, 0, "push did not increment path.")
        coordinator.popToRoot()
        XCTAssertEqual(coordinator.path.count, 0, "PopToRoot did not reset path to root view.")
    }

    @MainActor
    func testSetRootPageHomeSetsRootPageCorrectly() {
        coordinator.setRootPageHome()
        XCTAssertEqual(coordinator.rootPage, .home, "rootPage was not set to home.")
    }

    @MainActor
    func testDetermineInitialViewForAuthenticatedUser() {
        mockDIContainer.keychainService.savePin("1234")
        coordinator.determineInitialView()
        XCTAssertEqual(coordinator.rootPage, .pin, "Initial view was not set correctly for user with pin.")
    }

    @MainActor
    func testDetermineInitialViewForUnauthenticatedUser() {
        mockDIContainer.keychainService.deletePin()
        coordinator.determineInitialView()
        XCTAssertEqual(coordinator.rootPage, .settings, "Initial view was not set correctly for user without pin.")
    }
}
