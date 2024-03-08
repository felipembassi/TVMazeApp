// RatingStarsView.swift

import SwiftUI

struct RatingStarsView: View {
    let starRating: StarRating

    var body: some View {
        HStack {
            ForEach(.zero ..< starRating.fullStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            if starRating.halfStar {
                Image(systemName: "star.leadinghalf.filled")
                    .foregroundColor(.yellow)
            }
            ForEach(.zero ..< starRating.emptyStars, id: \.self) { _ in
                Image(systemName: "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    RatingStarsView(starRating: StarRating(rating: 5))
}
