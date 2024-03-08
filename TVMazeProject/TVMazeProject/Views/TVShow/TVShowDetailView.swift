// TVShowDetailView.swift

import SwiftUI
import SwiftData

struct TVShowDetailView<ViewModel: TVShowDetailViewModelProtocol>: View {
    @Environment(\.modelContext) private var modelContainer
    @ObservedObject private(set) var viewModel: ViewModel

    @Query var favorites: [TVShow]
    
    private var isFavorite: Bool {
        favorites.contains(viewModel.tvShow)
    }
    
    var body: some View {
        List {
            seriesHeader
            contentSection
        }
        .navigationTitle(viewModel.tvShow.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    var seriesHeader: some View {
        Section {
            SeriesHeaderView(tvShow: viewModel.tvShow, name: viewModel.tvShow.name, image: viewModel.tvShow.image?.original)

            Button(action: toggleFavorite) {
                HStack {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                    Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        .foregroundColor(.primary)
                }
            }
        }
    }

    @ViewBuilder private var contentSection: some View {
        if viewModel.isLoading {
            Section { Text("Loading...") }
        } else if let errorMessage = viewModel.errorMessage {
            Section { Text(errorMessage) }
        } else {
            seasonsList
        }
    }

    @ViewBuilder private var seasonsList: some View {
        ForEach(sortedSeasons, id: \.self) { season in
            seasonSection(season)
        }
    }

    private var sortedSeasons: [Season] {
        Array(viewModel.seasons.keys).sorted(by: { $0.id < $1.id })
    }

    @ViewBuilder
    private func seasonSection(_ season: Season) -> some View {
        Section {
            if let episodes = viewModel.seasons[season] {
                ForEach(episodes, id: \.self) { episode in
                    EpisodeRowView(episode: episode)
                        .onTapGesture {
                            viewModel.selectEpisode(episode)
                        }
                }
            }
        }
    }
    
    private func toggleFavorite() {
        isFavorite ? modelContainer.delete(viewModel.tvShow) : modelContainer.insert(viewModel.tvShow)
    }
}

#Preview {
    final class PreviewTVShowDetailViewModel: TVShowDetailViewModelProtocol {
        var seasons: [Season: [Episode]] = [Season.preview().first!: Episode.preview()]
        var isLoading: Bool = false
        var errorMessage: String?
        var tvShow: TVShow = TVShow.preview().first!
        func fetchSeasonsAndEpisodes() {}
        func selectEpisode(_: Episode) {}
    }

    let viewModel = PreviewTVShowDetailViewModel()
    return TVShowDetailView(viewModel: viewModel)
}
