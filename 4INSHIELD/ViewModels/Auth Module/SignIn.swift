//
//  SignIn.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/2/2023.
//

import UIKit

class SignIn: UIViewController {

    //IBOutlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var dontHaveAccLabel: UILabel!
    @IBOutlet weak var changeLanguageBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var forgotPwdBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signIn_google: UIButton!
    @IBOutlet weak var signIn_facebook: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the
        
        // Set the initial language based on the saved language
           if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
               LanguageManager.shared.currentLanguage = selectedLanguage
           }

           // Update localized strings
           updateLocalizedStrings()
        
        //Text fields left side image
        emailTF.setupLeftSideImage(ImageViewNamed: "mail")
        passwordTF.setupLeftSideImage(ImageViewNamed: "password")
        
        //text fields border style
        emailTF.setupBorderTF()
        passwordTF.setupBorderTF()
        
        
        //Buttons style
        signInBtn.applyGradient()
        signIn_google.setupBorderBtn()
        signIn_facebook.setupBorderBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LanguageManager.shared.currentLanguage = "fr"
        updateLocalizedStrings()
    }

    
    func verifyFields() -> Bool {
        guard let username =  emailTF.text else { return false }
        guard let password =  passwordTF.text else { return false }

        if username.isEmpty || password.isEmpty {
            return false
        }
        
        return true
    }
    
    
    func resetFields() {
        emailTF.text = ""
        passwordTF.text = ""
    }

    @IBAction func changeLanguageBtnTapped(_ sender: Any) {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "Choisir la langue", message: nil, preferredStyle: .actionSheet)

        for language in languages {
            let action = UIAlertAction(title: language, style: .default) { action in
                if action.title == "English" {
                    LanguageManager.shared.currentLanguage = "en"
                    UserDefaults.standard.set("en", forKey: "selectedLanguage")
                    self.changeLanguageBtn.setImage(UIImage(named: "eng_white"), for: .normal)
                } else if action.title == "Français" {
                    LanguageManager.shared.currentLanguage = "fr"
                    UserDefaults.standard.set("fr", forKey: "selectedLanguage")
                    self.changeLanguageBtn.setImage(UIImage(named: "fr_white"), for: .normal)
                }

                self.updateLocalizedStrings()
                self.view.setNeedsLayout() // Refresh the layout of the view
            }
            languageAlert.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        languageAlert.addAction(cancelAction)

        present(languageAlert, animated: true, completion: nil)
    }


    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
        
        welcomeLabel.text = NSLocalizedString("Welcome", tableName: nil, bundle: bundle, value: "", comment: "welcome label")
        signInLabel.text = NSLocalizedString("Welcome2", tableName: nil, bundle: bundle, value: "", comment: "sign in label")
        emailTF.placeholder = NSLocalizedString("e_mail", tableName: nil, bundle: bundle, value: "", comment: "sign in label")
        passwordTF.placeholder = NSLocalizedString("Password", tableName: nil, bundle: bundle, value: "", comment: "sign in label")
        dontHaveAccLabel.text = NSLocalizedString("text_register", tableName: nil, bundle: bundle, value: "", comment: "no account ?")
        forgotPwdBtn.setTitle(NSLocalizedString("forget", tableName: nil, bundle: bundle, value: "", comment: "forgot password"), for: .normal)
        signInBtn.setTitle(NSLocalizedString("Login", tableName: nil, bundle: bundle, value: "", comment: "Login"), for: .normal)
        registerBtn.setTitle(NSLocalizedString("register", tableName: nil, bundle: bundle, value: "", comment: "register"), for: .normal)
        signIn_google.setTitle(NSLocalizedString("google_connect", tableName: nil, bundle: bundle, value: "", comment: "google"), for: .normal)
        signIn_facebook.setTitle(NSLocalizedString("fb", tableName: nil, bundle: bundle, value: "", comment: "facebook"), for: .normal)
    }


    
    @IBAction func SignInBtnTapped(_ sender: Any) {
        guard let username = self.emailTF.text else { return }
        guard let password = self.passwordTF.text else { return }
        
        if(verifyFields()) {
            
            let login = LoginModel(username: username, password: password)
            APIManager.shareInstance.loginAPI(login: login) { result in
                switch result {
                case.success(let json):
                    print(json as AnyObject)
                case.failure(let err):
                    print(err.localizedDescription)
                }
                
            }
            
        }
        self.resetFields()
    }

}

extension UITextField {
    
    func setupLeftSideImage(ImageViewNamed: String) {
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 16, height: 16))
        imageView.image = UIImage(named: ImageViewNamed)
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageViewContainerView.addSubview(imageView)
        leftView = imageViewContainerView
        leftViewMode = .always
    }
    
    func setupBorderTF() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.20, green: 0.49, blue: 0.75, alpha: 1.00).cgColor
    }
}

extension UIButton{
    
    func applyGradient () {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.25, green: 0.56, blue: 0.80, alpha: 1.00).cgColor,UIColor(red: 0.24, green: 0.76, blue: 0.95, alpha: 1.00).cgColor]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupBorderBtn() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00).cgColor
    }
}
