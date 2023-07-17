//
//  UserProfile.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 2/5/2023.
//

import UIKit
import Foundation

class UserProfile: KeyboardHandlingBaseVC {

    // IBOutlets
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameTf: UILabel!
    
    @IBOutlet weak var enfantsButton: UIButton!
    @IBOutlet weak var modifierButton: UIButton!
    
    var image: UIImage?
    
    // Child view controllers
    var enfantsViewController: EnfantsViewController?
    var updateViewController: UpdateViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load user infos
        getCurrentUserData()
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
        // Set text color opacity for selected button to 100%
        modifierButton.setTitleColor(modifierButton.titleLabel?.textColor?.withAlphaComponent(1.0), for: .normal)
        modifierButton.alpha = 1.0

        // Set text color opacity for unselected button to 70%
        enfantsButton.setTitleColor(enfantsButton.titleLabel?.textColor?.withAlphaComponent(0.7), for: .normal)
        enfantsButton.alpha = 0.7
        
        //Pick profile photo
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageButtonTapped))
        userPhoto.isUserInteractionEnabled = true
        userPhoto.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func profileImageButtonTapped() {
        presentPicker()
    }
    
    func presentPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        let alert = UIAlertController(title: "4INSHIELD", message: "Change your profile picture", preferredStyle: UIAlertController.Style.actionSheet)
        
        let camera = UIAlertAction(title: "Take a photo", style: UIAlertAction.Style.default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            } else {
                print("Unavailable camera in the simulator")
            }
            
        }
        let library = UIAlertAction(title: "Choose a photo from your gallery", style: UIAlertAction.Style.default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            } else {
                print("Error: Unavailable")
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
    
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func setUpDesign() {
        let minDimension = min(userPhoto.frame.size.width, userPhoto.frame.size.height)
        userPhoto.layer.cornerRadius = minDimension / 2
        userPhoto.clipsToBounds = true
    }
    
    func getCurrentUserData() {
        guard let savedUserName = UserDefaults.standard.string(forKey: "username") else { return }
//        let savedUserName = "kaxavy"
        DispatchQueue.main.async {
            APIManager.shareInstance.fetchCurrentUserData(username: savedUserName) { user in
                
                print("User data:", user)
                
                if (user.photo ?? "").isEmpty {
                    self.userPhoto.image = UIImage(imageLiteralResourceName: "empty")
                } else {
                    self.userPhoto.loadParentImage(from: user.photo)
                }
                
                self.userNameTf.text = user.username.uppercased()
                if (user.photo ?? "").isEmpty {
                    if user.gender == "M" {
                        self.userPhoto.image = UIImage(imageLiteralResourceName: "malePic")
                    } else {
                        self.userPhoto.image = UIImage(imageLiteralResourceName: "femalePic")
                    }
                } else {
                    self.userPhoto.loadParentImage(from: user.photo)
                }
            }
        }
    }
    
    @IBAction func changePicTaped(_ sender: Any) {
        print("Change profile picture")
        presentPicker()
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
        
        // Set text color opacity for selected button to 100%
        enfantsButton.setTitleColor(enfantsButton.titleLabel?.textColor?.withAlphaComponent(1.0), for: .normal)
        enfantsButton.alpha = 1.0
        
        // Set text color opacity for unselected button to 70%
        modifierButton.setTitleColor(modifierButton.titleLabel?.textColor?.withAlphaComponent(0.7), for: .normal)
        modifierButton.alpha = 0.7
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
        // Set text color opacity for selected button to 100%
        modifierButton.setTitleColor(modifierButton.titleLabel?.textColor?.withAlphaComponent(1.0), for: .normal)
        modifierButton.alpha = 1.0
        
        // Set text color opacity for unselected button to 70%
        enfantsButton.setTitleColor(enfantsButton.titleLabel?.textColor?.withAlphaComponent(0.7), for: .normal)
        enfantsButton.alpha = 0.7
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

extension UserProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedSelectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userPhoto.image = editedSelectedImage
            image = editedSelectedImage
        }

        if let originalSelectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userPhoto.image = originalSelectedImage
            image = originalSelectedImage
        }

        guard let img = self.image else { return }

        guard let savedUserName = UserDefaults.standard.string(forKey: "username") else { return }
        
        print("username : \(savedUserName)")
                APIManager.shareInstance.uploadParentChildPic(withUser: savedUserName, photo: img)
        picker.dismiss(animated: true, completion: nil)
    }

}
