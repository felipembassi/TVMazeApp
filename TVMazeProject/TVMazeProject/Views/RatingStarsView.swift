// RatingStarsView.swift

import SwiftUI

struct RatingStarsView: View {
    let starRating: StarRating

    var body: some View {
        HStack {
            ForEach(0 ..< starRating.fullStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            if starRating.halfStar {
                Image(systemName: "star.leadinghalf.filled")
                    .foregroundColor(.yellow)
            }
            ForEach(0 ..< starRating.emptyStars, id: \.self) { _ in
                Image(systemName: "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    RatingStarsView(starRating: StarRating(rating: 5))
}
