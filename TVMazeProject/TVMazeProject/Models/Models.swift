// Models.swift

import Foundation
import SwiftData

@Model
final class TVShow: Codable {
    enum CodingKeys: CodingKey {
        case id
        case url
        case name
        case genres
        case schedule
        case rating
        case image
        case summary
    }

    let id: Int
    let url: String
    let name: String
    let genres: [String]
    let schedule: Schedule
    let rating: Rating?
    let image: SeriesImage?
    let summary: String?

    var starRating: StarRating {
        StarRating(rating: rating?.average)
    }

    init(
        id: Int,
        url: String,
        name: String,
        genres: [String],
        schedule: Schedule,
        rating: Rating? = nil,
        image: SeriesImage? = nil,
        summary: String? = nil
    ) {
        self.id = id
        self.url = url
        self.name = name
        self.genres = genres
        self.schedule = schedule
        self.rating = rating
        self.image = image
        self.summary = summary
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.url = try container.decode(String.self, forKey: .url)
        self.name = try container.decode(String.self, forKey: .name)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.schedule = try container.decode(Schedule.self, forKey: .schedule)
        self.rating = try container.decode(Rating.self, forKey: .rating)
        self.image = try container.decode(SeriesImage.self, forKey: .image)
        self.summary = try container.decode(String.self, forKey: .summary)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(name, forKey: .name)
        try container.encode(genres, forKey: .genres)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(rating, forKey: .rating)
        try container.encode(image, forKey: .image)
        try container.encode(summary, forKey: .summary)
    }

    static func preview() -> [TVShow] {
        (1 ... 5).map { seriesIndex in
            TVShow(
                id: seriesIndex,
                url: "https://example.com/series\(seriesIndex)",
                name: "Series \(seriesIndex)",
                genres: ["Action", "Adventure", "Fantasy"],
                schedule: Schedule(time: "21:00", days: [.friday, .saturday]),
                rating: Rating(average: 10),
                image: SeriesImage(
                    medium: "https://static.tvmaze.com/uploads/images/medium_portrait/504/1262497.jpg",
                    original: "https://static.tvmaze.com/uploads/images/original_untouched/504/1262497.jpg"
                ),
                summary: "Summary of Series \(seriesIndex)"
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
    let number: Int?
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
                    medium: "https://static.tvmaze.com/uploads/images/medium_landscape/293/734143.jpg",
                    original: "https://static.tvmaze.com/uploads/images/original_untouched/293/734143.jpg"
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

// MARK: - Person

struct SearchedPerson: Codable {
    let person: Person
}

struct Person: Codable {
    let id: Int
    let name: String
    let image: SeriesImage?

    static func preview() -> [Person] {
        [
            Person(
                id: 5453,
                name: "Bryan McClure",
                image: SeriesImage(
                    medium: "https://static.tvmaze.com/uploads/images/medium_portrait/189/474940.jpg",
                    original: "https://static.tvmaze.com/uploads/images/original_untouched/189/474940.jpg"
                )
            ),
            Person(
                id: 14245,
                name: "Bryan Cranston",
                image: SeriesImage(
                    medium: "https://static.tvmaze.com/uploads/images/medium_portrait/195/488839.jpg",
                    original: "https://static.tvmaze.com/uploads/images/original_untouched/195/488839.jpg"
                )
            )
        ]
    }
}

struct CastCredit: Codable {
    let embedded: Embedded

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct Embedded: Codable {
    let show: TVShow
}

// MARK: - extensions

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

extension Person: Hashable {
    static func == (lhs: Person, rhs: Person) -> Bool {
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
