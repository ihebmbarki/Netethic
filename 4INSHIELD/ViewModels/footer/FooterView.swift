//
//  FooterView.swift
//  Test
//
//  Created by mac-din-002 on 10/08/2023.
//

import UIKit

class FooterView: UIView {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    func configure(titleText: String, color: UIColor = UIColor.black) {
        titleLabel.text = titleText
        mainView.backgroundColor = color
    }
}

