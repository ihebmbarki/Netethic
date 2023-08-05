//
//  ChildProfile.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 22/3/2023.
//
import Foundation
import Alamofire
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
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    var userParentID = Int()
//    let progressBarVC = ProgressBarViewController()
    
    
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
        nextBtn.layer.cornerRadius = 10
        
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
        guard let lastName = self.lastNameTF.text else { return}
        guard let gender = self.genderTF.text else { return}
        guard let email = self.emailTextField.text else { return }
        
        let date = birthdayDatePicker.date
        let stringDate = date.getFormattedDate(format: "yyyy-MM-dd")
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
            
        
        //                let date = Date()
        //                let df = DateFormatter()
        //                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //                let dateString = df.string(from: date)
        //
        //                let x = [
        //                    "user": userId,
        //                    "wizard_step": 1,
        //                    "platform": "mobile",
        //                    "date": dateString
        //                ] as [String : Any]
        //
        //                do {
        //                    let journey = try UserJourney(from: x as! Decoder)
        //                    ApiManagerAdd.shareInstance1.saveUserJourney(journeyData: journey) { userJourney in
        //                        print(userJourney)
        //                    }
        //                } catch let error {
        //                    print(error.localizedDescription)
        //                }
        //            } else {
        //                print(str)
        //            }
        //        }
    }
    
    //    func responseChild(params: ChildModel) {
    //       // let headers: HTTPHeaders = ["Content-Type":"application/json"]
    //        AF.request(add_Child_url, method: .post, parameters: params, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<500)
    //            .responseJSON(completionHandler: { (response) in
    //
    //                debugPrint(response)
    //                switch response.result {
    //                case .success(let data):
    //                    switch response.response?.statusCode {
    //                    case 200,201:
    //                        /// Handle success, parse JSON data
    //                        do {
    //                            let jsonData = try JSONDecoder().decode(UserRole.self, from: JSONSerialization.data(withJSONObject: data))
    //                            let alertController = UIAlertController(title: "Success", message: "Child social media added successfully!", preferredStyle: .alert)
    //                            let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
    //                                self.dismiss(animated: true, completion: nil)
    //                            }
    //                            alertController.addAction(okayAction)
    //                            self.present(alertController, animated: true, completion: nil)
    //                            print("User child registered successfully")
    //                           // self.platform()
    //                        } catch let error {
    //                            /// Handle json decode error
    //                            print(error)
    //                        }
    //                    case 401:
    //                        /// Handle 401 error
    //                        print("not authorization")
    //                    default:
    //                        /// Handle unknown error
    //                        print("we ran into error")
    //                    }
    //                case .failure(let error):
    //                    /// Handle request failure
    //                    print(error.localizedDescription)
    //                }
    //            })
    //    }
    //
    

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
            constant: 240
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
        progressBarWithDifferentDimensions.completedTillIndex = 1
    }
    
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        progressBar.currentIndex = index
        if index > maxIndex {
            maxIndex = index
            progressBar.completedTillIndex = maxIndex
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
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

