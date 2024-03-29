// TVMazeProjectApp.swift

import SwiftData
import SwiftUI
import UIKit

typealias AppDIContainer = HasAPIKeychainService & HasTVShowsService

final class AppDependencyContainer: ObservableObject, AppDIContainer {
    var keychainService: KeychainServiceProtocol = KeychainService()
    var service: TVShowsServiceProtocol = TVShowsService(networkService: NetworkService())
}

@main
struct TVMazeProjectApp: App {
    private let appDIContainer = AppDependencyContainer()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TVShow.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            #if TEST
            EmptyView()
            #else
            AppCoordinatorView(diContainer: appDIContainer)
            #endif
        }
        .modelContainer(sharedModelContainer)
    }

    init() {
        // Customize search bar cancel button color
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.red
        configureTabBarAppearance()
        configureNavigationBarAppearance()
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()

        // Customize the appearance for the selected state
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(DesignSystem.Colors.foreground)
        appearance.stackedLayoutAppearance.selected
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(DesignSystem.Colors.foreground)]

        // Apply the appearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()

        // Customize appearance for light mode
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground // Or any color you prefer
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label] // Text color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        // Customize appearance for dark mode
        appearance.configureWithDefaultBackground()

        // Set the appearance to the navigation bar
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance // For large titles
        UINavigationBar.appearance().compactAppearance = appearance // For compact navigation bar

        // Set button and item colors
        UINavigationBar.appearance().tintColor = UIColor.systemBlue // Or any color you prefer
    }
}
