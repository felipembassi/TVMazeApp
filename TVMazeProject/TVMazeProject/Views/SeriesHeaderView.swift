// SeriesHeaderView.swift

import SwiftUI

struct SeriesHeaderView: View {
    // This should be a SeriesHeaderView ViewModel instead
    var tvShow: TVShow
    var name: String
    var image: String?

    var body: some View {
        CustomAsyncImage(urlString: image)
            .aspectRatio(contentMode: .fit)
            .listRowInsets(EdgeInsets())
            .frame(maxWidth: .infinity)

        Text(name)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(DesignSystem.Colors.foreground)

        AiringScheduleView(schedule: tvShow.schedule)

        HStack {
            ForEach(tvShow.genres, id: \.self) { genre in
                Text(genre)
                    .padding(.Spacing.ss)
                    .background(DesignSystem.Colors.boxBackground)
                    .cornerRadius(.Spacing.ss)
                    .foregroundColor(DesignSystem.Colors.foreground)
            }
        }

        Text(tvShow.summary ?? "N/A")
            .font(.body)
            .foregroundColor(DesignSystem.Colors.foreground)
    }
}

#Preview {
    guard let tvShow = TVShow.preview().first else {
        return EmptyView()
    }
    return SeriesHeaderView(tvShow: tvShow, name: "Episode", image: tvShow.image?.original)
}
