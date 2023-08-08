//
//  ChildSocialMedia.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 23/3/2023.
//
import Foundation
import Alamofire
import UIKit
import FlexibleSteppedProgressBar
import DropDown


class ChildSocialMedia: KeyboardHandlingBaseVC, FlexibleSteppedProgressBarDelegate {
    
    
    @IBOutlet weak var sauterBtn: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentInsetAdjustmentBehavior = .never
            
        }
    }
    
    @IBOutlet weak var errorPseudoLabel: UILabel!
    
    @IBOutlet weak var errorUrlLabel: UILabel!
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var socialMediaTextField: UITextField!
    
    @IBOutlet weak var socialMediaLabel: UILabel!
    @IBOutlet weak var socialMediaView: UIView!
    var selectedSocialMedia: String?
    var selectedSocialMediaID: Int?
    //    var socialMediaList = [Int : String]()
    var mediaID: Int = 0
    let menu: DropDown = {
           let menu = DropDown()
           menu.dataSource = [
            "Twitter", "Instagram", "Youtube", "Snapchat","Tumblr","Pinterest","Reddit","Facebook","Quora"
           ]
           return menu
       }()
//    var socialMediaList:[Int : String] = [1:"twitter", 2:"instagram", 3:"youtube", 4:"snapchat",5:"tumblr",6:"pinterest",7:"reddit",8:"facebook",9:"quora"]
    
    var progressBar: FlexibleSteppedProgressBar!
    var progressBarWithoutLastState: FlexibleSteppedProgressBar!
    var progressBarWithDifferentDimensions: FlexibleSteppedProgressBar!
    
    var backgroundColor = UIColor(named: "AccentColor")
    var progressColor = UIColor(named: "AccentColor")
    var textColorHere = UIColor.white
    var maxIndex = -1
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //appel Progressbar
        setupProgressBarWithDifferentDimensions()
//        TextField border
        urlTextField.setupBorderTF()
        pseudoTextField.setupBorderTF()
        socialMediaTextField.setupBorderTF()
        
        //Buttons style
        sauterBtn.applyGradient()
        sauterBtn.setupBorderBtn()
        nextButton.setupBorderBtn()
        nextButton.setImage(UIImage(named: "next")!.withTintColor(UIColor(named: "AccentColor")!, renderingMode: .alwaysTemplate), for: .normal)
        nextButton.imageEdgeInsets = UIEdgeInsets(top : 0, left : 30 , bottom : 0, right : -130 )
        nextButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -22, bottom: 0, right: 0)
        //controle de saisie
        
        resetForm()
//        nextButton.isHidden = false
        // liste déroulante
        menu.anchorView = socialMediaView
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem))
            gesture.numberOfTapsRequired = 1
            gesture.numberOfTouchesRequired = 1
        socialMediaView.addGestureRecognizer(gesture)
            menu.selectionAction = { index, title in
                print(index)
                self.mediaID = index + 1
                print(title)
                self.socialMediaLabel.text = title
            }
    }
    
    @objc func didTapTopItem(){
         menu.show()
     }
    // MARK: - Actions
    @objc func action() {
        view.endEditing(true)
    }
    func resetForm(){
//        nextButton.isEnabled = true
           errorUrlLabel.isHidden = true
            errorPseudoLabel.isHidden = true
        }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func nextButton(_ sender: Any) {
        print("cliquekkkkkkkkkk")
        let childID = UserDefaults.standard.integer(forKey: "childID")
        let pseudo = pseudoTextField.text!
        let url = urlTextField.text!
        if mediaID == 0 {mediaID = 1}
        let params = profil1(child: childID, social_media_name: mediaID, pseudo: pseudo, url: url)
        self.response(params: params)
   
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
        let wizardParam = Wizard(user: userID, wizardStep: 3, platform: "mobile", date: dateString)
        //        do {
        //            let journey = try UserJourney(from: x as! Decoder)
        //            ApiManagerAdd.shareInstance1.saveUserJourney(journeyData: journey) { userJourney in
        //                print(userJourney)
        //            }
        //
        //        }
      
        //pour retour
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
                        print("not authorization")
                    default:
                        /// Handle unknown error
                        print("we ran into error")
                    }
                case .failure(let error):
                    /// Handle request failure
                    print(error.localizedDescription)
                }
            })
    }
    
    
    func response(params: profil1) {
        AF.request(add_Child_Profile, method: .post, parameters: params, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<500)
            .responseJSON(completionHandler: { (response) in
                
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    switch response.response?.statusCode {
                    case 200,201:
                        /// Handle success, parse JSON data
                        do {
                            let jsonData = try JSONDecoder().decode(Profil.self, from: JSONSerialization.data(withJSONObject: data))
                            let alertController = UIAlertController(title: "Success", message: "Child social media added successfully!", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                                //self.dismiss(animated: true, completion: nil)
                                if let childrenListVC = UIStoryboard(name: "Children", bundle: nil).instantiateViewController(withIdentifier: "ChildrenListSB") as? ChildrenViewController {
                                    self.present(childrenListVC, animated: true, completion: nil)
                                }
                            }
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            print("good")
                            self.platform()
                        } catch let error {
                            /// Handle json decode error
                            print(error)
                        }
                    case 401:
                        /// Handle 401 error
                        print("not authorization")
                    default:
                        /// Handle unknown error
                        print("we ran into error")
                    }
                case .failure(let error):
                    /// Handle request failure
                    print(error.localizedDescription)
                }
            })
    }
    
    func setupProgressBarWithDifferentDimensions() {
        progressBarWithDifferentDimensions = FlexibleSteppedProgressBar()
        progressBarWithDifferentDimensions.translatesAutoresizingMaskIntoConstraints = false
        self.progressBarView.addSubview(progressBarWithDifferentDimensions)
        
        // iOS9+ auto layout code
        let horizontalConstraint = progressBarWithDifferentDimensions.centerXAnchor.constraint(equalTo: self.progressBarView.centerXAnchor)
        let verticalConstraint = progressBarWithDifferentDimensions.topAnchor.constraint(
            equalTo: progressBarView.topAnchor,
            constant: 152
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
    
    func invalidUrl(_ value: String) -> String?{
        if value.isEmpty {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Ce champ ne peut pas être vide. "
            }
            if LanguageManager.shared.currentLanguage == "en" {
                return "This field cannot be blank."
            }
        }
        
        let reqularExpression = #"^(https?|ftp)://[^\s/$.?#].[^\s]*$"#  // Expression régulière pour valider une URL
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        
        if !predicate.evaluate(with: value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "L'URL n'est pas valide"
            } else {
                return "The URL is not valid"
            }
        }
        
        return nil
    }
    func invalidPseudo(_ value: String) -> String? {
        if value.isEmpty {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Ce champ ne peut pas être vide. "
            }
            if LanguageManager.shared.currentLanguage == "en" {
                return "This field cannot be blank."
            }
        }
        
        // Expression régulière pour valider un pseudo (n'autorise que les lettres, chiffres, tirets et underscores)
        let reqularExpression = "^[a-zA-Z0-9_-]{3,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        
        if !predicate.evaluate(with: value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Votre Pseudo n'est pas valide"
            } else {
                return "The Pseudo is not valid"
            }
        }
        
        return nil
    }

    func checkForValidForm()
    {
        if errorUrlLabel.isHidden && errorPseudoLabel.isHidden
        {
            nextButton.isEnabled = false
        }
        else
        {
            nextButton.isEnabled = true
        }
    }
    @IBAction func urlChanged(_ sender: Any) {
        if let url = urlTextField.text {
             if let errorMessage = invalidUrl(url) {
                 errorUrlLabel.text = errorMessage
                 errorUrlLabel.isHidden = false
                 urlTextField.layer.borderColor = UIColor(named: "redControl")?.cgColor
                 urlTextField.setupRightSideImage(image: "error", colorName: "redControl")             } else {
                 errorUrlLabel.isHidden = true
                 urlTextField.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                 urlTextField.setupRightSideImage(image: "done", colorName: "vertDone")

             }
//            checkForValidForm()
         }
    }
    
    @IBAction func pseudoChanged(_ sender: Any) {
        if let pseudo = pseudoTextField.text {
             if let errorMessage = invalidPseudo(pseudo) {
                 errorPseudoLabel.text = errorMessage
                 errorPseudoLabel.isHidden = false
                 pseudoTextField.layer.borderColor = UIColor(named: "redControl")?.cgColor
                 pseudoTextField.setupRightSideImage(image: "error", colorName: "redControl")
                 
                } else {
                     errorPseudoLabel.isHidden = true
                     pseudoTextField.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                     pseudoTextField.setupRightSideImage(image: "done", colorName: "vertDone")
             }
//            checkForValidForm()
         }
    }
}



//extension ChildSocialMedia: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return socialMediaList.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return socialMediaList[row+1]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        if let _ = socialMediaList[row+1] {//Prevent "Index out of range" error
//            selectedSocialMedia = socialMediaList[row+1]
//            socialMediaTF.text = selectedSocialMedia
//            selectedSocialMediaID = socialMediaList.findKey(forValue : socialMediaList[row+1]!)
////            print(selectedSocialMediaID)
//        }
//
//    }
//}

// for searching key by value you firstly add the extension
extension Dictionary where Value: Equatable {
    func findKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}


