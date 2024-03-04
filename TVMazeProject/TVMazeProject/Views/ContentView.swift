// ContentView.swift

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TVShowsView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }

            SettingsView()
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
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
