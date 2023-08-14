//
//  ChildProfile.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 22/3/2023.
//
import Foundation
import Alamofire
import FSCalendar
import FlexibleSteppedProgressBar
import DropDown


import UIKit

class ChildProfile: KeyboardHandlingBaseVC, FlexibleSteppedProgressBarDelegate {
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentInsetAdjustmentBehavior = .never
            
        }
    }
    
    @IBOutlet weak var errorBirthdayLabel: UILabel!
    @IBOutlet weak var errorEmaillabel: UILabel!
 
    @IBOutlet weak var errorLastNameLabel: UILabel!
    @IBOutlet weak var errofFirstNameLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var calenderButton: UIButton!
    @IBOutlet weak var birthdayTextField: UITextField!
    var userParentID = Int()
//    let progressBarVC = ProgressBarViewController()
    
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var changeLanguageBtn: UIButton!
    
    @IBOutlet weak var progressFirstView: UIView!
    
    @IBOutlet weak var logoImage: UIImageView!
    var progressBar: FlexibleSteppedProgressBar!
    var progressBarWithoutLastState: FlexibleSteppedProgressBar!
    var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    
    var backgroundColor = UIColor(named: "AccentColor")
    var progressColor = UIColor(named: "AccentColor")
    var textColorHere = UIColor.white
    
    var maxIndex = -1
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderView: UIView!
    var selectedGender : String?
    var sexe: String = "M"
    let menu1: DropDown = {
           let menu1 = DropDown()
           menu1.dataSource = [
               "Garçon",
               "Fille",
               "Non précisé"
           ]
           return menu1
       }()
    let menu2: DropDown = {
           let menu2 = DropDown()
           menu2.dataSource = [
               "Boy",
               "Girl",
               "Unspecified"
           ]
           return menu2
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupProgressBar()
//        setupProgressBarWithoutLastState()
        setupProgressBarWithDifferentDimensions()

        firstNameTF.setupBorderTFs()
        lastNameTF.setupBorderTFs()
        genderTF.setupBorderTFs()
        emailTextField.setupBorderTFs()
        birthdayTextField.setupBorderTFs()
        
        //Buttons style
        nextBtn.applyGradient()
        nextBtn.layer.cornerRadius = 15
        nextBtn.setImage(UIImage(named: "next")!.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        nextBtn.imageEdgeInsets = UIEdgeInsets(top : 0, left : 0 , bottom : 0, right : -250)
        
        birthdayTextField.setupRightSideImage(image: "calendar", colorName: "AccentColor")
//        calenderButton.setImage(UIImage(named: "calendar")!.withTintColor(UIColor(named: "AccentColor")!, renderingMode: .alwaysTemplate), for: .normal)
//        calenderButton.contentVerticalAlignment = .center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(calendarImageTapped))
           birthdayTextField.rightView?.addGestureRecognizer(tapGesture)
//        calenderButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        resetForm()
        menu1.anchorView = genderView
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem1))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            genderView.addGestureRecognizer(gesture)
            menu1.selectionAction = { index, title in
                print(index)
                print(title)
                self.genderLabel.text = title
            }
    }
    func listeDeroulante(){
        let genre = genderLabel.text
        // liste déroulanteFr
        if LanguageManager.shared.currentLanguage == "fr" {
     
        menu1.anchorView = genderView
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem1))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            genderView.addGestureRecognizer(gesture)
            menu1.selectionAction = { index, title in
                print(index)
                print(title)
                self.genderLabel.text = title
            }
            if genre == "Boy" {self.genderLabel.text = "Garçon" }
            if genre == "Girl" {self.genderLabel.text = "Fille" }
            if genre == "Unspecified" {self.genderLabel.text = "Non précisé" }

        }
        // liste déroulanteEn
        if LanguageManager.shared.currentLanguage == "en" {
        menu2.anchorView = genderView
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem2))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
            genderView.addGestureRecognizer(gesture)
            menu2.selectionAction = { index, title in
                print(index)
                print(title)
                self.genderLabel.text = title
            }
            if genre == "Garçon" {self.genderLabel.text = "Boy" }
            if genre == "Fille" {self.genderLabel.text = "Girl" }
            if genre == "Non précisé" {self.genderLabel.text = "Unspecified" }
        }
    }

    @objc func didTapTopItem1(){
            menu1.show()
     }
    @objc func didTapTopItem2(){
            menu2.show()
     }

    func resetForm(){
           errofFirstNameLabel.isHidden = true
            errorLastNameLabel.isHidden = true
            errorEmaillabel.isHidden = true
            errorBirthdayLabel.isHidden = true
//            emailTF.text = ""
//            passwordTF.text = ""
        }
    

    @objc func calendarImageTapped() {
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
            print(dateFormatter.string(from: datePicker.date))
            
            self.birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        }))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func  goToSocial(withId identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ChildSocialMedia = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(ChildSocialMedia, animated: true)
    }
    //    UserDefaults.standard.set(id, forKey: "childID")
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        let firstName = self.firstNameTF.text ?? "test"
        let lastName = self.lastNameTF.text ?? "test"
        let gender = self.genderTF.text ?? "M"
        let email = self.emailTextField.text ?? "test@test.com"
        
        let roleDataID = UserDefaults.standard.integer(forKey: "RoleDataID")
        print("Value of roleDataID: \(roleDataID)")
        var userId = Int(roleDataID)
        
        if roleDataID != 0 {
            userId = Int(roleDataID)
        }else {
            userId = 75
        }
        let stringDate = birthdayTextField.text ?? "2002-02-02"
        // let userID = Int(roleDataID)
        selectedGender = genderLabel.text
        
        if selectedGender == "Garçon"{
            sexe = "M"
        }
        if selectedGender == "Fille"{
            sexe = "F"
        }
        if selectedGender == "Non précisé"{
            sexe = "O"
        }
        let regData = ChildModel(first_name: firstName, last_name: lastName, birthday: stringDate, email: email, gender: sexe, parent_id: userId)
        let parameters: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "birthday": stringDate,
            "gender": sexe,
            "parent_id": userId
        ]
        
        AF.request(add_Child_url, method: .post, parameters: parameters)
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                        do {
                            let userRole = try JSONDecoder().decode(UserRole.self, from: data)
                            // Handle the decoded data as needed
                            print("User child ID: \(userRole.child)")
                            UserDefaults.standard.set(userRole.child.id, forKey: "childID")
                            if LanguageManager.shared.currentLanguage == "fr" {
                                let alertController = UIAlertController(title: "Success", message: "Les informations de profil de votre enfant ont été ajoutées avec succès ", preferredStyle: .alert)
                                let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                                    self.goToScreen(identifier: "ChildSocialMedia")
                                    self.progressBarWithDifferentDimensions.completedTillIndex = 1
                                }
                                
                                alertController.addAction(okayAction)
                                self.present(alertController, animated: true, completion: nil)
                                print("User child registered successfully")
                                self.platform()
                            }
                            if LanguageManager.shared.currentLanguage == "fr" {
                                let alertController = UIAlertController(title: "Success", message: "Your child’s profile information has been successfully added ", preferredStyle: .alert)
                                let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                                    self.goToScreen(identifier: "ChildSocialMedia")
                                    self.progressBarWithDifferentDimensions.completedTillIndex = 1
                                }
                                
                                alertController.addAction(okayAction)
                                self.present(alertController, animated: true, completion: nil)
                                print("User child registered successfully")
                                self.platform()
                            }
                        } catch {
                            print("Decoding error: \(error)")
                            // Handle decoding error
                            if LanguageManager.shared.currentLanguage == "fr" {
                                self.showAlert(title: "Alerte", message: "Désolé, quelque chose s'est mal passé.")
                            }
                            if LanguageManager.shared.currentLanguage == "en" {
                                self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                            }
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    // Handle request failure
                    if LanguageManager.shared.currentLanguage == "fr" {
                        self.showAlert(title: "Alerte", message: "Désolé, quelque chose s'est mal passé.")
                    }
                    if LanguageManager.shared.currentLanguage == "en" {
                        self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                    }
                }
            }
        
    }
    

    func goToScreen(identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ChildSocialMedia = storyboard.instantiateViewController(withIdentifier: identifier)
//        navigationController?.pushViewController(ChildSocialMedia, animated: true)
        self.present(ChildSocialMedia, animated: true, completion: nil)

    }
    
    func platform(){
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = df.string(from: date)
        
        
        guard let userIDString = UserDefaults.standard.string(forKey: "userID"),
              let userID = Int(userIDString) else {
            print("User ID not found")
            return
        }
        let wizardParam = Wizard(user: userID, wizardStep: 2, platform: "mobile", date: dateString)
     
        AF.request(user_journey_url, method: .post, parameters: wizardParam, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    switch response.response?.statusCode {
                    case 200,201:
                        /// Handle success, parse JSON data
                        do {
                            let jsonData = try JSONDecoder().decode(WizardResponse.self, from: JSONSerialization.data(withJSONObject: data))
                            
                            print("save!!!!!")
                        } catch let error {
                            /// Handle json decode error
                            print(error)
                        }
                    case 401:
                        /// Handle 401 error
                        if LanguageManager.shared.currentLanguage == "fr"{
        
                            self.showAlert(title:"Alerte" ,message: "Désolé, qulque chose s'est mal passé.   ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                        }
                        print("not authorization")
                    default:
                        /// Handle unknown error
                        print("we ran into error")
                    }
                case .failure(let error):
                    /// Handle request failure
                    if LanguageManager.shared.currentLanguage == "fr"{
                        self.showAlert(title:"Alerte" ,message: "Désolé, qulque chose s'est mal passé.   ")
                    }
                    if LanguageManager.shared.currentLanguage == "en"{
                        self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                    }
                }
            })
    }
    
    
    
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    


    func setupProgressBarWithDifferentDimensions() {
        progressBarWithDifferentDimensions = FlexibleSteppedProgressBar()
        progressBarWithDifferentDimensions.translatesAutoresizingMaskIntoConstraints = false
        self.progressFirstView.addSubview(progressBarWithDifferentDimensions)
        
        // iOS9+ auto layout code
        let horizontalConstraint = progressBarWithDifferentDimensions.centerXAnchor.constraint(equalTo: self.progressFirstView.centerXAnchor)
        let verticalConstraint = progressBarWithDifferentDimensions.topAnchor.constraint(
            equalTo: progressFirstView.topAnchor,
            constant: 168
        )
        let widthConstraint = progressBarWithDifferentDimensions.widthAnchor.constraint(equalToConstant: 300)
        let heightConstraint = progressBarWithDifferentDimensions.heightAnchor.constraint(equalToConstant: 150)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        
        progressBarWithDifferentDimensions.numberOfPoints = 5
        progressBarWithDifferentDimensions.lineHeight = 6
        progressBarWithDifferentDimensions.radius = 14
        progressBarWithDifferentDimensions.progressRadius = 14
        progressBarWithDifferentDimensions.progressLineHeight = 6
        progressBarWithDifferentDimensions.delegate = self
        progressBarWithDifferentDimensions.useLastState = true
        progressBarWithDifferentDimensions.lastStateCenterColor = progressColor
        progressBarWithDifferentDimensions.selectedBackgoundColor = progressColor ?? .blue
        progressBarWithDifferentDimensions.selectedOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.lastStateOuterCircleStrokeColor = backgroundColor
        progressBarWithDifferentDimensions.currentSelectedCenterColor = progressColor ?? .blue
        progressBarWithDifferentDimensions.stepTextColor = textColorHere
        progressBarWithDifferentDimensions.currentSelectedTextColor = progressColor
        progressBarWithDifferentDimensions.completedTillIndex = 0
    }
    
    

    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == self.progressBar || progressBar == self.progressBarWithoutLastState {
        } else if progressBar == progressBarWithDifferentDimensions {
            if position == FlexibleSteppedProgressBarTextLocation.center {
                switch index {
                    
                case 0: return "1"
                case 1: return "2"
                case 2: return "3"
                case 3: return "4"
                case 4: return "5"
                default: return "Date"
                    
                }
            }
        }
        return ""
    }
  
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                changeLanguageBtn.setImage(UIImage(named: "fr_white"), for: .normal)
            } else if selectedLanguage == "en" {
                changeLanguageBtn.setImage(UIImage(named: "eng_white"), for: .normal)
            }
        }
    }
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main

        firstNameTF.placeholder = NSLocalizedString("First_name", tableName: nil, bundle: bundle, value: "", comment: "First_name")
        lastNameTF.placeholder = NSLocalizedString("Last_name", tableName: nil, bundle: bundle, value: "", comment: "Last_name")
        birthdayTextField.placeholder = NSLocalizedString("birthday", tableName: nil, bundle: bundle, value: "", comment: "birthday")
        nextBtn.setTitle(NSLocalizedString("Next", tableName: nil, bundle: bundle, value: "", comment: "Next"), for: .normal)
        welcomeLabel.text = NSLocalizedString("LabelText", tableName: nil, bundle: bundle, value: "", comment: "LabelText")
        errofFirstNameLabel.text = NSLocalizedString("erreurFirstName1", tableName: nil, bundle: bundle, value: "", comment: "erreurFirstName1")
        errofFirstNameLabel.text = NSLocalizedString("erreurFirstName2", tableName: nil, bundle: bundle, value: "", comment: "erreurFirstName2")
        errorLastNameLabel.text = NSLocalizedString("erreurLastName1", tableName: nil, bundle: bundle, value: "", comment: "erreurFirstName1")
        errorLastNameLabel.text = NSLocalizedString("erreurLastName2", tableName: nil, bundle: bundle, value: "", comment: "erreurFirstName2")
        errorEmaillabel.text = NSLocalizedString("erreurEmail1", tableName: nil, bundle: bundle, value: "", comment: "erreurEmail1")
        errorEmaillabel.text = NSLocalizedString("erreurEmail2", tableName: nil, bundle: bundle, value: "", comment: "erreurEmail2")
        errorBirthdayLabel.text = NSLocalizedString("erreurBirthday1", tableName: nil, bundle: bundle, value: "", comment: "erreurEmail1")
        errorBirthdayLabel.text = NSLocalizedString("erreurBirthday2", tableName: nil, bundle: bundle, value: "", comment: "erreurEmail2")
        genderLabel.text = NSLocalizedString("gender1", tableName: nil, bundle: bundle, value: "", comment: "gender1")
        genderLabel.text = NSLocalizedString("gender2", tableName: nil, bundle: bundle, value: "", comment: "gender2")
        genderLabel.text = NSLocalizedString("gender3", tableName: nil, bundle: bundle, value: "", comment: "gender3")
        footerLabel.text = NSLocalizedString("footer", tableName: nil, bundle: bundle, value: "", comment: "footer")
        
    }
    
    @IBAction func languageButton(_ sender: Any) {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)
        
        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { action in
                if action.title == "English" {
                    LanguageManager.shared.currentLanguage = "en"
                    UserDefaults.standard.set("en", forKey: "selectedLanguage")
                    self.changeLanguageBtn.setImage(UIImage(named: "eng_white"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.changeLanguageBtn.setImage(UIImage(named: "fr_white"), for: .normal)
                }
                
                self.updateLocalizedStrings()
                self.listeDeroulante()
                self.view.setNeedsLayout() // Refresh the layout of the view
            }
            languageAlert.addAction(action)
            listeDeroulante()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        languageAlert.addAction(cancelAction)
        
        present(languageAlert, animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func invalidBirthday(_ value: String) -> String? {
        if value.isEmpty {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Ce champs ne peut pas être vide."
            }
            if LanguageManager.shared.currentLanguage == "en" {
                return "This field cannot be blank."
            }
        }

        let regularExpression = "^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        if !predicate.evaluate(with: value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Format de date invalide."
            }
            if LanguageManager.shared.currentLanguage == "en" {
                return "Invalid date format."
            }
        }

        // Additional validation for valid date can be added here if needed.

        return nil
    }

    @IBAction func birthdayChanged(_ sender: Any) {
        if let birthday = birthdayTextField.text {
             if let errorMessage = invalidBirthday(birthday) {
                 errorBirthdayLabel.text = errorMessage
                 errorBirthdayLabel.isHidden = false
                 birthdayTextField.layer.borderColor = UIColor(named: "redControl")?.cgColor
//                 firstNameTF.setupRightSideImage(image: "error", colorName: "redControl")
             } else {
                 errorBirthdayLabel.isHidden = true
                 birthdayTextField.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
//                 firstNameTF.setupRightSideImage(image: "done", colorName: "vertDone")

             }
         }
        
    }
    
    
    func invalidFirstName(_ value: String) -> String? {
        if value.isEmpty {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Ce champ ne peut pas être vide."
            }
            if LanguageManager.shared.currentLanguage == "en" {
                return "This field cannot be blank."
            }
        }

        let regularExpression = "^[a-zA-Z]{1,20}$" // Assuming first name should only contain letters and have a length of 1 to 20 characters.
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        if !predicate.evaluate(with: value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Prénom non valide."
            }
            if LanguageManager.shared.currentLanguage == "en" {
                return "Invalid first name."
            }
        }
        
        return nil
    }

    @IBAction func firstNameTextField(_ sender: Any) {
        if let firstName = firstNameTF.text {
             if let errorMessage = invalidFirstName(firstName) {
                 errofFirstNameLabel.text = errorMessage
                 errofFirstNameLabel.isHidden = false
                 firstNameTF.layer.borderColor = UIColor(named: "redControl")?.cgColor
                 firstNameTF.setupRightSideImage(image: "error", colorName: "redControl")
             } else {
                 errofFirstNameLabel.isHidden = true
                 firstNameTF.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                 firstNameTF.setupRightSideImage(image: "done", colorName: "vertDone")

             }
         }

    }
    

    @IBAction func emailTextField(_ sender: Any) {
        if let email = emailTextField.text {
            if let errorMessage = invalidEmail(email) {
                errorEmaillabel.text = errorMessage
                errorEmaillabel.isHidden = false
                errorEmaillabel.layer.borderColor = UIColor(named: "redControl")?.cgColor
                emailTextField.setupRightSideImage(image: "error", colorName: "redControl")
                emailTextField.setupRightSideImage(image: "error", colorName: "redControl")
            } else {
                errorEmaillabel.isHidden = true
                emailTextField.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                emailTextField.setupRightSideImage(image: "done", colorName: "vertDone")

            }
        }
        
//        checkForValidForm()
    }
    func invalidEmail(_ value: String) -> String?
    {
        if value.isEmpty {
            if LanguageManager.shared.currentLanguage == "fr"{
            return "Ce champ ne peut pas être vide. "
            }
            if LanguageManager.shared.currentLanguage == "en"{
            return "This field cannot be blank."
            }
        }
        
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        
        if !predicate.evaluate(with: value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Votre Email n'est pas valide"
            } else {
                return "Your email is not valid"
            }
        }
        
        return nil
    }
    
    @IBAction func genderTextField(_ sender: Any) {
    }
    func invalidLastName(_ value: String) -> String? {
        if value.isEmpty {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Ce champ ne peut pas être vide."
            }
            if LanguageManager.shared.currentLanguage == "en" {
                return "This field cannot be blank."
            }
        }

        let regularExpression = "^[a-zA-Z]{1,20}$" // Assuming first name should only contain letters and have a length of 1 to 20 characters.
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        if !predicate.evaluate(with: value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Nom non valide."
            }
            if LanguageManager.shared.currentLanguage == "en" {
                return "Invalid Last name."
            }
        }
        
        return nil
    }
    @IBAction func lastNameTextField(_ sender: Any) {
        if let lastName = lastNameTF.text {
             if let errorMessage = invalidLastName(lastName) {
                 errorLastNameLabel.text = errorMessage
                 errorLastNameLabel.isHidden = false
                 lastNameTF.layer.borderColor = UIColor(named: "redControl")?.cgColor
                 lastNameTF.setupRightSideImage(image: "error", colorName: "redControl")             } else {
                 errorLastNameLabel.isHidden = true
                 lastNameTF.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                 lastNameTF.setupRightSideImage(image: "done", colorName: "vertDone")

             }
         }
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let dateformat = DateFormatter()
        dateformat.locale = NSLocale.current
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

