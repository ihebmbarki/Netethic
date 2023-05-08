//
//  ChildTvCell.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 3/5/2023.
//

import UIKit

class ChildTvCell: UITableViewCell {

    @IBOutlet weak var childPhoto: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var childView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Make childPhoto rounded
        childPhoto.layer.cornerRadius = childPhoto.frame.width / 2
        childPhoto.layer.masksToBounds = true
        childView.roundCorners(20, borderWidth: 0.1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
