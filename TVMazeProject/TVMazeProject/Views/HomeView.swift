// HomeView.swift

import SwiftUI

struct HomeView<ViewModel: HomeViewModelProtocol>: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        TabView {
            viewModel.startTVShowCoordinator()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            viewModel.startFavoritesCoordinator()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            viewModel.startSettingsCoordinator()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .background(DesignSystem.Colors.background)
        .edgesIgnoringSafeArea(.all)
        .foregroundStyle(DesignSystem.Colors.foreground)
    }
}

#Preview {
    class PreviewHomeViewModel: HomeViewModelProtocol {
        func startTVShowCoordinator() -> AnyView {
            AnyView(EmptyView())
        }

        func startFavoritesCoordinator() -> AnyView {
            AnyView(EmptyView())
        }

        func startSettingsCoordinator() -> AnyView {
            AnyView(EmptyView())
        }
    }
    let viewModel = PreviewHomeViewModel()
    return HomeView(viewModel: viewModel)
        .modelContainer(for: Item.self, inMemory: true)
}
