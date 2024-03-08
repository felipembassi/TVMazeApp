// HomeViewModel.swift

import SwiftUI

@MainActor
protocol HomeViewModelProtocol: ObservableObject {
    func startTVShowCoordinator() -> AnyView
    func startFavoritesCoordinator() -> AnyView
    func startSettingsCoordinator() -> AnyView
    func startPersonsCoordinator() -> AnyView
}

final class HomeViewModel<Coordinator: CoordinatorProtocol>: HomeViewModelProtocol {
    private weak var coordinator: Coordinator?

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    @ViewBuilder
    func startTVShowCoordinator() -> AnyView {
        AnyView(coordinator?.build(.tvShow))
    }

    @ViewBuilder
    func startFavoritesCoordinator() -> AnyView {
        AnyView(coordinator?.build(.favorites))
    }

    @ViewBuilder
    func startPersonsCoordinator() -> AnyView {
        AnyView(coordinator?.build(.persons))
    }

    @ViewBuilder
    func startSettingsCoordinator() -> AnyView {
        AnyView(coordinator?.build(.settings))
    }
}
