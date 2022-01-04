import Combine
import UIKit

func mainViewModel(
    cellTapped: AnyPublisher<SearchResult, Never>,
    searchText: AnyPublisher<String, Never>,
    viewWillAppear: AnyPublisher<Void, Never>
) -> (
    loadResults: AnyPublisher<[SearchResult], Never>,
    pushDetailView: AnyPublisher<SearchResult, Never>,
    showMainPosts: AnyPublisher<[SearchResult], Never>
) {
    let api = GifAPIClient.live
    
    let searchResults = searchText
        .map { api.searchGIFs($0) }
        .switchToLatest()
    
    //main results that appear.
    let mainResults = api.featuredGIFs
    
    
    // show featured gifs when there is no search query, otherwise show search results
    let loadResults = searchResults
        .eraseToAnyPublisher()
    
    //show main results
    let showMainResults = mainResults()
        .eraseToAnyPublisher()
    
    //renamed pushDetailView. What happens when cell pressed
    let cellPushed = cellTapped
        .eraseToAnyPublisher()
    
    return (
        loadResults: loadResults,
        pushDetailView: cellPushed,
        showMainPosts: showMainResults
    )
}
