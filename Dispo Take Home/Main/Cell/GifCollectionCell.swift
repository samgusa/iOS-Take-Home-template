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
        txt.textColor = .label
        txt.numberOfLines = 0
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private let contentStackView: UIStackView = {
       let stck = UIStackView()
        stck.axis = .horizontal
        stck.distribution = .fillProportionally
        stck.spacing = 10
        stck.translatesAutoresizingMaskIntoConstraints = false
        return stck
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentStackView.addArrangedSubview(imgView)
        contentStackView.addArrangedSubview(gifTitle)
        contentView.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { (view) in
            view.left.equalTo(10)
            view.right.equalTo(10)
        }
    
        imgView.snp.makeConstraints { (img) in
            img.height.equalTo(contentView.frame.height * 0.80)
            img.width.equalTo(contentView.frame.height * 0.95)
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
