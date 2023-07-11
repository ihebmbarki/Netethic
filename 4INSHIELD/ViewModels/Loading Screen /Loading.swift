//
//  Loading.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 1/3/2023.
//

import UIKit

class Loading: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // self.view.backgroundColor = UIColor.gradientColor()
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.performSegue(withIdentifier: "mSegue", sender: self)
        }
    }
    

}

extension UIColor {
    
    static func gradientColor() -> UIColor {
        let topColor = UIColor(red: 0.12, green: 0.73, blue: 0.94, alpha: 1.00)
        let bottomColor = UIColor(red: 0.12, green: 0.49, blue: 0.76, alpha: 1.00)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: image!)
    }
    
}

