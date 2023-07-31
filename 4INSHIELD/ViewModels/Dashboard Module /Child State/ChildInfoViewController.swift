//
//  ChildInfoViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 10/5/2023.
//

import UIKit
import Foundation

class ChildInfoViewController: UIViewController {
    
    var selectedChild: Childd?
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Make childPhoto circular
        self.childPhoto.layer.cornerRadius = self.childPhoto.frame.width / 2
        self.childPhoto.layer.masksToBounds = true
        self.childPhoto.contentMode = .scaleAspectFill
        self.childPhoto.clipsToBounds = true
    }

    @IBAction func returnBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func exitButtonTapped(_ sender: UIButton) {
        //removeCurrentChildViewController()
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
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
                self.childNameLabel.text = child.user!.first_name + child.user!.last_name
                self.childAddressLabel.text = child.adress
                //Calculate age from birthday
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd" 
                if let birthdayDate = dateFormatter.date(from: child.user!.birthday) {
                    let age = self.age(from: birthdayDate)
                    self.childAgeLabel.text = "\(age) ans"
                }
                
                if (child.user?.photo ?? "").isEmpty {
                    if child.user!.gender == "M" {
                        self.childPhoto.image = UIImage(imageLiteralResourceName: "malePic")
                    } else {
                        self.childPhoto.image = UIImage(imageLiteralResourceName: "femalePic")
                    }
                } else {
                    self.childPhoto.loadImage(child.user?.photo)
                }
            }
        }
    }
    
}
