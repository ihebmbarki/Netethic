//
//  ChildProfile.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 22/3/2023.
//

import UIKit

class ChildProfile: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set the number of pages in the page control
        pageControl.numberOfPages = 5

        // Set the current page of the page control
        pageControl.currentPage = 0

        // Set the default page control indicators to circles
        for view in pageControl.subviews {
            if let dot = view as? UIImageView {
                dot.image = UIImage(systemName: "circle.fill")
                dot.tintColor = UIColor.gray
            }
        }

        // Set the current page control indicator to a numbered circle
        if let dot = pageControl.subviews[pageControl.currentPage] as? UIImageView {
            dot.image = UIImage(systemName: "\(pageControl.currentPage + 1).circle.fill")
            dot.tintColor = UIColor.blue
        }
        
        //Buttons style
        nextBtn.applyGradient()
        
    }


}
