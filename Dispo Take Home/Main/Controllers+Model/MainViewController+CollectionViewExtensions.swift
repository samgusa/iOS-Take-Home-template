//
//  MainViewController+CollectionViewExtensions.swift
//  Dispo Take Home
//
//  Created by Sam Greenhill on 1/4/22.
//

import Foundation
import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GifCollectionCell else {
            fatalError()
        }
        
        let gifData = arr[indexPath.row]
        cell.gifTitle.text = gifData.title
        cell.imgView.getImg(url: gifData.gifUrl)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //this causes the view to appear when sent.
        cellPressedPublisher.send(arr[indexPath.row])
    }
    
    
}
