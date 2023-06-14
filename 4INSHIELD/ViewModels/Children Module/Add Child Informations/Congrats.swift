//
//  Congrats.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 23/3/2023.
//
import Foundation
import UIKit
import FLAnimatedImage

class Congrats: UIViewController {

    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var addAnotherchildBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Load the GIF file from the main bundle
        guard let url = Bundle.main.url(forResource: "Succes", withExtension: "gif") else {
            return
        }
        
        // Create an animated image object with the GIF file data
        guard let data = try? Data(contentsOf: url), let animatedImage = FLAnimatedImage(animatedGIFData: data) else {
            return
        }
        
        // Set the animated image to your UIImageView
        gifImageView.animatedImage = animatedImage
        
        //Buttons style
        addAnotherchildBtn.applyGradient()
    }
    
    func goToScreen(withId identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(VC, animated: true)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDashboard" {
//            if let vc = segue.destination as? ChildrenViewController {
//                vc.child = self.selectedChild
//            }
//        }
//    }
    
    @IBAction func continueBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "goToChildrenList", sender: self)

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
            "wizard_step": 5,
            "platform": "mobile",
            "date": dateString
        ] as [String : Any]
        let journey = UserJourney(dictionary: x)
        
        APIManager.shareInstance.saveUserJourney(journeyData: journey) { userJourney in
            print(userJourney)
        }
    }
    
}

