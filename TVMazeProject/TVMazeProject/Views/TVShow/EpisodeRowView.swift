// EpisodeRowView.swift

import SwiftUI

struct EpisodeRowView: View {
    let episode: Episode
    
    private let imageSize: CGFloat = 50

    var body: some View {
        HStack {
            CustomAsyncImage(urlString: episode.image?.medium)
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: .Spacing.s))
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
