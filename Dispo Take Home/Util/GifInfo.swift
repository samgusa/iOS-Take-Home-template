import Foundation
import UIKit

struct GifInfo {
  var id: String
  var gifUrl: URL
  var text: String
  var shares: Int
  var backgroundColor: UIColor?
  var tags: [String]
}


struct otherGif: Codable {
    var id: Int
    var gifURL: URL
    var text: String
    var shares: Int
    //var backgroundColor: UIColor = UIColor.systemRed
}
