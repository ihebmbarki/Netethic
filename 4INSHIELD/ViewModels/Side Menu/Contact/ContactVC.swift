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
        messageTF.layer.cornerRadius = 10
        messageTF.layer.masksToBounds = true
        messageTF.leftView = messagePaddingView
        messageTF.leftViewMode = .always
        
        //Set up send button
        sendBtn.layer.cornerRadius = sendBtn.frame.size.height/2
        sendBtn.layer.masksToBounds = true
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func resetFields() {
        nameTF.text = ""
        emailTF.text = ""
        objectTF.text = ""
        messageTF.text = ""
    }

    @IBAction func sendBtnTapped(_ sender: Any) {
        guard let name = self.nameTF.text,
              let email = self.emailTF.text,
              let object = self.objectTF.text,
              let message = self.messageTF.text else { return }
        
        let userID = UserDefaults.standard.object(forKey: "userID")

        let contactForm = ContactForm(id: userID as! Int, subject: object, message: message, username: name, email: email)
        // Print the contactForm object before sending it
            print("Contact Form Object: \(contactForm)")

        APIManager.shareInstance.sendContactForm(contactForm: contactForm) { isSuccess, str in
            if isSuccess {
                // Successfully sent the contact form
                self.showAlert(message: str)
                self.resetFields()
            } else {
                // Failed to send the contact form
                self.showAlert(message: str)
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
