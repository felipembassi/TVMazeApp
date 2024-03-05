// TVShowCard.swift

import SwiftUI

struct TVShowCard: View {
    var tvshow: TVShow

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: tvshow.image.original)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 200)
            .cornerRadius(10)

            Text(tvshow.name)
                .fontWeight(.medium)
                .lineLimit(1)
                .foregroundColor(DesignSystem.Colors.foreground)

            RatingStarsView(starRating: tvshow.starRating)
        }
    }
}

#Preview {
    guard let series = TVShow.preview().first else {
        return EmptyView()
    }
    return TVShowCard(tvshow: series)
}
