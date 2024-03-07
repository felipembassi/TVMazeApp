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
    func refreshShows()
    func selectTVShow(_ tvShow: TVShow)
    func loadDataIfNeeded(currentItem: TVShow?)
}

final class TVShowsViewModel<Coordinator: CoordinatorProtocol>: TVShowsViewModelProtocol {
    @Published var shows: [TVShow] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String

    private weak var coordinator: Coordinator?
    private var currentPage = 0
    private var cancellables = Set<AnyCancellable>()
    private let service: TVShowsServiceProtocol
    private var searchTask: Task<Void, Error>?
    private var loadingTask: Task<Void, Error>?

    init(
        service: TVShowsServiceProtocol,
        coordinator: Coordinator,
        debounceDelay: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(500)
    ) {
        self.service = service
        self.coordinator = coordinator
        self.searchText = ""
        addSubscribers(debounceDelay: debounceDelay)
        loadMoreShows()
    }

    func refreshShows() {
        currentPage = 0
        shows = []
        loadMoreShows()
    }
    
    func selectTVShow(_ tvShow: TVShow) {
        coordinator?.push(.detail(tvShow: tvShow))
    }
    
    private func addSubscribers(debounceDelay: DispatchQueue.SchedulerTimeType.Stride) {
        $searchText
            .dropFirst()
            .removeDuplicates()
            .debounce(for: debounceDelay, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.searchShowsDebounced(query: searchText)
            }
            .store(in: &cancellables)
    }

    private func searchShowsDebounced(query: String) {
        searchTask?.cancel()
        loadingTask?.cancel()
        guard !query.isEmpty else {
            refreshShows()
            return
        }

        isLoading = true
        shows = []

        searchTask = Task {
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

    private func loadMoreShows() {
        loadingTask?.cancel()
        loadingTask = Task { [weak self] in
            guard let self else { return }
            for await tvShows in fetchDataStream() {
                shows.append(contentsOf: tvShows)
            }
        }
    }
    
    private func fetchDataStream() -> AsyncStream<[TVShow]> {
        AsyncStream { continuation in
            Task { [weak self] in
                guard let self else {
                    continuation.finish()
                    return
                }
                do {
                    let newShows = try await service.fetchShows(page: currentPage)
                    try Task.checkCancellation()
                    
                    currentPage += 1
                    errorMessage = nil
                    continuation.yield(newShows)
                    continuation.finish()
                } catch {
                    errorMessage = error.localizedDescription
                    continuation.finish()
                }
            }
        }
    }
    
    func loadDataIfNeeded(currentItem: TVShow?) {
        guard let currentItem = currentItem,
              let itemIndex = shows.firstIndex(of: currentItem),
              !isLoading
        else { return }
        
        let prefetchThresholdPercentage = 0.70
        let thresholdIndex = Int(Double(shows.count) * prefetchThresholdPercentage)
        
        if itemIndex >= thresholdIndex {
            loadMoreShows()
        }
    }
    
    deinit {
        searchTask?.cancel()
        cancellables.forEach { $0.cancel() }
    }
}
