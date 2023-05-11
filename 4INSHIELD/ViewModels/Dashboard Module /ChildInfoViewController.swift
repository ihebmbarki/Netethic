//
//  ChildInfoViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 10/5/2023.
//

import UIKit
import Foundation

class ChildInfoViewController: UIViewController {
    
    var selectedChild: Child?
    var ChildInfoViewController: ChildInfoViewController?
    
    @IBOutlet weak var childPhoto: UIImageView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childAgeLabel: UILabel!
    @IBOutlet weak var childAddressLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        loadChildInfos()
       }


    @IBAction func exitButtonTapped(_ sender: UIButton) {
        removeCurrentChildViewController()
        print("back")
    }
    
    func age(from birthday: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        let age = ageComponents.year ?? 0
        return age
    }
    
    func loadChildInfos() {
//        guard let selectedChild = selectedChild else { return }
        guard let savedChildID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }
        
        DispatchQueue.main.async {
            APIManager.shareInstance.fetchChild(withID: savedChildID) { child in
                self.childNameLabel.text = child.first_name + child.last_name
                self.childAddressLabel.text = child.address
                //Calculate age from birthday
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" // or whatever format your date string is in
                if let birthdayDate = dateFormatter.date(from: child.birthday) {
                    let age = self.age(from: birthdayDate)
                    self.childAgeLabel.text = "\(age) ans"
                }
                
                if (child.photo ?? "").isEmpty {
                    if child.gender == "M" {
                        self.childPhoto.image = UIImage(imageLiteralResourceName: "malePic")
                    } else {
                        self.childPhoto.image = UIImage(imageLiteralResourceName: "femalePic")
                    }
                } else {
                    self.childPhoto.loadImage(child.photo)
                }
            }
        }
    }

    func removeCurrentChildViewController() {
        // Remove current child view controller
        if ChildInfoViewController != nil && ChildInfoViewController!.view.superview != nil {
            ChildInfoViewController!.willMove(toParent: nil)
            ChildInfoViewController!.view.removeFromSuperview()
            ChildInfoViewController!.removeFromParent()
        }
    }
}
