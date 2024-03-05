// TVShowDetailViewModel.swift

import Combine
import Foundation

@MainActor
protocol TVShowDetailViewModelProtocol: AnyObject, ObservableObject {
    var seasons: [Season: [Episode]] { get set }
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
    var tvShow: TVShow { get }

    func fetchSeasonsAndEpisodes()
    func selectEpisode(_ episode: Episode)
}

class TVShowDetailViewModel: TVShowDetailViewModelProtocol {
    @Published var seasons: [Season: [Episode]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?

    let tvShow: TVShow

    private let service: TVShowsServiceProtocol

    private weak var coordinator: AppCoordinator?

    init(tvShow: TVShow, service: TVShowsServiceProtocol, coordinator: AppCoordinator) {
        self.tvShow = tvShow
        self.service = service
        self.coordinator = coordinator
    }

    func fetchSeasonsAndEpisodes() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedSeasons = try await service.fetchSeasons(for: tvShow.id)
                var tempSeasons: [Season: [Episode]] = [:]

                for season in fetchedSeasons {
                    do {
                        let episodes = try await service.fetchEpisodes(for: season.id)
                        tempSeasons[season] = episodes
                    } catch {
                        // Handle or log episode fetch error
                        print("Error fetching episodes for season \(season.id): \(error)")
                        tempSeasons[season] = []
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

    func selectEpisode(_ episode: Episode) {
        coordinator?.push(.episodeDetail(tvShow: tvShow, episode: episode))
    }
}
