//
//  ChildProfile.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 22/3/2023.
//
import Foundation
import UIKit

class ChildProfile: KeyboardHandlingBaseVC {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentInsetAdjustmentBehavior = .never

        }
    }
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Set the number of pages in the page control
        pageControl.numberOfPages = 5

        // Set the current page of the page control
        pageControl.currentPage = 0

        // Set the default page control indicators to circles
        for view in pageControl.subviews {
            if let dot = view as? UIImageView {
                dot.image = UIImage(systemName: "circle.fill")
                dot.tintColor = UIColor(named: "AccentColor")
            }
        }

        // Set the current page control indicator to a numbered circle
        if let dot = pageControl.subviews[pageControl.currentPage] as? UIImageView {
            dot.image = UIImage(systemName: "\(pageControl.currentPage + 1).circle.fill")
            dot.tintColor = UIColor(named: "AccentColor")
        }
        
        //Buttons style
        nextBtn.applyGradient()
        nextBtn.layer.cornerRadius = 10
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func
    goToSocial(withId identifier: String) {
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
        ApiManagerAdd.shareInstance1.addChildInfos(regData: regData) { isSuccess, str in
            if isSuccess {
                print(str)
                let date = Date()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let dateString = df.string(from: date)
                
                let x = [
                    "user": userId,
                    "wizard_step": 1,
                    "platform": "mobile",
                    "date": dateString
                ] as [String : Any]
                
                do {
                    let journey = try UserJourney(from: x as! Decoder)
                    ApiManagerAdd.shareInstance1.saveUserJourney(journeyData: journey) { userJourney in
                        print(userJourney)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                print(str)
            }
        }
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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

