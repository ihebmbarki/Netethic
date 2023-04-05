//
//  ChildTableViewCell.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 5/4/2023.
//

import UIKit

class ChildTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var childAvatar: UIImageView!
    @IBOutlet weak var childFullName: UILabel!
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        childView.roundCorners(20, borderWidth: 0.1)
        childAvatar.layer.cornerRadius = 36/2
//        childView.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 20, scale: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
