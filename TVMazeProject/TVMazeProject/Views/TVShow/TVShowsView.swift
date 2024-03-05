// TVShowsView.swift

import SwiftUI

struct TVShowsView: View {
    @ObservedObject private var viewModel: TVShowsViewModel

    public init(viewModel: TVShowsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Group {
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
            .padding(.horizontal)
        }
    }
}

// #Preview {
//    TVShowsView(viewModel: TVShowsViewModel())
// }
