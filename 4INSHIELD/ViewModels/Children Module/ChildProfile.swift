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
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        guard let firstName =  firstNameTF.text else { return }
        guard let lastName =  lastNameTF.text else { return }
        
        let date = birthdayDatePicker.date
        let stringDate = date.getFormattedDate(format: "yyyy-MM-dd")
    
        guard let userID = UserDefaults.standard.value(forKey: "userID") as? Int else {return}
        print(userID)
        
        let regData = [
            "parent": userID,
            "first_name": firstName,
            "last_name": lastName,
            "birthday":stringDate,
            "gender": gender,
        ] as [String : Any]
         let child = Childd(dictionary: regData)
        
        APIManager.shareInstance.addChildInfos(registerData: child) { result in
            switch result {
            case .success (_):
                print("child added")
                
            case .failure(let error):
                print("Failed to add child")
                print("Error: \(error.localizedDescription)")
            }
         
        }     
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
