//
//  Register.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/2/2023.
//

import UIKit

class Register: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var createAccLbl: UILabel!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var register_google: UIButton!
    @IBOutlet weak var register_facebook: UIButton!
    @IBOutlet weak var haveAccLbl: UILabel!
    @IBOutlet weak var changeLanguageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Text fields lefrt side images
        usernameTF.setupLeftSideImages(ImageViewNamed: "user")
        emailTF.setupLeftSideImages(ImageViewNamed: "mail")
        passwordTF.setupLeftSideImages(ImageViewNamed: "password")
        confirmPasswordTF.setupLeftSideImages(ImageViewNamed: "password")
        
        //text fields style
        usernameTF.setupBorderTFs()
        emailTF.setupBorderTFs()
        passwordTF.setupBorderTFs()
        confirmPasswordTF.setupBorderTFs()
        
        //Buttons style
        registerBtn.applyGradients()
        register_google.setupBorderBtns()
        register_facebook.setupBorderBtns()
    }
    func updateLocalizedStrings() {
        welcomeLbl.text = NSLocalizedString("Welcome", comment: "welcome label")
        createAccLbl.text = NSLocalizedString("create_account", comment: "sign up label")
        usernameTF.placeholder = NSLocalizedString("your_username", comment: "username")
        emailTF.placeholder = NSLocalizedString("e_mail", comment: "email")
        passwordTF.placeholder = NSLocalizedString("Password", comment: "Password")
        confirmPasswordTF.placeholder = NSLocalizedString("re_type_password", comment: "Confirm Password")
        registerBtn.setTitle(NSLocalizedString("sign_up", comment: "sign up"), for: .normal)
        signInBtn.setTitle(NSLocalizedString("Login", comment: "Login"), for: .normal)
        haveAccLbl.text = NSLocalizedString("text_login", comment: "text login")
        register_google.setTitle(NSLocalizedString("signup_google", comment: "sign up google"), for: .normal)
        register_facebook.setTitle(NSLocalizedString("signup_facebook", comment: "sign up facebook"), for: .normal)
    }
    
    @IBAction func changeLanguageBtnTapped(_ sender: Any) {
        let languages = ["Anglais", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)
        
        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { action in
                if action.title == "Anglais" {
                    UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
                } else if action.title == "Français" {
                    UserDefaults.standard.set(["fr"], forKey: "AppleLanguages")
                }
                
                UserDefaults.standard.synchronize() // Save language selection
                self.updateLocalizedStrings()
                self.view.setNeedsLayout() // Refresh the layout of the view
            }
            languageAlert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        languageAlert.addAction(cancelAction)
        
        present(languageAlert, animated: true, completion: nil)
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
    
    func resetFields() {
        usernameTF.text = ""
        emailTF.text = ""
        passwordTF.text = ""
        confirmPasswordTF.text = ""
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        guard let username = self.usernameTF.text else { return }
        guard let email = self.emailTF.text else { return }
        guard let password = self.passwordTF.text else { return }
        guard let confirmPassword = self.confirmPasswordTF.text else { return }
        
        
        let register = RegisterModel(username: username, email: email, password: password, confirmPassword: confirmPassword)
        APIManager.shareInstance.registerAPI(register: register) { (isSuccess, str) in
            if isSuccess {
                //                self.showAlert(message: str)
                self.goToConfirmation(withId: "ConfirmationID")
                
                
            }else {
                self.showAlert(message: str)
            }
        }
        self.resetFields()
    }
    
}

extension UITextField {
    
    func setupLeftSideImages(ImageViewNamed: String) {
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 16, height: 16))
        imageView.image = UIImage(named: ImageViewNamed)
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageViewContainerView.addSubview(imageView)
        leftView = imageViewContainerView
        leftViewMode = .always
    }
    
    func setupBorderTFs() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.20, green: 0.49, blue: 0.75, alpha: 1.00).cgColor
    }
}

extension UIButton{
    
    func applyGradients () {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.25, green: 0.56, blue: 0.80, alpha: 1.00).cgColor,UIColor(red: 0.24, green: 0.76, blue: 0.95, alpha: 1.00).cgColor]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupBorderBtns() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00).cgColor
    }
}
