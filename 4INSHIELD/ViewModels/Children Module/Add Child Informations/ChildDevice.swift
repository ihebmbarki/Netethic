//
//  ChildDevice.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 23/3/2023.
//
import Foundation
import UIKit

class ChildDevice: UIViewController {

    @IBOutlet weak var sauterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Buttons style
        sauterBtn.applyGradient()
    }
    
    

    @IBAction func continueBtnTapped(_ sender: Any) {
        guard let userIDString = UserDefaults.standard.string(forKey: "userID"),
              let userID = Int(userIDString) else {
            print("User ID not found")
            return
        }
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = df.string(from: date)

        let x = [
            "user": userID,
            "wizard_step": 4,
            "platform": "mobile",
            "date": dateString
        ] as [String : Any]
        let journey = UserJourney(dictionary: x)
        
        APIManager.shareInstance.saveUserJourney(journeyData: journey) { userJourney in
            print(userJourney)
        }
    }
}
