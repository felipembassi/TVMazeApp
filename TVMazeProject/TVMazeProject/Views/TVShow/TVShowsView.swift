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
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        CustomButton(title: "Reload", systemImage: "arrow.clockwise") {
                            viewModel.refreshShows()
                        }
                    }
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
                        .onAppear {
                            viewModel.loadDataIfNeeded(currentItem: tvShow)
                        }
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
    final class PreviewTVShowsViewModel: TVShowsViewModelProtocol {
        func loadDataIfNeeded(currentItem: TVShow?) {
            let tvShow = TVShow(
                id: 300,
                url: "https://example.com/series/300",
                name: "Series 300",
                genres: ["Drama", "Sci-Fi"],
                runtime: 45,
                averageRuntime: 45,
                premiered: "2021-09-01",
                ended: nil,
                officialSite: "https://example.com/officialSiteSeries/300",
                schedule: Schedule(time: "10:00", days: [.monday, .friday, .saturday]),
                rating: Rating(average: 10),
                image: SeriesImage(
                    medium: "https://static.tvmaze.com/uploads/images/medium_portrait/475/1188298.jpg",
                    original: "https://static.tvmaze.com/uploads/images/original_untouched/475/1188298.jpg"
                ),
                summary: "<p>With his straw hat and ragtag crew, young pirate Monkey D. Luffy goes on an epic voyage for treasure in this live-action adaptation of the popular manga.</p>",
                updated: 1_234_567_890)
            shows.append(tvShow)
        }
        
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
