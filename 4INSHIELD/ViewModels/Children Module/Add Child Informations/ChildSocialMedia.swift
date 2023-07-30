//
//  ChildSocialMedia.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 23/3/2023.
//
import Foundation
import Alamofire
import UIKit

class ChildSocialMedia: KeyboardHandlingBaseVC {
    
    
    @IBOutlet weak var socialMediaTF: UITextField!
    @IBOutlet weak var socialPseudoTF: UITextField!
    @IBOutlet weak var socialUrlTF: UITextField!
    @IBOutlet weak var sauterBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentInsetAdjustmentBehavior = .never
            
        }
    }
    
    var selectedSocialMedia: String?
    var selectedSocialMediaID: Int?
    //    var socialMediaList = [Int : String]()
    var socialMediaList:[Int : String] = [1:"twitter", 2:"instagram", 3:"youtube", 4:"snapchat",5:"tumblr",6:"pinterest",7:"reddit",8:"facebook",9:"quora"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Create PickerView
        let pickerView = UIPickerView()
        pickerView.delegate = self
        socialMediaTF.inputView = pickerView
        pickerView.backgroundColor = UIColor.white
        pickerView.layer.borderColor = Colrs.bgColor.cgColor
        pickerView.layer.borderWidth = 1.0
        pickerView.layer.cornerRadius = 7.0
        pickerView.layer.masksToBounds = true
        
        //Dismiss PickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        button.tintColor = Colrs.bgColor
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        socialMediaTF.inputAccessoryView = toolBar
        
        
        //Buttons style
        sauterBtn.applyGradient()
    }
    // MARK: - Actions
    @objc func action() {
        view.endEditing(true)
    }
    
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        guard let socialMedia = socialMediaTF.text, !socialMedia.isEmpty else {
            showAlert(with: "Please pick child's social media")
            return
        }
        guard let pseudo = socialPseudoTF.text, !pseudo.isEmpty else {
            showAlert(with: "Please enter the pseudo")
            return
        }
        guard let url = socialUrlTF.text, !url.isEmpty else {
            showAlert(with: "Please enter the url")
            return
        }
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            print("Username not found")
            return
        }
//        guard let childID = UserDefaults.standard.string(forKey: "childID")else {
//            print("childID not found")
//            return
//        }
        
        // ApiManagerAdd.shareInstance1.getLastregistredChildID(withUsername: username) { lastChildID in
        
        //ApiManagerAdd.shareInstance1.getLastregistredChildID(withUsername: "asidiki") { lastChildID in
            //print("Last child's ID is : \ChildID)")
        //UserDefaults.standard.set(lastChildID, forKey: "childID")
       // }
        
        let childID = UserDefaults.standard.integer(forKey: "childID")
        guard let mediaID = self.selectedSocialMediaID else {return}
        
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
        let wizardParam = Wizard(user: userID, wizardStep: 2, platform: "mobile", date: dateString)
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
                           // self.platform()
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
    
}



extension ChildSocialMedia: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return socialMediaList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return socialMediaList[row+1]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if let _ = socialMediaList[row+1] {//Prevent "Index out of range" error
            selectedSocialMedia = socialMediaList[row+1]
            socialMediaTF.text = selectedSocialMedia
            selectedSocialMediaID = socialMediaList.findKey(forValue : socialMediaList[row+1]!)
//            print(selectedSocialMediaID)
        }

    }
}

// for searching key by value you firstly add the extension
extension Dictionary where Value: Equatable {
    func findKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}


