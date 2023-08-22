//
//  DangerCollectionViewCell.swift
//  4INSHIELD
//
//  Created by kaisensData on 22/8/2023.
//

import UIKit

class DangerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var cardLogo: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!{
        didSet{
            backgroundImage.layer.cornerRadius = 15
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
