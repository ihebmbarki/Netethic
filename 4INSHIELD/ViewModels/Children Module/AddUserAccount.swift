//
//  AddUserAccount.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 18/7/2023.
//

import UIKit

class AddUserAccount: KeyboardHandlingBaseVC {
    
    
    //IBOutlets
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var confirmPasswordTf: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!

    //Variables
    var childInfo: ChildRegisterModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SetUpDesign()
        
        // Call loadChildInfo with the completion handler to populate the text fields
        loadChildInfo { [weak self] childInfo in
            self?.childInfo = childInfo
            DispatchQueue.main.async {
                self?.usernameTf.text = childInfo.username
                self?.emailTf.text = childInfo.email
            }
        }
       
    }
    
    func SetUpDesign() {
        //Add Padding to Textfields
        let usernamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        let confirmPasswordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))

        //Set up firstname textfield
        usernameTf.layer.borderWidth = 1
        usernameTf.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        usernameTf.layer.cornerRadius = usernameTf.frame.size.height/2
        usernameTf.layer.masksToBounds = true
        usernameTf.leftView = usernamePaddingView
        usernameTf.leftViewMode = .always
        
        //Set up lastname textfield
        emailTf.layer.borderWidth = 1
        emailTf.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        emailTf.layer.cornerRadius = emailTf.frame.size.height/2
        emailTf.layer.masksToBounds = true
        emailTf.leftView = emailPaddingView
        emailTf.leftViewMode = .always
        
        //Set up date textfield
        passwordTf.layer.borderWidth = 1
        passwordTf.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        passwordTf.layer.cornerRadius = passwordTf.frame.size.height/2
        passwordTf.layer.masksToBounds = true
        passwordTf.leftView = passwordPaddingView
        passwordTf.leftViewMode = .always
        
        //Set up date textfield
        confirmPasswordTf.layer.borderWidth = 1
        confirmPasswordTf.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        confirmPasswordTf.layer.cornerRadius = confirmPasswordTf.frame.size.height/2
        confirmPasswordTf.layer.masksToBounds = true
        confirmPasswordTf.leftView = confirmPasswordPaddingView
        confirmPasswordTf.leftViewMode = .always
        
        //Set up buttons
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = UIColor(red: 0.34, green: 0.35, blue: 0.90, alpha: 1.00).cgColor
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height/2
        cancelBtn.layer.masksToBounds = true
        createBtn.layer.cornerRadius = createBtn.frame.size.height/2
        createBtn.layer.masksToBounds = true
    }
   
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func resetFields() {
        usernameTf.text = ""
        emailTf.text = ""
        passwordTf.text = ""
        confirmPasswordTf.text = ""
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToConfirmation(withId identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ConfirmationVC = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(ConfirmationVC, animated: true)
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        guard let username = self.usernameTf.text, !username.isEmpty else {
            showAlert(message: "Please enter a username")
            return
        }
        guard let email = self.emailTf.text, !email.isEmpty else {
            showAlert(message: "Please enter an email")
            return
        }
        guard let password = self.passwordTf.text, !password.isEmpty else {
            showAlert(message: "Please enter a password")
            return
        }
        guard let confirmPassword = self.confirmPasswordTf.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please confirm the password")
            return
        }

        // Check if passwords match
        if password != confirmPassword {
            showAlert(message: "Passwords do not match")
            return
        }

        // Create the childRegister with default values for non-optional properties
        let childRegister = ChildRegisterModel(email: email, username: username, password: password, email_verification_url: email)

        loadChildInfo { childInfo in
            // Update childRegister with the loaded child information
            childRegister.first_name = childInfo.first_name
            childRegister.last_name = childInfo.last_name
            childRegister.gender = childInfo.gender

            APIManager.shareInstance.registerChildAPI(register: childRegister) { (isSuccess, str) in
                if isSuccess {
                    // Child user registered successfully
                    self.goToConfirmation(withId: "ConfirmationID")
                } else {
                    self.showAlert(message: str)
                }
            }
            self.resetFields()
        }
    }


    func loadChildInfo(completion: @escaping (ChildRegisterModel) -> Void) {
        guard let savedChildID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }

        APIManager.shareInstance.fetchChild(withID: savedChildID) { child in
            guard let username = child.user?.username,
                  let email = child.user?.email else {
                // Handle error or default values if required
                return
            }

            let childInfo = ChildRegisterModel(
                email: email,
                username: username,
                password: "",
                email_verification_url: email
            )

            // Set properties separately
            childInfo.first_name = child.user?.first_name ?? ""
            childInfo.last_name = child.user?.last_name ?? ""
            childInfo.gender = child.user?.gender ?? ""
            childInfo.enabled = child.enabled!
            childInfo.street = child.street ?? ""
            childInfo.country = Int(child.country ?? "") ?? 0
            childInfo.birthday = child.user?.birthday ?? ""

            completion(childInfo)
        }
    }

    
}
