// TVShowDetailView.swift

import SwiftUI

struct TVShowDetailView<ViewModel: TVShowDetailViewModelProtocol>: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        List {
            seriesHeader
            contentSection
        }
        .navigationTitle(viewModel.tvShow.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var seriesHeader: some View {
        Section {
            SeriesHeaderView(tvShow: viewModel.tvShow, name: viewModel.tvShow.name, image: viewModel.tvShow.image?.original)
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
