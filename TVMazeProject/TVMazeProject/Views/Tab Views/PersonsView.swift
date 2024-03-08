// PersonsView.swift

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
                    .padding(.Spacing.l)
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
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: .Spacing.l) {
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
    
    let imageSize: CGFloat = 100

    var body: some View {
        HStack {
            CustomAsyncImage(urlString: person.image?.medium)
                .frame(width: imageSize, height: imageSize)
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
        func selectPerson(_: Person) {}
        func loadDataIfNeeded(currentItem _: Person?) {}
    }
    let viewModel = PreviewPersonViewModel()
    return PersonsView(viewModel: viewModel)
}
