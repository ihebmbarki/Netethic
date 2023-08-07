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
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var calenderButton: UIButton!
    @IBOutlet weak var birthdayTextField: UITextField!
    var userParentID = Int()
//    let progressBarVC = ProgressBarViewController()
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupProgressBar()
//        setupProgressBarWithoutLastState()
        setupProgressBarWithDifferentDimensions()
        
        //Buttons style
        nextBtn.applyGradient()
        nextBtn.layer.cornerRadius = 15
        nextBtn.setImage(UIImage(named: "next")!.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        nextBtn.imageEdgeInsets = UIEdgeInsets(top : 0, left : 0 , bottom : 0, right : -250)
        
        birthdayTextField.setupRightSideImage(image: "calendar", colorName: "AccentColor")
//        calenderButton.setImage(UIImage(named: "calendar")!.withTintColor(UIColor(named: "AccentColor")!, renderingMode: .alwaysTemplate), for: .normal)
//        calenderButton.contentVerticalAlignment = .center
        
        calenderButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        
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

        // Utilisez stringDate comme nécessaire
        //   print("Formatted date: \(stringDate!)")
        
        
        //        guard let roleDataID = DataHandler.shared.roleDataID else {
        //            showAlert(message: "User ID not found")
        //            return
        //
        //        }
        let roleDataID = UserDefaults.standard.integer(forKey: "RoleDataID")
        print("Value of roleDataID: \(roleDataID)")
        var userId = Int(roleDataID)
        
        if roleDataID != 0 {
            userId = Int(roleDataID)
        }else {
            userId = 131
        }
        let stringDate = birthdayTextField.text ?? "2002-02-02"
        // let userID = Int(roleDataID)
        let regData = ChildModel(first_name: firstName, last_name: lastName, birthday: stringDate, email: email, gender: gender, parent_id: userId)
        //self.responseChild(params: regData)
        let parameters: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "birthday": stringDate,
            "gender": gender,
            "parent_id": userId
        ]
        AF.request(add_Child_url, method: .post, parameters: parameters)
            .responseDecodable(of: UserRole.self) { response in
                switch response.result {
                case .success(let user):
                    switch response.response?.statusCode {
                    case 200,201:
                    print("User child ID: \(user.child.id)")
                    UserDefaults.standard.set(user.child.id, forKey: "childID")
                    let alertController = UIAlertController(title: "Success", message: "Child added successfully!", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                        self.goToScreen(identifier: "ChildSocialMedia")
                        self.progressBarWithDifferentDimensions.completedTillIndex = 1
                    }
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    print("User child registered successfully")
                        self.platform()
                    case 401:
                        /// Handle 401 error
                        if LanguageManager.shared.currentLanguage == "fr"{
                            self.showAlert(title:"Alerte" ,message: "Désolé, qulque chose s'est mal passé.   ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                        }
                    default:
                        /// Handle unknown error
                    print(response.response?.statusCode)

                        print("we ran into error")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    /// Handle request failure
                    if LanguageManager.shared.currentLanguage == "fr"{
                        self.showAlert(title:"Alerte" ,message: "Désolé, qulque chose s'est mal passé.   ")
                    }
                    if LanguageManager.shared.currentLanguage == "en"{
                        self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                    }
                }
                    }
        
    }

    

    func goToScreen(identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ChildSocialMedia = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(ChildSocialMedia, animated: true)
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
        //        do {
        //            let journey = try UserJourney(from: x as! Decoder)
        //            ApiManagerAdd.shareInstance1.saveUserJourney(journeyData: journey) { userJourney in
        //                print(userJourney)
        //            }
        //
        //        }
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
    
    
//    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
//                     didSelectItemAtIndex index: Int) {
//        progressBar.currentIndex = index
//        if index > maxIndex {
//            maxIndex = index
//            progressBar.completedTillIndex = maxIndex
//        }
//    }
    
//    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
//                     canSelectItemAtIndex index: Int) -> Bool {
//        return true
//    }
    
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
        genderTF.placeholder = NSLocalizedString("Gender", tableName: nil, bundle: bundle, value: "", comment: "Gender")
        nextBtn.setTitle(NSLocalizedString("Next", tableName: nil, bundle: bundle, value: "", comment: "Next"), for: .normal)
        welcomeLabel.text = NSLocalizedString("LabelText", tableName: nil, bundle: bundle, value: "", comment: "LabelText")
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
                self.view.setNeedsLayout() // Refresh the layout of the view
            }
            languageAlert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        languageAlert.addAction(cancelAction)
        
        present(languageAlert, animated: true, completion: nil)
    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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

