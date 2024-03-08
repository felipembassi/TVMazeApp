//
//  PersonViewModel.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 07/03/24.
//

import Combine
import Foundation

@MainActor
protocol PersonViewModelProtocol: ObservableObject {
    var persons: [Person] { get set }
    var isLoading: Bool { get set }
    var searchText: String { get set }
    var errorMessage: String? { get set }
    func refreshPersons()
    func selectPerson(_ person: Person)
    func loadDataIfNeeded(currentItem: Person?)
}

final class PersonViewModel<Coordinator: CoordinatorProtocol>: PersonViewModelProtocol {
    @Published var persons: [Person] = []
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
        loadPersons()
    }

    func refreshPersons() {
        currentPage = 0
        persons = []
        loadPersons()
    }
    
    func selectPerson(_ person: Person) {
        coordinator?.push(.personDetail(person: person))
    }
    
    private func addSubscribers(debounceDelay: DispatchQueue.SchedulerTimeType.Stride) {
        $searchText
            .dropFirst()
            .removeDuplicates()
            .debounce(for: debounceDelay, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.searchPersonsDebounced(query: searchText)
            }
            .store(in: &cancellables)
    }

    private func searchPersonsDebounced(query: String) {
        searchTask?.cancel()
        loadingTask?.cancel()
        guard !query.isEmpty else {
            refreshPersons()
            return
        }

        isLoading = true
        persons = []

        searchTask = Task {
            do {
                let searchResults = try await service.searchPerson(query: query)
                persons = searchResults
                errorMessage = nil
            } catch {
                errorMessage = "Failed to load search results: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }

    private func loadPersons() {
        loadingTask?.cancel()
        loadingTask = Task { [weak self] in
            guard let self else { return }
            for await newPersons in fetchDataStream() {
                persons.append(contentsOf: newPersons)
            }
        }
    }
    
    private func fetchDataStream() -> AsyncStream<[Person]> {
        AsyncStream { continuation in
            Task { [weak self] in
                guard let self else {
                    continuation.finish()
                    return
                }
                do {
                    let persons = try await service.fetchPerson(for: currentPage)
                    try Task.checkCancellation()
                    
                    currentPage += 1
                    errorMessage = nil
                    continuation.yield(persons)
                    continuation.finish()
                } catch {
                    errorMessage = error.localizedDescription
                    continuation.finish()
                }
            }
        }
    }
    
    func loadDataIfNeeded(currentItem: Person?) {
        guard let currentItem = currentItem,
              let itemIndex = persons.firstIndex(of: currentItem),
              !isLoading
        else { return }
        
        let prefetchThresholdPercentage = 0.70
        let thresholdIndex = Int(Double(persons.count) * prefetchThresholdPercentage)
        
        if itemIndex >= thresholdIndex {
            loadPersons()
        }
    }
    
    deinit {
        searchTask?.cancel()
        cancellables.forEach { $0.cancel() }
    }
}
