// APIEndpoints.swift

enum APIEndpoints {
    static let baseURL = "https://api.tvmaze.com"

    case shows(page: Int)
    case search(query: String)
    case seasons(tvShow: Int)
    case episodes(season: Int)
    case person(page: Int)
    case castcredits(person: Int)
    case searchPerson(query: String)

    var urlString: String {
        switch self {
        case let .shows(page):
            return "\(APIEndpoints.baseURL)/shows?page=\(page)"
        case let .search(query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(APIEndpoints.baseURL)/search/shows?q=\(encodedQuery)"
        case let .seasons(tvShow):
            return "\(APIEndpoints.baseURL)/shows/\(tvShow)/seasons"
        case let .episodes(season):
            return "\(APIEndpoints.baseURL)/seasons/\(season)/episodes"
        case let .person(page):
            return "\(APIEndpoints.baseURL)/people?page=\(page)"
        case let .castcredits(person):
            return "\(APIEndpoints.baseURL)/people/\(person)/castcredits?embed=show"
        case let .searchPerson(query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(APIEndpoints.baseURL)/search/people?q=\(encodedQuery)"
        }
    }
}
