//
//  EpisodeDetailView.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 03/03/24.
//

import SwiftUI

struct EpisodeDetailView: View {
    let series: TVShow
    let episode: Episode
    
    var body: some View {
        ScrollView {
            SeriesHeaderView(series: series, name: episode.name)
            .padding()
        }
        .navigationTitle("\(series.name) - S\(episode.season)E\(episode.number)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    if let series = TVShow.preview().first, let episode = Episode.preview().first {
        EpisodeDetailView(series: series, episode: episode)
    } else {
        EmptyView()
    }
}
