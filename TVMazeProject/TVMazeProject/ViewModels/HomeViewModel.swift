// HomeViewModel.swift

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    private weak var coordinator: AppCoordinator?

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func startTVShowCoordinator() -> some View {
        coordinator?.build(.tvShow)
    }

    func startFavoritesCoordinator() -> some View {
        coordinator?.build(.favorites)
    }

    func startSettingsCoordinator() -> some View {
        coordinator?.build(.settings)
    }
}
