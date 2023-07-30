//
//  UsageCollectionViewCell.swift
//  4INSHIELD
//
//  Created by kaisensData on 27/7/2023.
//

import UIKit

class UsageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var carteImage: UIImageView!
    
    @IBOutlet weak var divLabel: UILabel!
    @IBOutlet weak var informationButton: UIButton!{
        didSet{
            informationButton.layer.cornerRadius = 15
            informationButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(text: String, image: String, phrase: String){
        self.numberLabel.text = text
        self.carteImage.image = UIImage(named: image)
        self.descriptionLabel.text = phrase
    }

}
