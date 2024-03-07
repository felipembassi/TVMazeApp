// MockCoordinator.swift

import SwiftUI
import XCTest
@testable import TVMazeProject

class MockCoordinator: CoordinatorProtocol {
    typealias ContentView = AnyView

    var path: NavigationPath = NavigationPath()
    var rootPage: Page = .pin
    var pushedPages: [Page] = []
    var popCalled = false
    var popToRootCalled = false
    var initialViewDetermined = false
    var rootView: AnyView = AnyView(Text("testing"))

    func push(_ page: Page) {
        pushedPages.append(page)
    }

    func pop() {
        popCalled = true
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func popToRoot() {
        popToRootCalled = true
        path.removeLast(path.count)
    }

    func build(_: Page) -> ContentView {
        return AnyView(Text("Mock View"))
    }

    func determineInitialView() {
        initialViewDetermined = true
    }

    func setRootPageHome() {
        rootPage = .home
    }
}
