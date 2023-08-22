//
//  IndicatorCollectionViewCell.swift
//  4INSHIELD
//
//  Created by kaisensData on 16/8/2023.
//
import AlamofireImage
import UIKit

class IndicatorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var toxicityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let backgroundSize: CGFloat = max(iconImage.bounds.width, iconImage.bounds.height)
        iconImage.backgroundColor = .white
        iconImage.layer.cornerRadius = backgroundSize / 2
        iconImage.clipsToBounds = true
        iconImage.contentMode = .scaleAspectFit
    }
    func setData(background: String,icon: String, toxicity: String, name: String){
        self.backgroundImage.image = UIImage(named: background)
         
        if let url = URL(string: icon) {
            self.iconImage.af.setImage(withURL: url)
            print(url)
        }
        iconImage.backgroundColor = UIColor(named: background)
         // Convert toxicity to percentage and display
         if let toxicityRate = Double(toxicity) {
             let percentage = Int(toxicityRate * 100)
             self.toxicityLabel.text = "\(percentage) "
         } else {
             self.toxicityLabel.text = "N/A"
         }
         
         self.nameLabel.text = name
     }

}
