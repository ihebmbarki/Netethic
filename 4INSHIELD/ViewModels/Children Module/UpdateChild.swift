//
//  UpdateChild.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 11/4/2023.
//

import UIKit

class UpdateChild: UIViewController {

    @IBOutlet weak var childPhoto: UIImageView!
    @IBOutlet weak var PrenomTf: UITextField!
    @IBOutlet weak var nomTf: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        //Set up photo
        childPhoto.layer.cornerRadius = childPhoto.frame.size.width / 2
        childPhoto.clipsToBounds = true
        //Set up firstname textfield
        PrenomTf.layer.borderWidth = 1
        PrenomTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        PrenomTf.layer.cornerRadius = PrenomTf.frame.size.height/2
        PrenomTf.layer.masksToBounds = true
        //Set up lastname textfield
        nomTf.layer.borderWidth = 1
        nomTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        nomTf.layer.cornerRadius = nomTf.frame.size.height/2
        nomTf.layer.masksToBounds = true
        //Set up buttons
        cancelBtn.applyGradient()
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height/2
        cancelBtn.layer.masksToBounds = true
        updateBtn.applyGradient()
        updateBtn.layer.cornerRadius = updateBtn.frame.size.height/2
        updateBtn.layer.masksToBounds = true
    }
}
