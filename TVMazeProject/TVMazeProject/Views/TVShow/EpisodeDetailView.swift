// EpisodeDetailView.swift

import SwiftUI

struct EpisodeDetailView: View {
    let tvShow: TVShow
    let episode: Episode

    var body: some View {
        ScrollView {
            SeriesHeaderView(tvShow: tvShow, name: episode.name, image: episode.image?.original)
                .padding()
        }
        .navigationTitle(episode.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    if let series = TVShow.preview().first, let episode = Episode.preview().first {
        EpisodeDetailView(tvShow: series, episode: episode)
    } else {
        EmptyView()
    }
}
