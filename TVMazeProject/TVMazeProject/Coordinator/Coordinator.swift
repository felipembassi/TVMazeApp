// Coordinator.swift

import SwiftUI

enum Page: Hashable {
    case home, settings, pin, tvShow, favorites
    case detail(tvShow: TVShow)
    case episodeDetail(tvShow: TVShow, episode: Episode)
}

@MainActor
protocol CoordinatorProtocol: ObservableObject {
    associatedtype ContentView: View
    var path: NavigationPath { get set }
    var rootPage: Page { get set }
    func push(_ page: Page)
    func build(_ page: Page) -> ContentView
    func pop()
    func popToRoot()
    func determineInitialView()
}

class AppCoordinator: CoordinatorProtocol {
    @Published var path: NavigationPath = NavigationPath()
    @Published var rootPage: Page = .pin

    private var diContainer: AppDependencyContainer

    init(diContainer: AppDependencyContainer) {
        self.diContainer = diContainer
        determineInitialView()
    }

    func push(_ page: Page) {
        path.append(page)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder
    func build(_ page: Page) -> some View {
        switch page {
        case .home:
            let viewModel = HomeViewModel(coordinator: self)
            HomeView(viewModel: viewModel)
        case let .detail(tvShow):
            let viewModel = TVShowDetailViewModel(tvShow: tvShow, service: diContainer.service, coordinator: self)
            TVShowDetailView(viewModel: viewModel)
        case .tvShow:
            let viewModel = TVShowsViewModel(service: diContainer.service, coordinator: self)
            TVShowsView(viewModel: viewModel)
        case let .episodeDetail(tvShow, episode):
            EpisodeDetailView(tvShow: tvShow, episode: episode)
        case .favorites:
            FavoritesView()
        case .settings:
            let viewModel = SettingsViewModel(keychainService: diContainer.keychainService, coordinator: self)
            SettingsView(viewModel: viewModel)
        case .pin:
            let viewModel = PinViewModel(keychainService: diContainer.keychainService, coordinator: self)
            PinView(viewModel: viewModel)
        }
    }

    @ViewBuilder
    func rootView() -> some View {
        switch rootPage {
        case .settings:
            build(.settings)
        case .pin:
            build(.pin)
        case .tvShow:
            build(.tvShow)
        case .favorites:
            build(.favorites)
        case .home:
            build(.home)
        case let .detail(tvShow: tvShow):
            build(.detail(tvShow: tvShow))
        case let .episodeDetail(tvShow: tvShow, episode: episode):
            build(.episodeDetail(tvShow: tvShow, episode: episode))
        }
    }

    func determineInitialView() {
//        let hasPin = diContainer.keychainService.loadPin() != nil
//        rootPage = hasPin ? .pin : .settings
        rootPage = .home
    }
}

struct AppCoordinatorView: View {
    @ObservedObject private var coordinator: AppCoordinator

    init(diContainer: AppDependencyContainer) {
        self.coordinator = AppCoordinator(diContainer: diContainer)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(coordinator.rootPage)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page)
                }
        }
    }
}
