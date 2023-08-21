//
//  CardCollectionViewCell.swift
//  4INSHIELD
//
//  Created by kaisensData on 21/8/2023.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardProgress: UIProgressView!
    @IBOutlet weak var cardDesc: UILabel!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardLogo: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Make the cardLogo circular with a white background
        let backgroundSize: CGFloat = max(cardLogo.bounds.width, cardLogo.bounds.height)
        cardLogo.backgroundColor = .white
        cardLogo.layer.cornerRadius = backgroundSize / 2
        cardLogo.clipsToBounds = true
        cardLogo.contentMode = .scaleAspectFit
    }

}
