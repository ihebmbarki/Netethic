//
//  UserProfile.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 2/5/2023.
//

import UIKit

class UserProfile: UIViewController {

    // IBOutlets
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameTf: UILabel!
    
    @IBOutlet weak var enfantsButton: UIButton!
    @IBOutlet weak var modifierButton: UIButton!
    
    // Child view controllers
    var enfantsViewController: EnfantsViewController?
    var updateViewController: UpdateViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate child view controllers from storyboard
        enfantsViewController = storyboard?.instantiateViewController(withIdentifier: "EnfantsViewController") as? EnfantsViewController
        updateViewController = storyboard?.instantiateViewController(withIdentifier: "UpdateViewController") as? UpdateViewController
        
        // Add enfantsViewController as default child view controller
        addChild(updateViewController!)
        updateViewController?.view.frame = userView.bounds
        userView.addSubview(updateViewController!.view)
        updateViewController?.didMove(toParent: self)
        // Underline selected button
        modifierButton.setUnderline()
        enfantsButton.removeUnderline()
    }
    
    func setUpDesign() {
        let minDimension = min(userPhoto.frame.size.width, userPhoto.frame.size.height)
        userPhoto.layer.cornerRadius = minDimension / 2
        userPhoto.clipsToBounds = true
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enfantsButtonTapped(_ sender: UIButton) {
        // Remove current child view controller
        removeCurrentChildViewController()
        
        // Add enfantsViewController as child view controller
        addChild(enfantsViewController!)
        enfantsViewController?.view.frame = userView.bounds
        userView.addSubview(enfantsViewController!.view)
        enfantsViewController?.didMove(toParent: self)
        
        // Underline selected button
        enfantsButton.setUnderline()
        modifierButton.removeUnderline()
    }
    
    @IBAction func modifierButtonTapped(_ sender: UIButton) {
        // Remove current child view controller
        removeCurrentChildViewController()
        
        // Add updateViewController as child view controller
        addChild(updateViewController!)
        updateViewController?.view.frame = userView.bounds
        userView.addSubview(updateViewController!.view)
        updateViewController?.didMove(toParent: self)
        
        // Underline selected button
        modifierButton.setUnderline()
        enfantsButton.removeUnderline()
    }
    
    func removeCurrentChildViewController() {
        // Remove current child view controller
        if enfantsViewController != nil && enfantsViewController!.view.superview != nil {
            enfantsViewController!.willMove(toParent: nil)
            enfantsViewController!.view.removeFromSuperview()
            enfantsViewController!.removeFromParent()
        }
        
        if updateViewController != nil && updateViewController!.view.superview != nil {
            updateViewController!.willMove(toParent: nil)
            updateViewController!.view.removeFromSuperview()
            updateViewController!.removeFromParent()
        }
    }
}

extension UIButton {
    func setUnderline() {
        guard let title = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func removeUnderline() {
        guard let title = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.removeAttribute(.underlineStyle, range: NSRange(location: 0, length: attributedString.length))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
