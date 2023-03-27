//
//  ChildDevice.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 23/3/2023.
//

import UIKit

class ChildDevice: UIViewController {

    @IBOutlet weak var sauterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Buttons style
        sauterBtn.applyGradient()
    }
    

}
