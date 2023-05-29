//
//  DangerCollectionViewCell.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 25/5/2023.
//

import UIKit

class DangerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardLogo: UIImageView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Make the cardLogo circular with a white background
//        let backgroundSize: CGFloat = max(cardLogo.bounds.width, cardLogo.bounds.height)
//        cardLogo.backgroundColor = .white
//        cardLogo.layer.cornerRadius = backgroundSize / 2
//        cardLogo.clipsToBounds = true
//        cardLogo.contentMode = .scaleAspectFit

    }
    
}
