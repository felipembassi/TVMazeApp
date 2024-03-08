// PersonDetailView.swift

import SwiftUI

struct PersonDetailView<ViewModel: PersonDetailViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                VStack(alignment: .center) {
                    CustomAsyncImage(urlString: viewModel.person.image?.original)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())

                    Text(viewModel.person.name)
                        .font(.title)

                    Divider()
                        .padding(.horizontal, 24)
                    Text("Worked on:")
                        .font(.subheadline)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.tvShows, id: \.self) { tvShow in
                                TVShowCardView(tvshow: tvShow)
                                    .onTapGesture {
                                        viewModel.selectTVShow(tvShow)
                                    }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Person Details")
    }
}

#Preview {
    final class PreviewPersonDetailViewModel: PersonDetailViewModelProtocol {
        var person: Person = Person.preview().first!
        var tvShows: [TVShow] = TVShow.preview()
        var isLoading: Bool = false
        var errorMessage: String? = nil
        func fetchPersonDetails() {}
        func selectTVShow(_: TVShow) {}
    }
    let viewModel = PreviewPersonDetailViewModel()
    return PersonDetailView(viewModel: viewModel)
}
