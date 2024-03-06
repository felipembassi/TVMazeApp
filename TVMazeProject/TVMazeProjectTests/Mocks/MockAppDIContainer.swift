// MockAppDIContainer.swift

import Foundation
@testable import TVMazeProject

final class MockAppDependencyContainer: ObservableObject, AppDIContainer {
    var keychainService: KeychainServiceProtocol
    var service: TVShowsServiceProtocol

    init(
        keychainService: KeychainServiceProtocol = MockKeychainService(),
        service: TVShowsServiceProtocol = MockTVShowsService()
    ) {
        self.keychainService = keychainService
        self.service = service
    }
}
