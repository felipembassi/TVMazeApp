// SeriesHeaderView.swift

import SwiftUI

struct SeriesHeaderView: View {
    var series: TVShow
    var name: String

    var body: some View {
        AsyncImage(url: URL(string: series.image.original)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .aspectRatio(contentMode: .fit)
        .listRowInsets(EdgeInsets())
        .frame(maxWidth: .infinity)

        Text(name)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(DesignSystem.Colors.foreground)

        // Air Time
        AiringScheduleView(schedule: series.schedule)

        HStack {
            ForEach(series.genres, id: \.self) { genre in
                Text(genre)
                    .padding(5)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .foregroundColor(DesignSystem.Colors.foreground)
            }
        }

        Text(series.summary ?? "N/A")
            .font(.body)
            .foregroundColor(DesignSystem.Colors.foreground)
    }
}

#Preview {
    guard let series = TVShow.preview().first else {
        return EmptyView()
    }
    return SeriesHeaderView(series: series, name: "Episode")
}
