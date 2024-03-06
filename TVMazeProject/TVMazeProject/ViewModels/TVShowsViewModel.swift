// TVShowsViewModel.swift

import Combine
import Foundation
import SwiftUI

@MainActor
protocol TVShowsViewModelProtocol: ObservableObject {
    var shows: [TVShow] { get set }
    var isLoading: Bool { get set }
    var searchText: String { get set }
    var errorMessage: String? { get set }
    func loadMoreContentIfNeeded(currentItem show: TVShow?)
    func refreshShows()
    func selectTVShow(_ tvShow: TVShow)
}

final class TVShowsViewModel<Coordinator: CoordinatorProtocol>: TVShowsViewModelProtocol {
    @Published var shows: [TVShow] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""

    private weak var coordinator: Coordinator?
    private var currentPage = 0
    private var subscriptions = Set<AnyCancellable>()
    private let service: TVShowsServiceProtocol

    init(
        service: TVShowsServiceProtocol,
        coordinator: Coordinator,
        debounceDelay: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(500)
    ) {
        self.service = service
        self.coordinator = coordinator
        addSubscribers(debounceDelay: debounceDelay)
    }

    private func addSubscribers(debounceDelay: DispatchQueue.SchedulerTimeType.Stride) {
        $searchText
            .removeDuplicates()
            .debounce(for: debounceDelay, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.searchShowsDebounced(query: searchText)
            }
            .store(in: &subscriptions)
    }

    private func searchShowsDebounced(query: String) {
        guard !query.isEmpty else {
            refreshShows()
            return
        }

        isLoading = true
        shows = []

        Task {
            do {
                let searchResults = try await service.searchShows(query: query)
                shows = searchResults
                errorMessage = nil
            } catch {
                errorMessage = "Failed to load search results: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }

    func loadMoreContentIfNeeded(currentItem show: TVShow?) {
        guard !isLoading, let show = show,
              let thresholdIndex = shows.index(shows.endIndex, offsetBy: -10, limitedBy: shows.startIndex) else {
            return
        }

        if shows.firstIndex(where: { $0.id == show.id }) ?? 0 >= thresholdIndex {
            loadMoreShows()
        }
    }

    func refreshShows() {
        currentPage = 0
        shows = []
        loadMoreShows()
    }

    private func loadMoreShows() {
        guard !isLoading && searchText.isEmpty else { return }
        isLoading = true

        Task {
            do {
                let newShows = try await service.fetchShows(page: currentPage)
                if !newShows.isEmpty {
                    shows.append(contentsOf: newShows)
                    currentPage += 1
                    errorMessage = nil
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func selectTVShow(_ tvShow: TVShow) {
        coordinator?.push(.detail(tvShow: tvShow))
    }
}
