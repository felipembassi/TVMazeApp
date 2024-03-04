//
//  SeriesDetailView.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 03/03/24.
//

import SwiftUI

struct TVShowDetailView: View {
    @StateObject private var viewModel: TVShowDetailViewModel
    let tvShow: TVShow
    
    init(tvShow: TVShow, service: TVShowsServiceProtocol = TVShowsService()) {
        self.tvShow = tvShow
        _viewModel = StateObject(wrappedValue: TVShowDetailViewModel(tvShowID: tvShow.id, service: service))
    }
    
    var body: some View {
        List {
            Section {
                SeriesHeaderView(series: tvShow, name: tvShow.name)
            }

            if viewModel.isLoading {
                Section { Text("Loading...") }
            } else if let errorMessage = viewModel.errorMessage {
                Section { Text(errorMessage) }
            } else {
                ForEach(Array(viewModel.seasons.keys).sorted(by: { $0.id < $1.id }), id: \.self) { season in
                    Section {
                        if let episodes = viewModel.seasons[season] {
                            ForEach(episodes, id: \.self) { episode in
                                NavigationLink(destination: EpisodeDetailView(series: tvShow, episode: episode)) {
                                    EpisodeRow(episode: episode)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchSeasonsAndEpisodes()
        }
        .navigationTitle(tvShow.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    guard let series = TVShow.preview().first else {
        return EmptyView()
    }
    return TVShowDetailView(tvShow: series)
}
