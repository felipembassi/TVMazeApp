// HomeView.swift

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

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

// #Preview {
//    HomeView(viewModel: HomeViewModel.preview())
//        .modelContainer(for: Item.self, inMemory: true)
// }
