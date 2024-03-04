//
//  APIEndpoints.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 03/03/24.
//

enum APIEndpoints {
    static let baseURL = "https://api.tvmaze.com"

    case shows(page: Int)
    case search(query: String)
    case seasons(tvShow: Int)
    case episodes(season: Int)
    
    var urlString: String {
        switch self {
        case .shows(let page):
            return "\(APIEndpoints.baseURL)/shows?page=\(page)"
        case .search(let query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "\(APIEndpoints.baseURL)/search/shows?q=\(encodedQuery)"
        case .seasons(let tvShow):
            return "\(APIEndpoints.baseURL)/shows/\(tvShow)/seasons"
        case .episodes(let season):
            return "\(APIEndpoints.baseURL)/seasons/\(season)/episodes"
        }
    }
}
