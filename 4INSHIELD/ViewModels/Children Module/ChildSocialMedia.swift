//
//  ChildSocialMedia.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 23/3/2023.
//
import Foundation
import UIKit

class ChildSocialMedia: UIViewController {

    
    @IBOutlet weak var socialMediaTF: UITextField!
    @IBOutlet weak var socialPseudoTF: UITextField!
    @IBOutlet weak var socialUrlTF: UITextField!
    
    @IBOutlet weak var sauterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Buttons style
        sauterBtn.applyGradient()
    }

    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        guard let socialMedia = socialMediaTF.text, !socialMedia.isEmpty else {
            showAlert(with: "Please enter child's social media")
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
//        guard let childIDString = UserDefaults.standard.string(forKey: "childID"),
//              let childID = Int(childIDString) else {
//            print("child ID not found")
//            return
//        }
        guard let userIDString = UserDefaults.standard.string(forKey: "userID"),
              let userID = Int(userIDString) else {
            print("User ID not found")
            return
        }
        let socialData = Profil(id:50,social_media_name:socialMedia,pseudo:pseudo,url:url)
        
        APIManager.shareInstance.addSocialMediaProfile(socialData: socialData) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Success", message: "Child social media added successfully!", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                let date = Date()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let dateString = df.string(from: date)

                let x = [
                    "user": userID,
                    "wizard_step": 2,
                    "platform": "mobile",
                    "date": dateString
                ] as [String : Any]
                do {
                    let journey = try UserJourney(from: x as! Decoder)
                    APIManager.shareInstance.saveUserJourney(journeyData: journey) { userJourney in
                        print(userJourney)
                    }
                } catch (let error) {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}
