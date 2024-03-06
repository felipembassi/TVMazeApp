// TVShowDetailViewModel.swift

import Combine
import Foundation

@MainActor
protocol TVShowDetailViewModelProtocol: ObservableObject {
    var seasons: [Season: [Episode]] { get set }
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
    var tvShow: TVShow { get }

    func fetchSeasonsAndEpisodes()
    func selectEpisode(_ episode: Episode)
}

final class TVShowDetailViewModel<Coordinator: CoordinatorProtocol>: TVShowDetailViewModelProtocol {
    @Published var seasons: [Season: [Episode]] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?

    let tvShow: TVShow

    private let service: TVShowsServiceProtocol

    private weak var coordinator: Coordinator?

    init(tvShow: TVShow, service: TVShowsServiceProtocol, coordinator: Coordinator) {
        self.tvShow = tvShow
        self.service = service
        self.coordinator = coordinator
    }

    func fetchSeasonsAndEpisodes() {
        isLoading = true
        errorMessage = nil

        Task { [weak self] in
            guard let self else {
                return
            }
            do {
                let fetchedSeasons = try await service.fetchSeasons(for: tvShow.id)
                var tempSeasons: [Season: [Episode]] = [:]
                
                for season in fetchedSeasons {
                    do {
                        let episodes = try await service.fetchEpisodes(for: season.id)
                        tempSeasons[season] = episodes
                    } catch {
                        print("Error fetching episodes for season \(season.id): \(error)")
                        tempSeasons[season] = []
                    }
                }
                
                seasons = tempSeasons
            } catch {
                errorMessage = "Failed to load seasons: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }

    func selectEpisode(_ episode: Episode) {
        coordinator?.push(.episodeDetail(tvShow: tvShow, episode: episode))
    }
}
