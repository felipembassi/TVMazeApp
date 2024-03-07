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
    var rootView: AnyView { get set }
    func push(_ page: Page)
    func build(_ page: Page) -> ContentView
    func pop()
    func popToRoot()
    func determineInitialView()
    func setRootPageHome()
}

final class AppCoordinator: CoordinatorProtocol {
    @Published var path: NavigationPath = NavigationPath()
    @Published var rootPage: Page = .pin {
        didSet {
            rootView = AnyView(build(rootPage))
        }
    }
    @Published var rootView: AnyView

    private var diContainer: AppDIContainer

    init(diContainer: AppDIContainer) {
        self.diContainer = diContainer
        self.rootView = AnyView(Text("Initializing..."))
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
        case .tvShow:
            let viewModel = TVShowsViewModel(service: diContainer.service, coordinator: self)
            TVShowsView(viewModel: viewModel)
        case let .detail(tvShow):
            let viewModel = TVShowDetailViewModel(tvShow: tvShow, service: diContainer.service, coordinator: self)
            TVShowDetailView(viewModel: viewModel)
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

    func determineInitialView() {
        let hasPin = diContainer.keychainService.loadPin() != nil
        rootPage = hasPin ? .pin : .home
    }

    func setRootPageHome() {
        rootPage = .home
    }
}

struct AppCoordinatorView: View {
    @ObservedObject private var coordinator: AppCoordinator

    init(diContainer: AppDIContainer) {
        self.coordinator = AppCoordinator(diContainer: diContainer)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.rootView
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page)
                }
        }
    }
}
