//
//  UpdateChild.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 11/4/2023.
//

import UIKit
import Foundation
import DLRadioButton
import FSCalendar

class UpdateChild: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

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
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    var index = 0
    
    var selectedDate: Date?
    var dateFormatter = DateFormatter()

    var child: Child?
    var image: UIImage?
    var gender: String = ""
//    var birthday = ""

    var childId: Int?

//    var socialProfilesArray = [String]()
//    var socialProfilesArrayIDs = [Int]()
//    var socialMediaIDsArray = [Int]()
//
//    var selectedProfileID: Int?
//    var selectedSocialMediaID: Int?
//    var selectedPlatformName = ""

    var selectedSocialMedia: String?
    var selectedSocialMediaID: Int?
//    var socialMediaList = [Int : String]()
//    var socialArray:[Int : String] = [1:"twitter", 2:"instagram", 3:"youtube", 4:"snapchat",5:"tumblr",6:"pinterest",7:"reddit",8:"facebook",9:"quora"]
//
    var socialArray = [Profile]()
    var socialMediaNames:[Int : String] = [1:"twitter", 2:"instagram", 3:"youtube", 4:"snapchat",5:"tumblr",6:"pinterest",7:"reddit",8:"facebook",9:"quora"]


    override func viewDidLoad() {
        super.viewDidLoad()
    
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
        getCurrentChildSocialMedia()
        configureTableView()
        
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
            dateFormatter.dateStyle = .medium
            self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        }))

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }


    
//    @objc func showCalendar() {
//        // Create the alert controller
//        let alertController = UIAlertController(title: "Pick a date", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
//
//        // Specify the type of the calendarView explicitly
//        let calendarView = CalendarView()
//        calendarView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//
//        // Set the delegate and data source of the calendar to the calendarView instance
//        let calendar = FSCalendar()
//        calendar.delegate = self
//        calendar.dataSource = self
//
//        alertController.view.addSubview(calendarView)
//
//        // Add constraints to center the calendar view
//        calendarView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
//        calendarView.centerYAnchor.constraint(equalTo: alertController.view.centerYAnchor).isActive = true
//        calendarView.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        calendarView.heightAnchor.constraint(equalToConstant: 300).isActive = true
//
//        // Add an action to dismiss the alert controller when a date is selected
//        alertController.addAction(UIAlertAction(title: "Done", style: .default) { _ in
//            if let selectedDate = calendarView.selectedDate {
//                print("Selected date: \(selectedDate)")
//                self.dateTextField.text = self.dateFormatter.string(from: selectedDate)
//            }
//            alertController.dismiss(animated: true, completion: nil)
//        })
//
//        // Add a tap gesture recognizer to dismiss the alert controller when tapping outside of the calendar
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissCalendar(_:)))
//        alertController.view.superview?.addGestureRecognizer(tapGestureRecognizer)
//
//        // Present the alert controller
//        present(alertController, animated: true, completion: nil)
//    }
//
//    @objc private func dismissCalendar(_ gesture: UITapGestureRecognizer) {
//        dismiss(animated: true, completion: nil)
//    }
//



    //register tableView Cell
    func configureTableView(){
        SocialMediaTableView.delegate = self
        SocialMediaTableView.dataSource = self
        SocialMediaTableView.register(UINib.init(nibName: "Child_SocialMedia_TvCell", bundle: nil), forCellReuseIdentifier: "ChildSocialMediaCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        self.getCurrentChildSocialMedia()
    }

    func SetUpDesign() {
        //Set up photo
        childPhoto.layer.cornerRadius = childPhoto.frame.size.width / 2
        childPhoto.clipsToBounds = true
        
        //Add Padding to Textfields
        let prenomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let nomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let datePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        
        //Set up firstname textfield
        PrenomTf.layer.borderWidth = 1
        PrenomTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        PrenomTf.layer.cornerRadius = PrenomTf.frame.size.height/2
        PrenomTf.layer.masksToBounds = true
        PrenomTf.leftView = prenomPaddingView
        PrenomTf.leftViewMode = .always
        
        //Set up lastname textfield
        nomTf.layer.borderWidth = 1
        nomTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        nomTf.layer.cornerRadius = nomTf.frame.size.height/2
        nomTf.layer.masksToBounds = true
        nomTf.leftView = nomPaddingView
        nomTf.leftViewMode = .always
        
        //Set up date textfield
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        dateTextField.layer.cornerRadius = dateTextField.frame.size.height/2
        dateTextField.layer.masksToBounds = true
        dateTextField.leftView = datePaddingView
        dateTextField.leftViewMode = .always
        
        //Set up buttons
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height/2
        cancelBtn.layer.masksToBounds = true
        updateBtn.applyGradient()
        updateBtn.layer.cornerRadius = updateBtn.frame.size.height/2
        updateBtn.layer.masksToBounds = true
    }

    func getCurrentChildSocialMedia() {
        guard let childID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }
            APIManager.shareInstance.getCurrentChildProfiles(withID: childID) { profiles in
                self.socialArray = profiles
                    self.SocialMediaTableView.reloadData()
//                print("\(profiles)")
                self.verifyProfileList(profileList: profiles)
        }
    }

    func verifyProfileList(profileList: [Profile]) {
        if profileList.count > 0 {
            // profile list is not empty, do nothing.
        } else {
            let alertController = UIAlertController(title: "4INSHIELD", message: "Your profiles list is empty!", preferredStyle: .alert)
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
            }
        }
//        childPhoto.roundCorners(65/2, borderWidth: 0.5)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageButtonTapped))
        childPhoto.isUserInteractionEnabled = true
        childPhoto.addGestureRecognizer(tap)
//        birthdayPicker.tintColor = Colrs.bgColor

//        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.blue], for: .selected)

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
                self.PrenomTf.text = child.first_name
                self.nomTf.text = child.last_name

                if child.gender == "M" {
                    self.maleRadioButton.isSelected = true
                } else if child.gender == "F" {
                    self.femaleRadioButton.isSelected = true
                } else {
                    self.otherRadioButton.isSelected = true
                }

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let birthdate = dateFormatter.date(from: child.birthday) {
                    self.dateTextField.text = dateFormatter.string(from: birthdate)
                }
                
                if (child.photo ?? "").isEmpty {
                    if child.gender == "M" {
                        self.childPhoto.image = UIImage(imageLiteralResourceName: "malePic")
                    } else {
                        self.childPhoto.image = UIImage(imageLiteralResourceName: "femalePic")
                    }
                } else {
                    self.childPhoto.loadImage(child.photo)
                }
            }
        }
    }


    @IBAction func changePicTaped(_ sender: Any) {
        print("Change profile pic")
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
        // Wrap the current view controller inside a navigation controller
        let navController = UINavigationController(rootViewController: self)
        // Push the new view controller onto the navigation stack
        navController.pushViewController(vc, animated: true)
        // Replace the current view controller with the navigation controller
        UIApplication.shared.windows.first?.rootViewController = navController
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Children", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildrenListSB")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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

extension UpdateChild:  UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialArray.count
   }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildSocialMediaCell", for: indexPath) as! ChildSocialMediaTableViewCell

        let profile = socialArray[indexPath.row]

        cell.socialPlatform.text = socialMediaNames[profile.social_media_name] ?? "Unknown"
        cell.SocialPseudo.text = profile.pseudo.uppercased()
        cell.socialMediaLogo.image = UIImage(imageLiteralResourceName: "empty")

        return cell
    }

}
