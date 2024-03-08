// TVShowCardView.swift

import SwiftUI

struct TVShowCardView: View {
    var tvshow: TVShow
    
    private let imageWidth: CGFloat = 150
    private let imageHeight: CGFloat = 200

    var body: some View {
        VStack {
            CustomAsyncImage(urlString: tvshow.image?.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: imageWidth, height: imageHeight)
                .cornerRadius(.Spacing.s)

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
    return TVShowCardView(tvshow: series)
}
