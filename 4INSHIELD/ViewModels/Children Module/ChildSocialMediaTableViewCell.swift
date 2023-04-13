//
//  ChildSocialMediaTableViewCell.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 13/4/2023.
//

import UIKit

class ChildSocialMediaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var childSocialMediaView: UIView!
    @IBOutlet weak var socialMediaLogo: UIImageView!
    @IBOutlet weak var socialPlatform: UILabel!
    @IBOutlet weak var SocialPseudo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        childSocialMediaView.roundCorners(20, borderWidth: 0.1)
        socialMediaLogo.layer.cornerRadius = 36/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
