//
//  PersonDetailViewModel.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 07/03/24.
//

import Foundation

@MainActor
protocol PersonDetailViewModelProtocol: ObservableObject {
    var person: Person { get }
    var tvShows: [TVShow] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get set }
    func fetchPersonDetails()
    func selectTVShow(_ tvShow: TVShow)
}

import Combine

class PersonDetailViewModel<Coordinator: CoordinatorProtocol>: PersonDetailViewModelProtocol {
    @Published var person: Person
    @Published var tvShows: [TVShow] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: TVShowsServiceProtocol
    private weak var coordinator: Coordinator?
    
    init(person: Person, service: TVShowsServiceProtocol, coordinator: Coordinator) {
        self.person = person
        self.service = service
        self.coordinator = coordinator
        fetchPersonDetails()
    }
    
    func fetchPersonDetails() {
        isLoading = true
        errorMessage = nil

        Task { [weak self] in
            guard let self else {
                return
            }
            do {
                tvShows = try await service.fetchCastCredits(for: person.id).compactMap{$0.embedded.show}
            } catch {
                errorMessage = "Failed to load seasons: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    func selectTVShow(_ tvShow: TVShow) {
        coordinator?.push(.detail(tvShow: tvShow))
    }
}
