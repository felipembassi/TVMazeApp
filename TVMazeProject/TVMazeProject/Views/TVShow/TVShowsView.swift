// TVShowsView.swift

import SwiftUI

struct TVShowsView<ViewModel: TVShowsViewModelProtocol>: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.shows.isEmpty {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    showsGrid
                }
            }
            .searchable(text: $viewModel.searchText)
            .refreshable {
                viewModel.refreshShows()
            }
            .navigationTitle("TV Series")
        }
    }

    @ViewBuilder private var showsGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.shows, id: \.self) { tvShow in
                    TVShowCard(tvshow: tvShow)
                        .onTapGesture {
                            viewModel.selectTVShow(tvShow)
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    class PreviewTVShowsViewModel: TVShowsViewModelProtocol {
        var shows: [TVShow] = TVShow.preview()
        var isLoading: Bool = false
        var searchText: String = ""
        var errorMessage: String?
        func loadMoreContentIfNeeded(currentItem _: TVShow?) {}
        func refreshShows() {}
        func selectTVShow(_: TVShow) {}
    }

    let viewModel = PreviewTVShowsViewModel()
    return TVShowsView(viewModel: viewModel)
}
