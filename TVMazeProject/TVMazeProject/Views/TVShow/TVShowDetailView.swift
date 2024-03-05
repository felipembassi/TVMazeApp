// TVShowDetailView.swift

import SwiftUI

struct TVShowDetailView: View {
    @ObservedObject private var viewModel: TVShowDetailViewModel

    init(viewModel: TVShowDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            seriesHeader
            contentSection
        }
        .onAppear {
            viewModel.fetchSeasonsAndEpisodes()
        }
        .navigationTitle(viewModel.tvShow.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var seriesHeader: some View {
        Section {
            SeriesHeaderView(tvShow: viewModel.tvShow, name: viewModel.tvShow.name)
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
                    EpisodeRow(episode: episode)
                        .onTapGesture {
                            viewModel.selectEpisode(episode)
                        }
                }
            }
        }
    }
}

// #Preview {
//    guard let series = TVShow.preview().first else {
//        return EmptyView()
//    }
//    return TVShowDetailView(viewModel: TVShowDetailViewModel(tvShow: series))
// }
