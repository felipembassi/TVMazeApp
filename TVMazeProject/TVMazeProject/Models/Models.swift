// Models.swift

import Foundation

struct TVShow: Codable {
    let id: Int
    let url: String
    let name: String
    let genres: [String]
    let runtime, averageRuntime: Int?
    let premiered, ended: String?
    let officialSite: String?
    let schedule: Schedule
    let rating: Rating?
    let image: SeriesImage?
    let summary: String?
    let updated: Int

    var starRating: StarRating {
        StarRating(rating: rating?.average)
    }

    static func preview() -> [TVShow] {
        (1 ... 5).map { seriesIndex in
            TVShow(
                id: seriesIndex,
                url: "https://example.com/series\(seriesIndex)",
                name: "Series \(seriesIndex)",
                genres: ["Drama", "Sci-Fi"],
                runtime: 45,
                averageRuntime: 45,
                premiered: "2021-09-01",
                ended: nil,
                officialSite: "https://example.com/officialSiteSeries\(seriesIndex)",
                schedule: Schedule(time: "21:00", days: [.friday, .saturday]),
                rating: Rating(average: 8.5),
                image: SeriesImage(
                    medium: "https://static.tvmaze.com/uploads/images/medium_portrait/1/4600.jpg",
                    original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4600.jpg"
                ),
                summary: "Summary of Series \(seriesIndex)",
                updated: 1_234_567_890
            )
        }
    }
}

struct Searched: Codable {
    let show: TVShow

    static func preview() -> [Searched] {
        (1 ... 5).compactMap { index in
            Searched(show: TVShow.preview()[index - 1])
        }
    }
}

struct Season: Codable {
    let id: Int
    let name: String

    static func preview() -> [Season] {
        (1 ... 5).compactMap { seasonIndex -> Season in
            Season(
                id: 1000 * seasonIndex,
                name: "Season \(seasonIndex)"
            )
        }
    }
}

struct Episode: Codable {
    let id: Int
    let name: String
    let number: Int
    let season: Int
    let summary: String
    let image: SeriesImage?
    let rating: Rating?

    static func preview() -> [Episode] {
        var mockSeason = 1
        let episodes = (1 ... 22).compactMap { episodeIndex -> Episode in
            let episode = Episode(
                id: 1000 * mockSeason + episodeIndex,
                name: "Episode \(episodeIndex)",
                number: episodeIndex,
                season: mockSeason + 1,
                summary: "Summary of Episode \(episodeIndex) of Season 1",
                image: SeriesImage(
                    medium: "https://static.tvmaze.com/uploads/images/original_untouched/1/4600.jpg",
                    original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4600.jpg"
                ),
                rating: Rating(average: Double(episodeIndex + 7) / 2.0)
            )
            mockSeason += 1
            return episode
        }
        return episodes
    }
}

// MARK: - Schedule

struct Schedule: Codable {
    let time: String
    let days: [Day]
}

enum Day: String, Codable, Hashable {
    case friday = "Friday"
    case monday = "Monday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    case thursday = "Thursday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
}

// MARK: - Rating

struct Rating: Codable {
    let average: Double?
}

// MARK: - Image

struct SeriesImage: Codable {
    let medium, original: String
}

extension TVShow: Hashable {
    static func == (lhs: TVShow, rhs: TVShow) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Season: Hashable {
    static func == (lhs: Season, rhs: Season) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Episode: Hashable {
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct StarRating {
    let fullStars: Int
    let halfStar: Bool
    let emptyStars: Int

    init(rating: Double?) {
        // Assuming the rating is out of 10, adjust to a 5-star scale
        guard let rating = rating else {
            // Handle the nil case
            self.fullStars = 0
            self.halfStar = false
            self.emptyStars = 5
            return
        }

        let validRating = max(0, min(rating, 10))
        let scaledRating = validRating / 2
        self.fullStars = Int(scaledRating)
        self.halfStar = scaledRating.truncatingRemainder(dividingBy: 1) >= 0.5
        self.emptyStars = 5 - fullStars - (halfStar ? 1 : 0)
    }
}
