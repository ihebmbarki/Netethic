//
//  ChildProfileAdded.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 23/3/2023.
//

import UIKit
import FLAnimatedImage

class ChildProfileAdded: UIViewController {

    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var addNewProfileBtn: UIButton!
    @IBOutlet weak var editProfileInfoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load the GIF file from the main bundle
        guard let url = Bundle.main.url(forResource: "Succes", withExtension: "gif") else {
            return
        }
        
        // Create an animated image object with the GIF file data
        guard let data = try? Data(contentsOf: url), let animatedImage = FLAnimatedImage(animatedGIFData: data) else {
            return
        }
        
        // Set the animated image to your UIImageView
        gifImageView.animatedImage = animatedImage
        
        //Buttons style
        addNewProfileBtn.applyGradient()
        editProfileInfoBtn.applyGradient()
    }
    
}
