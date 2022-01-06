import Combine
import UIKit

class MainViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let searchTextChangedSubject = PassthroughSubject<String, Never>()
    let cellPressedPublisher = PassthroughSubject<SearchResult, Never>()
    
    
    var arr = [SearchResult]()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(GifCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        
        let (
            loadResults,
            pushDetailView,
            showMainResults
        ) = mainViewModel(
            cellTapped: cellPressedPublisher.eraseToAnyPublisher(), // replace
            searchText: searchTextChangedSubject.eraseToAnyPublisher(),
            viewWillAppear: Empty().eraseToAnyPublisher() // replace
        )
        
        loadResults
            .sink { [weak self] results in
                guard let self = self else { return }
                self.arr = results
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        pushDetailView
            .sink { [weak self] result in
                guard let self = self else { return }
                let vc = DetailViewController(searchResult: result)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .store(in: &cancellables)
        
        showMainResults
            .sink { [weak self] (result) in
                guard let self = self else { return }
                self.arr = result
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search gifs..."
        searchBar.delegate = self
        return searchBar
    }()
    
    private var layout: UICollectionViewLayout {
        // TODO: implement
        let colLayout = UICollectionViewFlowLayout()
        return colLayout
    }
    
    
    
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextChangedSubject.send(searchText)
    }
}
