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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
