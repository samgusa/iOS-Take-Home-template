import Combine
import UIKit

class DetailViewController: UIViewController {
  init(searchResult: SearchResult) {
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = UIView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
