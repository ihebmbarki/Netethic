//
//  ChildProfile.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 22/3/2023.
//

import UIKit

class ChildProfile: UIViewController {

    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    
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
                dot.tintColor = UIColor.gray
            }
        }

        // Set the current page control indicator to a numbered circle
        if let dot = pageControl.subviews[pageControl.currentPage] as? UIImageView {
            dot.image = UIImage(systemName: "\(pageControl.currentPage + 1).circle.fill")
            dot.tintColor = UIColor.blue
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
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        guard let firstName = firstNameTF.text, !firstName.isEmpty else {
            showAlert(with: "Please enter first name")
            return
        }
        guard let lastName = lastNameTF.text, !lastName.isEmpty else {
            showAlert(with: "Please enter last name")
            return
        }
        guard let gender = genderTF.text, !gender.isEmpty else {
            showAlert(with: "Please enter gender")
            return
        }
        
        let date = birthdayDatePicker.date
        let stringDate = date.getFormattedDate(format: "yyyy-MM-dd")
        
        guard let userIDString = UserDefaults.standard.string(forKey: "userID"),
              let userID = Int(userIDString) else {
            showAlert(with: "User ID not found")
            return
        }
        
        let regData = ChildModel(parent: userID, first_name: firstName, last_name: lastName, birthday: stringDate, gender: gender)
        
        APIManager.shareInstance.addChildInfos(regData: regData) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Success", message: "Child added successfully!", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                        self.goToSocial(withId: "ChildSocialMedia")
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
                    "wizard_step": 1,
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

    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
}

extension Date {
   func getFormattedDate(format: String) -> String {
       //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let dateformat = DateFormatter()
       dateformat.locale = NSLocale.current
       dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
