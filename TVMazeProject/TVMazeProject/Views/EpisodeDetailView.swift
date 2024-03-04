// EpisodeDetailView.swift

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
