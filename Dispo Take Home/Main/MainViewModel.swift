import Combine
import UIKit

func mainViewModel(
  cellTapped: AnyPublisher<SearchResult, Never>,
  searchText: AnyPublisher<String, Never>,
  viewWillAppear: AnyPublisher<Void, Never>
) -> (
  loadResults: AnyPublisher<[SearchResult], Never>,
  pushDetailView: AnyPublisher<SearchResult, Never>
) {
  let api = GifAPIClient.live


    
  let trendingGifs = Empty<[SearchResult], Never>()

  let searchResults = searchText
    .map { api.searchGIFs($0) }
    .switchToLatest()

  // show featured gifs when there is no search query, otherwise show search results
  let loadResults = trendingGifs
    .eraseToAnyPublisher()

  let pushDetailView = Empty<SearchResult, Never>()
    .eraseToAnyPublisher()

  return (
    loadResults: loadResults,
    pushDetailView: pushDetailView
  )
}
