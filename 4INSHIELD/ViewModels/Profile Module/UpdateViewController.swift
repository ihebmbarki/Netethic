//
//  UpdateViewController.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 2/5/2023.
//

import UIKit
import Foundation
import DLRadioButton

class UpdateViewController: UIViewController {

    @IBOutlet weak var prenomTf: UITextField!
    @IBOutlet weak var nomTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var numeroTf: UITextField!
    
    @IBOutlet weak var parent1Btn: DLRadioButton!
    @IBOutlet weak var parent2: DLRadioButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpDesign()
        getCurrentUserData()
        
        //Radio Buttons group property
        parent1Btn.otherButtons = [parent2]
        parent2.otherButtons = [parent1Btn]

        //Set the corner radius
        parent1Btn.layer.cornerRadius = parent1Btn.frame.width / 2
        parent2.layer.cornerRadius = parent2.frame.width / 2

    }
    
    func getCurrentUserData() {
//        guard let savedUserName = UserDefaults.standard.string(forKey: "userName") else { return }
        let savedUserName = "kaxavy"
        DispatchQueue.main.async {
            APIManager.shareInstance.fetchCurrentUserData(username: savedUserName) { user in
                self.prenomTf.text = user.first_name
                self.nomTf.text = user.last_name
                self.emailTf.text = user.email
                self.dateTextField.text = user.birthday
            }
        }
    }
    
    func setUpDesign() {
        //Add Padding to Textfields
        let prenomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let nomPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let numeroPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let datePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        
        //Set up firstname textfield
        prenomTf.layer.borderWidth = 1
        prenomTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        prenomTf.layer.cornerRadius = prenomTf.frame.size.height/2
        prenomTf.layer.masksToBounds = true
        prenomTf.leftView = prenomPaddingView
        prenomTf.leftViewMode = .always
        
        //Set up lastname textfield
        nomTf.layer.borderWidth = 1
        nomTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        nomTf.layer.cornerRadius = nomTf.frame.size.height/2
        nomTf.layer.masksToBounds = true
        nomTf.leftView = nomPaddingView
        nomTf.leftViewMode = .always
        
        //Set up date textfield
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        dateTextField.layer.cornerRadius = dateTextField.frame.size.height/2
        dateTextField.layer.masksToBounds = true
        dateTextField.leftView = datePaddingView
        dateTextField.leftViewMode = .always
        
        //Set up email textfield
        emailTf.layer.borderWidth = 1
        emailTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        emailTf.layer.cornerRadius = emailTf.frame.size.height/2
        emailTf.layer.masksToBounds = true
        emailTf.leftView = emailPaddingView
        emailTf.leftViewMode = .always
        
        //Set up numero textfield
        numeroTf.layer.borderWidth = 1
        numeroTf.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        numeroTf.layer.cornerRadius = numeroTf.frame.size.height/2
        numeroTf.layer.masksToBounds = true
        numeroTf.leftView = numeroPaddingView
        numeroTf.leftViewMode = .always
        
        //Set up buttons
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor(red: 50/255, green: 126/255, blue: 192/255, alpha: 1).cgColor
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height/2
        cancelBtn.layer.masksToBounds = true
        updateBtn.applyGradient()
        updateBtn.layer.cornerRadius = updateBtn.frame.size.height/2
        updateBtn.layer.masksToBounds = true
    }
    
    @IBAction func radioButtonTapped(_ sender: DLRadioButton) {
        switch sender.tag {
        case 0:
            print("parent 1")
        case 1: // female
            print("parent 2")
        default:
            break
        }
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
    }
    

}
