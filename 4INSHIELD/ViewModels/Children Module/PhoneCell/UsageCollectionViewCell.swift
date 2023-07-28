//
//  UsageCollectionViewCell.swift
//  4INSHIELD
//
//  Created by kaisensData on 27/7/2023.
//

import UIKit

class UsageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var carteImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(text: String){
        self.numberLabel.text = text
    }

}
