//
//  SignIn.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/2/2023.
//

import UIKit

class SignIn: KeyboardHandlingBaseVC {
    
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
      @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func verifyFields() -> Bool {
        guard let username =  emailTF.text else { return false }
        guard let password =  passwordTF.text else { return false }

        if username.isEmpty  {
            showAlert(message: "Votre email n'est pas vérifié ! Veuillez vérifier votre e-mail. ")
            return false
        }
        if password.isEmpty {
            showAlert(message: "Votre email n'est pas vérifié ! Veuillez vérifier votre e-mail. ")
            return false
        }
        
        return true
    }
    
    func resetFields() {
        emailTF.text = ""
        passwordTF.text = ""
    }

    func translate() {
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
    
    @IBAction func changeLanguageBtnTapped(_ sender: Any) {
        translate()
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

    func goToScreen(withId identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(VC, animated: true)
    }
    
    fileprivate func getLastChildID(username: String) {
        APIManager.shareInstance.getLastregistredChildID(withUsername: username) { lastChildID in
            UserDefaults.standard.set(lastChildID, forKey: "childID")
        }
    }
    
    @IBAction func SignInBtnTapped(_ sender: Any) {
        guard let username = self.emailTF.text else { return }
        let trimmedUserName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let password = self.passwordTF.text else { return }

        if verifyFields() {
            // Check if onboarding has been completed for this user
            let onboardingSimple = UserDefaults.standard.bool(forKey: "onboardingSimple")
            let login = LoginModel(username: username, password: password, onboarding_simple: onboardingSimple)

            APIManager.shareInstance.loginAPI(login: login) { result in
                switch result {
                case .success(let json):
                    print(json as AnyObject)
                    if let jsonDict = json as? [String: Any],
                       let id = jsonDict["id"] as? Int,
                       let username = jsonDict["username"] as? String {
                        // Save id and username to UserDefaults
                        UserDefaults.standard.set(id, forKey: "userID")
                        UserDefaults.standard.set(username, forKey: "username")
                        print("User ID: \(id)")
                    } else {
                        print("Error: could not parse response")
                    }
                    DispatchQueue.main.async {
                        APIManager.shareInstance.getUserOnboardingStatus(withUserName: trimmedUserName) { onboardingSimple in
                            UserDefaults.standard.set(onboardingSimple, forKey: "onboardingSimple")
                            print("Value of onboardingSimple: \(String(describing: onboardingSimple))")
                            if onboardingSimple == false {
                                self.goToScreen(withId: "OnboardingSB")
                            } else {
                                // Proceed to wizard screen
                                APIManager.shareInstance.getUserWizardStep(withUserName: trimmedUserName) { wizardStep in
                                    print("Retrieved wizard step from server: \(String(describing: wizardStep))")
                                    // Update the user defaults with the new wizard step value
                                    UserDefaults.standard.set(wizardStep, forKey: "wizardStep")
                                    if let wizardStep = UserDefaults.standard.object(forKey: "wizardStep") as? Int {
                                        print("Retrieved wizard step from user defaults: \(wizardStep)")
                                        switch wizardStep {
                                        case 1:
                                            self.goToScreen(withId: "childInfos")
                                        case 2:
                                            self.goToScreen(withId: "ChildSocialMedia")
                                        case 3:
                                            self.goToScreen(withId: "ChildProfileAdded")
                                        case 4:
                                            self.goToScreen(withId: "ChildDevice")
                                        case 5:
                                            self.goToScreen(withId: "Congrats")
                                        case 6:
                                            let storyboard = UIStoryboard(name: "Children", bundle: nil)
                                            let vc = storyboard.instantiateViewController(withIdentifier: "ChildrenListSB")
                                            vc.modalPresentationStyle = .fullScreen
                                            self.present(vc, animated: true, completion: nil)
                                        default:
                                            self.goToScreen(withId: "OnboardingSB")
                                        }
                                    } else {
                                        // The wizard step value is not set in the user defaults
                                        // Redirect to the onboarding screen
                                        self.goToScreen(withId: "OnboardingSB")
                                    }
                                }
                            }

                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        self.resetFields()
    }
    
    
    @IBAction func forgetPwdBtn(_ sender: Any) {
        goToScreen(withId: "ForgotViewController")
    }
    
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        goToScreen(withId: "Register")
        print ("register")
    }
    


    
    @IBAction func signInGoogleTapped(_ sender: Any) {
    }
    
    @IBAction func signInFacebookTapped(_ sender: Any) {
    }
    
    

}

extension UITextField {
    
    func setupLeftSideImage(ImageViewNamed: String) {
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 16, height: 16))
        imageView.image = UIImage(named: ImageViewNamed)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "AccentColor")
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageViewContainerView.addSubview(imageView)
        leftView = imageViewContainerView
        leftViewMode = .always
    }
    
    func setupBorderTF() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        //layer.borderColor = UIColor(red: 0.20, green: 0.49, blue: 0.75, alpha: 1.00).cgColor
    }
}

extension UIButton{
    
        func applyGradient () {
        let gradientLayer = CAGradientLayer()
        //gradientLayer.colors = [UIColor(red: 0.25, green: 0.56, blue: 0.80, alpha: 1.00).cgColor,UIColor(red: 0.24, green: 0.76, blue: 0.95, alpha: 1.00).cgColor]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupBorderBtn() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        //layer.borderColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00).cgColor
    }
}


