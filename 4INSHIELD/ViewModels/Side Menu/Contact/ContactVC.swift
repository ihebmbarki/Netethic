//
//  ContactVC.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 24/7/2023.
//

import UIKit

class ContactVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var objectTF: UITextField!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SetUpContactDesign()
    }
    
    func SetUpContactDesign() {
        //Add Padding to Textfields
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let objectPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let messagePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        
        //Set up name textfield
        nameTF.layer.borderWidth = 1
        nameTF.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        nameTF.layer.cornerRadius = nameTF.frame.size.height/2
        nameTF.layer.masksToBounds = true
        nameTF.leftView = namePaddingView
        nameTF.leftViewMode = .always
        
        //Set up email textfield
        emailTF.layer.borderWidth = 1
        emailTF.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        emailTF.layer.cornerRadius = emailTF.frame.size.height/2
        emailTF.layer.masksToBounds = true
        emailTF.leftView = emailPaddingView
        emailTF.leftViewMode = .always
        
        //Set up object textfield
        objectTF.layer.borderWidth = 1
        objectTF.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        objectTF.layer.cornerRadius = objectTF.frame.size.height/2
        objectTF.layer.masksToBounds = true
        objectTF.leftView = objectPaddingView
        objectTF.leftViewMode = .always
        
        //Set up message textfield
        messageTF.layer.borderWidth = 1
        messageTF.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        messageTF.layer.cornerRadius = messageTF.frame.size.height/2
        messageTF.layer.masksToBounds = true
        messageTF.leftView = messagePaddingView
        messageTF.leftViewMode = .always
        
        //Set up send button
        sendBtn.layer.cornerRadius = sendBtn.frame.size.height/2
        sendBtn.layer.masksToBounds = true
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
    }
    
    @IBAction func backBtn(_ sender: Any) {
    }
    
}
