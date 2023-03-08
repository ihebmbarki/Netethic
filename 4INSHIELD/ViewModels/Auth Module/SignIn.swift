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

        // Do any additional setup after loading the view.
        
        //MARK: Translate
        welcomeLabel.text = NSLocalizedString("Welcome", comment: "welcome label")
        signInLabel.text = NSLocalizedString("Welcome2", comment: "sign in label")
        emailTF.text = NSLocalizedString("e_mail", comment: "sign in label")
        passwordTF.text = NSLocalizedString("Password", comment: "sign in label")
        dontHaveAccLabel.text = NSLocalizedString("text_register", comment: "no account ?")
        forgotPwdBtn.setTitle(NSLocalizedString("forget", comment: "forgot password"), for: .normal)
        signInBtn.setTitle(NSLocalizedString("Login", comment: "Login"), for: .normal)
        signInBtn.setTitle(NSLocalizedString("Login", comment: "Login"), for: .normal)
        registerBtn.setTitle(NSLocalizedString("register", comment: "register"), for: .normal)
        signIn_google.setTitle(NSLocalizedString("google_connect", comment: "google"), for: .normal)
        signIn_facebook.setTitle(NSLocalizedString("fb", comment: "facebook"), for: .normal)
        
        let currentLanguage = Bundle.main.preferredLocalizations[0]
        if let flagImage = languageFlags[currentLanguage] {
            changeLanguageBtn.setImage(flagImage, for: .normal)
        }

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
    
    
//    let languageFlags = [
//        "en": UIImage(named: "english"),
//        "fr": UIImage(named: "french")
//    ]
//
//    private var bundleKey: UInt8 = 0
//
//    func setLanguage(_ languageCode: String, button: UIButton) {
//        print("Setting language to \(languageCode)")
//
//        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
//
//        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
//            print("Could not find path for language code \(languageCode)")
//            return
//        }
//
//        let bundle = Bundle(path: path)
//        guard let localizedBundle = bundle else {
//            print("Could not load bundle for language code \(languageCode)")
//            return
//        }
//        objc_setAssociatedObject(Bundle.main, &bundleKey, localizedBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//        // Update flag image on button
//        if let flagImage = languageFlags[languageCode] {
//            button.setImage(flagImage, for: .normal)
//        } else {
//            print("Could not find flag image for language code \(languageCode)")
//        }
//
//        // Force a reload of the view controller to update the localized strings
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//            let viewController = windowScene.windows.first?.rootViewController {
//            viewController.viewDidLoad()
//        }
//    }
    
    
    let languageFlags = [
        "en": UIImage(named: "english"),
        "fr": UIImage(named: "french")
    ]
    
        private var bundleKey: UInt8 = 0
    
    func setLanguage(_ languageCode: String, button: UIButton) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
           UserDefaults.standard.synchronize()
   
           guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
               print("Could not find path for language code \(languageCode)")
               return
           }
   
           let bundle = Bundle(path: path)
           guard let localizedBundle = bundle else {
               print("Could not load bundle for language code \(languageCode)")
               return
           }
           objc_setAssociatedObject(Bundle.main, &bundleKey, localizedBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        Update flag image on button
        if let flagImage = languageFlags[languageCode] {
            button.setImage(flagImage, for: .normal)
        } else {
            print("Could not find flag image for language code \(languageCode)")
        }
        if let navController = self.navigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
            navController.setViewControllers([viewController], animated: false)
        }
        
        
    }
    
    func restartApplication() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        appDelegate.window?.rootViewController = initialViewController
    }

    @IBAction func changeLanguageBtnTapped(_ sender: UIButton) {
//        let currentLanguage = Locale.current.language.languageCode?.identifier
//        let newLanguage = currentLanguage == "en" ? "fr" : "en"
//        UserDefaults.standard.set([newLanguage], forKey: "AppleLanguages")
        let currentLanguage = Bundle.main.preferredLocalizations[0]
            let nextLanguage = currentLanguage == "en" ? "fr" : "en"
            setLanguage(nextLanguage, button: sender)
    }
    
    
    @IBAction func SignInBtnTapped(_ sender: Any) {
        guard let username = self.emailTF.text else { return }
        guard let password = self.passwordTF.text else { return }
        
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
