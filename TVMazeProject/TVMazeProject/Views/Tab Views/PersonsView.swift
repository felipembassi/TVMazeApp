//
//  PersonsView.swift
//  TVMazeProject
//
//  Created by Felipe Moreira Tarrio Bassi on 07/03/24.
//

import SwiftUI

struct PersonsView<ViewModel: PersonViewModelProtocol>: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.persons.isEmpty {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        CustomButton(title: "Reload", systemImage: "arrow.clockwise") {
                            viewModel.refreshPersons()
                        }
                    }
                    .padding(24)
                } else {
                    showsGrid
                }
            }
            .searchable(text: $viewModel.searchText)
            .refreshable {
                viewModel.refreshPersons()
            }
            .navigationTitle("Persons")
        }
    }
    
    @ViewBuilder private var showsGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.persons, id: \.self) { person in
                    PersonRow(person: person)
                        .onAppear {
                            viewModel.loadDataIfNeeded(currentItem: person)
                        }
                        .onTapGesture {
                            viewModel.selectPerson(person)
                        }
                }
            }
            .padding()
        }
    }
}

struct PersonRow: View {
    let person: Person
    
    var body: some View {
        HStack {
            CustomAsyncImage(urlString: person.image?.medium)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            Text(person.name)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    final class PreviewPersonViewModel: PersonViewModelProtocol {
        var persons: [Person] = Person.preview()
        var isLoading: Bool = false
        var searchText: String = ""
        var errorMessage: String? = nil
        func refreshPersons() {}
        func selectPerson(_ tvShow: Person) {}
        func loadDataIfNeeded(currentItem: Person?) {}
        
        
    }
    let viewModel = PreviewPersonViewModel()
    return PersonsView(viewModel: viewModel)
}


