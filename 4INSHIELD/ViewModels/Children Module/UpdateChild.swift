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
    @IBOutlet weak var genderSegmetUI: UISegmentedControl!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    let pickerView = UIPickerView()
    var index = 0

    var child: Child?
    var image: UIImage? = nil
    var gender = "N"
    var birthday = "1990-02-02"

    var socialProfilesArray = [String]()
    var socialProfilesArrayIDs = [Int]()
    var socialMediaIDsArray = [Int]()

    var selectedProfileID: Int?
    var selectedSocialMediaID: Int?
    var selectedPlatformName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetUpDesign()
        loadChildInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func SetUpDesign() {
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
    
    func configureUI() {
        guard let childID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }
        DispatchQueue.main.async {
            APIManager.shareInstance.getCurrentChildProfiles(withID: childID) { profiles in
                print(profiles)
                profiles.forEach { profile in
                    self.socialProfilesArray.append(profile.pseudo)
                        self.socialProfilesArrayIDs.append(profile.id)
                        self.socialMediaIDsArray.append(profile.social_media_name)
                }
            }
        }
//        childPhoto.roundCorners(65/2, borderWidth: 0.5)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageButtonTapped))
        childPhoto.isUserInteractionEnabled = true
        childPhoto.addGestureRecognizer(tap)
        birthdayPicker.tintColor = Colrs.bgColor
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colrs.bgColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Colrs.bgColor]
    }
    
    @objc fileprivate func profileImageButtonTapped() {
        presentPicker()
    }
    
    func presentPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        let alert = UIAlertController(title: "4INSHIELD", message: "Change your Child's profile pic", preferredStyle: UIAlertController.Style.actionSheet)
        
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
        let remove = UIAlertAction(title: "Delete photo", style: UIAlertAction.Style.destructive) { _ in

            guard let savedChildID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }

            DispatchQueue.main.async {
                APIManager.shareInstance.deleteChildProfilePic(withID: savedChildID)
                self.childPhoto.image = #imageLiteral(resourceName: "empty").withRenderingMode(.alwaysOriginal)
            }

        }
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        alert.addAction(remove)
        present(alert, animated: true, completion: nil)
    }
    
    func loadChildInfo() {
        guard let savedChildID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }
        DispatchQueue.main.async {
            APIManager.shareInstance.fetchChild(withID: savedChildID) { child in
                self.PrenomTf.text = child.first_name
                self.nomTf.text = child.last_name
                
                switch child.gender {
                case "M":
                    self.genderSegmetUI.selectedSegmentIndex = 0
                case "F":
                    self.genderSegmetUI.selectedSegmentIndex = 1
                case "N":
                    self.genderSegmetUI.selectedSegmentIndex = 2
                default:
                    break
                }
                
                self.birthdayPicker.date = child.birthday.toDate()!
                if (child.photo ?? "").isEmpty {
                    self.childPhoto.image = UIImage(imageLiteralResourceName: "empty")
                }else {
                    self.childPhoto.loadImage(child.photo)
                }
            }
        }
    }
    
    @IBAction func changePicTaped(_ sender: Any) {
        print("Change profile pic")
        presentPicker()
    }
    
}

extension UpdateChild: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        

        if let editedSelectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            childPhoto.image = editedSelectedImage
            image = editedSelectedImage
        }
        
        if let originalSelectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            childPhoto.image = originalSelectedImage
            image = originalSelectedImage
        }
        guard let childID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }
        guard let img = self.image else {return}

        APIManager.shareInstance.uploadChildPic(withID: childID, photo: img)

        picker.dismiss(animated: true, completion: nil)
    }
}
