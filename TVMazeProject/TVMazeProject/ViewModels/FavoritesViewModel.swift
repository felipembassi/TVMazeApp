// FavoritesViewModel.swift

import Combine
import SwiftData
import SwiftUI

@MainActor
protocol FavoritesViewModelProtocol: ObservableObject {
    func selectTVShow(_ tvShow: TVShow)
}

final class FavoritesViewModel<Coordinator: CoordinatorProtocol>: FavoritesViewModelProtocol {
    private weak var coordinator: Coordinator?

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func selectTVShow(_ tvShow: TVShow) {
        coordinator?.push(.detail(tvShow: tvShow))
    }
}
