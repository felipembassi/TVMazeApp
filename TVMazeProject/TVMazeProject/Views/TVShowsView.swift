// TVShowsView.swift

import SwiftUI

struct TVShowsView: View {
    @StateObject private var viewModel = TVShowsViewModel()

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
                ForEach(viewModel.shows, id: \.self) { series in
                    NavigationLink(destination: TVShowDetailView(tvShow: series)) {
                        TVShowCard(tvshow: series)
                    }
                    .onAppear {
                        viewModel.loadMoreContentIfNeeded(currentItem: series)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TVShowsView()
}
