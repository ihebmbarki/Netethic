//
//  UpdateChild.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 11/4/2023.
//

import UIKit
import Foundation
import DLRadioButton

class UpdateChild: KeyboardHandlingBaseVC, UISearchBarDelegate {
    
    //IBOutlets
    @IBOutlet weak var childPhoto: UIImageView!
    @IBOutlet weak var PrenomTf: UITextField!
    @IBOutlet weak var nomTf: UITextField!
    
    @IBOutlet weak var maleRadioButton: DLRadioButton!
    @IBOutlet weak var femaleRadioButton: DLRadioButton!
    @IBOutlet weak var otherRadioButton: DLRadioButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var SocialMediaTableView: UITableView!
    @IBOutlet weak var addNewProfileBtn: UIButton!
    @IBOutlet weak var ddUserAccBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    var index = 0
    
    var selectedDate: Date?
    var dateFormatter = DateFormatter()
    
    var child: Child?
    var selectedChild: Childd?
    var image: UIImage?
    var gender: String = ""
    
    var childId: Int?
    var selectedProfileID: Int?
    
    var selectedSocialMedia: String?
    var selectedSocialMediaID: Int?
    var isSearching = false
    var filteredSocialArray = [Profile]()
    
    var socialArray = [Profile]()
    var socialMediaNames:[Int : String] = [1:"twitter", 2:"instagram", 3:"youtube", 4:"snapchat",5:"tumblr",6:"pinterest",7:"reddit",8:"facebook",9:"quora"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //search bar
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "User name"
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        SocialMediaTableView.tableHeaderView = searchBar
        
        // Set up the button's action
        calendarButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        
        
        //Radio Buttons group property
        maleRadioButton.otherButtons = [femaleRadioButton, otherRadioButton]
        femaleRadioButton.otherButtons = [maleRadioButton, otherRadioButton]
        otherRadioButton.otherButtons = [maleRadioButton, femaleRadioButton]
        //Set  the corner radius
        maleRadioButton.layer.cornerRadius = maleRadioButton.frame.width / 2
        femaleRadioButton.layer.cornerRadius = femaleRadioButton.frame.width / 2
        otherRadioButton.layer.cornerRadius = otherRadioButton.frame.width / 2
        
        configureUI()
        SetUpDesign()
        loadChildInfo()
        //        getCurrentChildSocialMedia()
        configureTableView()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSocialArray = socialArray.filter({ $0.pseudo.lowercased().contains(searchText.lowercased()) })
        isSearching = !searchText.isEmpty
        SocialMediaTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = nil
        SocialMediaTableView.reloadData()
    }
    
    @objc func showDatePicker() {
        // Create the alert controller
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        
        // Configure the date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRect(x: 0, y: 0, width: 270, height: 216)
        
        // Add the date picker to the alert controller
        alertController.view.addSubview(datePicker)
        
        // Add the "Done" button to dismiss the alert controller
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            // Update the text field with the selected date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        }))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    //register tableView Cell
    func configureTableView(){
        SocialMediaTableView.layer.cornerRadius = 10.0
        SocialMediaTableView.layer.borderWidth = 1.0
        SocialMediaTableView.layer.borderColor = UIColor.lightGray.cgColor
        SocialMediaTableView.layer.masksToBounds = true
        
        SocialMediaTableView.delegate = self
        SocialMediaTableView.dataSource = self
        SocialMediaTableView.register(UINib.init(nibName: "Child_SocialMedia_TvCell", bundle: nil), forCellReuseIdentifier: "ChildSocialMediaCell")
        //        SocialMediaTableView.rowHeight = UITableView.automaticDimension
        //        SocialMediaTableView.estimatedRowHeight = 30 // Set this to your custom cell's height
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        //        self.getCurrentChildSocialMedia()
    }
    
    func SetUpDesign() {
        //Set up photo
        childPhoto.layer.cornerRadius = min(childPhoto.frame.width, childPhoto.frame.height) / 2
        childPhoto.clipsToBounds = true
        
        //Add Padding to Textfields
        let prenomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let nomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let datePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        
        //Set up firstname textfield
        PrenomTf.layer.borderWidth = 1
        PrenomTf.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        PrenomTf.layer.cornerRadius = PrenomTf.frame.size.height/2
        PrenomTf.layer.masksToBounds = true
        PrenomTf.leftView = prenomPaddingView
        PrenomTf.leftViewMode = .always
        
        //Set up lastname textfield
        nomTf.layer.borderWidth = 1
        nomTf.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        nomTf.layer.cornerRadius = nomTf.frame.size.height/2
        nomTf.layer.masksToBounds = true
        nomTf.leftView = nomPaddingView
        nomTf.leftViewMode = .always
        
        //Set up date textfield
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        dateTextField.layer.cornerRadius = dateTextField.frame.size.height/2
        dateTextField.layer.masksToBounds = true
        dateTextField.leftView = datePaddingView
        dateTextField.leftViewMode = .always
        
        //Set up buttons
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height/2
        cancelBtn.layer.masksToBounds = true
        updateBtn.layer.cornerRadius = updateBtn.frame.size.height/2
        updateBtn.layer.masksToBounds = true
    }
    
    func verifyProfileList(profileList: [Profile]) {
        if profileList.count > 0 {
        } else {
            let alertController = UIAlertController(title: "NETETHIC", message: "Your profiles list is empty!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        guard let childID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }
        DispatchQueue.main.async {
            APIManager.shareInstance.getCurrentChildProfiles(withID: childID) { profiles in
                profiles.forEach { profile in
                    print("Name: \(String(describing: profile.name))")
                    print("Pseudo: \(profile.pseudo)")
                    print("Social Media Name: \(profile.social_media_name)")
                }
                // Reload the table view inside the completion block
                self.socialArray = profiles
                self.SocialMediaTableView.reloadData()
                self.verifyProfileList(profileList: profiles)
            }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageButtonTapped))
        childPhoto.isUserInteractionEnabled = true
        childPhoto.addGestureRecognizer(tap)
        
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
        
        let alert = UIAlertController(title: "NETETHIC", message: "Change your Child's profile pic", preferredStyle: UIAlertController.Style.actionSheet)
        
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
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func radioButtonTapped(_ sender: DLRadioButton) {
        switch sender.tag {
        case 0: // male
            gender = "M"
        case 1: // female
            gender = "F"
        case 2: // other
            gender = "N"
        default:
            break
        }
    }
    
    func loadChildInfo() {
        guard let savedChildID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }
        DispatchQueue.main.async {
            APIManager.shareInstance.fetchChild(withID: savedChildID) { child in
                self.PrenomTf.text = child.user?.first_name
                self.nomTf.text = child.user?.last_name
                
                if child.user?.gender == "M" {
                    self.maleRadioButton.isSelected = true
                } else if child.user?.gender == "F" {
                    self.femaleRadioButton.isSelected = true
                } else {
                    self.otherRadioButton.isSelected = true
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let birthdate = dateFormatter.date(from: child.user!.birthday) {
                    self.dateTextField.text = dateFormatter.string(from: birthdate)
                }
                
                if (child.user?.photo ?? "").isEmpty {
                    if child.user!.gender == "M" {
                        self.childPhoto.image = UIImage(imageLiteralResourceName: "malePic")
                    } else {
                        self.childPhoto.image = UIImage(imageLiteralResourceName: "femalePic")
                    }
                } else {
                    self.childPhoto.loadImage(child.user?.photo)
                }
            }
        }
    }
    
    func goToScreen(withId identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func changePicTaped(_ sender: Any) {
        print("Change profile picture")
        presentPicker()
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        guard let userID = UserDefaults.standard.object(forKey: "userID") as? Int else { return }
        guard let childID = UserDefaults.standard.object(forKey: "childID") as? Int else { return }
        
        guard let fName = PrenomTf.text, !fName.isEmpty else {
            let alertController = UIAlertController(title: "Failed", message: "Enter your child's first name please!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let lName = nomTf.text, !lName.isEmpty else {
            let alertController = UIAlertController(title: "Failed", message: "Enter your child's last name please!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let updateData = [
            "parent": userID,
            "first_name": fName ,
            "last_name": lName ,
            "birthday": dateTextField.text ?? "",
            "gender": gender,
        ] as [String : Any]
        
        APIManager.shareInstance.updateChild(withID: childID, childData: updateData) { updatedChild in
            print("Updated child: \(updatedChild)")
            let alertController = UIAlertController(title: "Success", message: "Child informations updated successfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func addNewProfileBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildSocialMedia")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addUserAccBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdateChild", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserAccountID")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Children", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildrenListSB")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension UpdateChild: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedSelectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            childPhoto.image = editedSelectedImage
            image = editedSelectedImage
        }

        if let originalSelectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            childPhoto.image = originalSelectedImage
            image = originalSelectedImage
        }

        guard let img = self.image else { return }

        if let selectedChild = selectedChild, let username = selectedChild.user?.username {
             print ("selected child : \(selectedChild), username: \(username)")
            APIManager.shareInstance.fetchCurrentUserData(username: username) { user in
                let roleId = user.role_data.id
                print ("Role id : \(roleId)")

                APIManager.shareInstance.uploadChildPic(withID: roleId, photo: img)
            }
        } else {
            print("Error: Selected child or username is nil.")
        }

        picker.dismiss(animated: true, completion: nil)
    }

}

extension UpdateChild:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredSocialArray.count : socialArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProfile = socialArray[indexPath.row]
        selectedProfileID = selectedProfile.id
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildSocialMediaCell", for: indexPath) as! ChildSocialMediaTableViewCell
        
        let profile = isSearching ? filteredSocialArray[indexPath.row] : socialArray[indexPath.row]
        DispatchQueue.main.async {
            cell.socialPlatform.text = self.socialMediaNames[profile.social_media_name] ?? "Unknown"
            cell.SocialPseudo.text = "@" + profile.pseudo
            
            switch profile.social_media_name {
            case 1:
                cell.socialMediaLogo.image = UIImage(named: "Twitter_logo")
            case 2:
                cell.socialMediaLogo.image = UIImage(named: "instagram_logo")
            case 3:
                cell.socialMediaLogo.image = UIImage(named: "youtube_logo")
            case 4:
                cell.socialMediaLogo.image = UIImage(named: "snapchat_logo")
            case 5:
                cell.socialMediaLogo.image = UIImage(named: "Tumblr_logo")
            case 6:
                cell.socialMediaLogo.image = UIImage(named: "pinterest_logo")
            case 7:
                cell.socialMediaLogo.image = UIImage(named: "reddit_logo")
            case 8:
                cell.socialMediaLogo.image = UIImage(named: "facebook_logo")
            case 9:
                cell.socialMediaLogo.image = UIImage(named: "quora_logo")
            default:
                cell.socialMediaLogo.image = nil // No logo available
            }
            
        }
        
        return cell
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            
            let alert = UIAlertController(title: nil, message: "Are you sure, you want remove this social profile from your list?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Yes, sure", style: .destructive, handler: { _ in
                self.socialArray.remove(at: indexPath.row)
                self.SocialMediaTableView.deleteRows(at: [indexPath], with: .fade)
                if let profileID = self.selectedProfileID {
                    APIManager.shareInstance.deleteSocialProfile(profileID: profileID, onSuccess: {
                        print("Social profile was deleted.. ")
                        
                    }, onError: {_ in
                        print("Error occured while deleting profile ")
                    })
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel ,handler: { _ in self.SocialMediaTableView.reloadData()}))
            self.present(alert, animated: true, completion: nil)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor =  .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}

