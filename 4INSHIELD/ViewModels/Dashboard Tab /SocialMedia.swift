//
//  SocialMedia.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 14/3/2023.
//

import UIKit

class SocialMedia: UIViewController {

    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    

    
    @IBAction func revealSideMenu(_ sender: Any) {
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }
    

}
