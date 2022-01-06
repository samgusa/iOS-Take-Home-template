//
//  GifCollectionCell.swift
//  Dispo Take Home
//
//  Created by Sam Greenhill on 1/4/22.
//

import UIKit

class GifCollectionCell: UICollectionViewCell {
    
    
    let imgView: UIImageView = {
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var gifTitle: UILabel = {
       let txt = UILabel()
        txt.text = "No Title available"
        txt.numberOfLines = 0
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private let contentStackView: UIStackView = {
       let stck = UIStackView()
        stck.axis = .horizontal
        stck.distribution = .fillProportionally
        stck.translatesAutoresizingMaskIntoConstraints = false
        return stck
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentStackView.addArrangedSubview(imgView)
        contentStackView.addArrangedSubview(gifTitle)
        contentView.addSubview(contentStackView)
        
        
        
        //TODO: change to snapkit later
        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
