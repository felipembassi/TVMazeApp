// EpisodeRowView.swift

import SwiftUI

struct EpisodeRowView: View {
    let episode: Episode

    var body: some View {
        HStack {
            CustomAsyncImage(urlString: episode.image?.medium)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text(episode.name)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.foreground)
                Text("Season \(episode.season)" + (episode.number != nil ? ", Episode \(episode.number!)" : ""))
                    .font(.subheadline)
                    .foregroundColor(DesignSystem.Colors.foreground)
            }
        }
    }
}

#Preview {
    if let episode = Episode.preview().first {
        return EpisodeRowView(episode: episode)
    } else {
        return EmptyView()
    }
}
