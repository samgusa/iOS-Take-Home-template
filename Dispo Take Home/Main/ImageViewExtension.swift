//
//  ImageViewExtension.swift
//  Dispo Take Home
//
//  Created by Sam Greenhill on 1/5/22.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func getImg(url: URL) {
        self.kf.indicatorType = .none
        self.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"),
                         options: [
                            .cacheOriginalImage,
                            .forceTransition
                         ], completionHandler: {
                            result in
                            switch result {
                            case .success(_):
                                return
                            case .failure(let error):
                                print("Error \(error)")
                            }
                         })
    }
}

