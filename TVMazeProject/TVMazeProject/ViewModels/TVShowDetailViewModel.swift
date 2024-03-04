//
//  TVShowDetailViewModel.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 04/03/24.
//

import Combine
import Foundation

@MainActor
class TVShowDetailViewModel: ObservableObject {
    @Published var seasons: [Season: [Episode]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let tvShowID: Int
    private let service: TVShowsServiceProtocol

    init(tvShowID: Int, service: TVShowsServiceProtocol) {
        self.tvShowID = tvShowID
        self.service = service
    }

    func fetchSeasonsAndEpisodes() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedSeasons = try await service.fetchSeasons(for: tvShowID)
                var tempSeasons: [Season: [Episode]] = [:]

                for season in fetchedSeasons {
                    do {
                        let episodes = try await service.fetchEpisodes(for: season.id)
                        tempSeasons[season] = episodes
                    } catch {
                        // Handle or log episode fetch error
                        print("Error fetching episodes for season \(season.id): \(error)")
                        tempSeasons[season] = [] // Consider storing an empty array or nil if that's more appropriate for your UI.
                    }
                }

                await MainActor.run {
                    self.seasons = tempSeasons
                }
            } catch {
                self.errorMessage = "Failed to load seasons: \(error.localizedDescription)"
            }
            self.isLoading = false
        }
    }
}
