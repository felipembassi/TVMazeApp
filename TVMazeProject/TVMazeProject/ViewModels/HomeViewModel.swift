// HomeViewModel.swift

import SwiftUI

@MainActor
protocol HomeViewModelProtocol: ObservableObject {
    func startTVShowCoordinator() -> AnyView
    func startFavoritesCoordinator() -> AnyView
    func startSettingsCoordinator() -> AnyView
}

final class HomeViewModel: HomeViewModelProtocol {
    private weak var coordinator: AppCoordinator?

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func startTVShowCoordinator() -> AnyView {
        AnyView(coordinator?.build(.tvShow))
    }

    func startFavoritesCoordinator() -> AnyView {
        AnyView(coordinator?.build(.favorites))
    }

    func startSettingsCoordinator() -> AnyView {
        AnyView(coordinator?.build(.settings))
    }
}
