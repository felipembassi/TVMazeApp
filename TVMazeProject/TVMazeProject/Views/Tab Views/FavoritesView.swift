// FavoritesView.swift

import SwiftData
import SwiftUI

@MainActor
struct FavoritesView<ViewModel: FavoritesViewModelProtocol>: View {
    @Environment(\.modelContext) private var modelContainer
    @ObservedObject private(set) var viewModel: ViewModel

    @Query(sort: \TVShow.name) var favorites: [TVShow]
    

    var body: some View {
        NavigationView {
            VStack {
                if favorites.isEmpty {
                    Label(
                        title: { Text("No Favorites yet") },
                        icon: { Image(systemName: "heart.slash.fill") }
                    )
                } else {
                    showsGrid
                }
            }
            .navigationTitle("Favorites")
        }
    }

    @ViewBuilder private var showsGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: .Spacing.l) {
                ForEach(favorites, id: \.self) { tvShow in
                    TVShowCardView(tvshow: tvShow)
                        .onTapGesture {
                            viewModel.selectTVShow(tvShow)
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    final class PreviewFavoritesViewModel: FavoritesViewModelProtocol {
        func selectTVShow(_: TVShow) {}
    }

    let viewModel = PreviewFavoritesViewModel()
    return FavoritesView(viewModel: viewModel)
}
