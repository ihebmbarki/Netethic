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
    var iconClick = false
    let imageicon = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
    let alertImage = UIImage(named: "yey")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the initial language based on the saved language
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            LanguageManager.shared.currentLanguage = selectedLanguage
        }
        
        // Update localized strings
        updateLocalizedStrings()
        
        //Text fields left side image
        emailTF.setupLeftSideImage(ImageViewNamed: "Vector")
        passwordTF.setupLeftSideImage(ImageViewNamed: "password")
        
        signInBtn.setImage(UIImage(named: "next")!.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        signInBtn.imageEdgeInsets = UIEdgeInsets(top : 0, left : 0 , bottom : 0, right : -36 )

        //text fields border style
        emailTF.setupBorderTF()
        passwordTF.setupBorderTF()
        
        
        //Buttons style
        signInBtn.applyGradient()
        signInBtn.setupBorderBtn()
        
        signIn_google.setupBorderBtn()
        signIn_facebook.setupBorderBtn()
        visualiserPassword()
        

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
        
        if username.isEmpty   {
            if LanguageManager.shared.currentLanguage == "fr"{
                showAlert(message: "Votre email n'est pas vérifié ! Veuillez vérifier votre e-mail. ")
                return false
            }
        }
        if username.isEmpty   {
            if LanguageManager.shared.currentLanguage == "en"{
                showAlert(message: "Your email is not verified! Please verify your email address.")
            }
        }
        if LanguageManager.shared.currentLanguage == "fr"{
            if password.isEmpty {
                showAlert(message: "Votre mot de passe n'est pas vérifié ! Veuillez vérifier votre mot de passe")
                return false
            }
        }
        if password.isEmpty {
            if LanguageManager.shared.currentLanguage == "en"{
                showAlert(message: "Your password is not verified! Please verify your password.")
            }
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
                    self.changeLanguageBtn.setImage(UIImage(named: "eng_white1"), for: .normal)
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
        emailTF.placeholder = NSLocalizedString("Connexion", tableName: nil, bundle: bundle, value: "", comment: "sign in label")
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
    
    //    fileprivate func getLastChildID(username: String) {
    //        Api.getLastregistredChildID(withUsername: username) { lastChildID in
    //            UserDefaults.standard.set(lastChildID, forKey: "childID")
    //        }
    //    }
    
    @IBAction func SignInBtnTapped(_ sender: Any) {
        guard let username = self.emailTF.text else { return }
        let trimmedUserName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let password = self.passwordTF.text else { return }
        
        if verifyFields() {
            // Check if onboarding has been completed for this user
            let onboardingSimple = UserDefaults.standard.bool(forKey: "onboardingSimple")
            let login = LoginModel(username: username, password: password, onboarding_simple: onboardingSimple)
            //            let login = LoginModel(username: username, password: password)
            
            APIManager.shareInstance.loginAPI(login: login) { result in
                switch result {
                case .success(let json):
                    print(json as AnyObject)
                    if let jsonDict = json as? [String: Any],
                       let id = jsonDict["id"] as? Int,
                       let username = jsonDict["username"] as? String {
                        // Save id and username to UserDefaults
                        //  UserDefaults.standard.set(id, forKey: "userID")
                        UserDefaults.standard.set(username, forKey: "username")
                        //  print("User ID: \(id)")
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
                                let roleDataID = UserDefaults.standard.integer(forKey: "RoleDataID")
                                print("Value of roleDataID: \(roleDataID)")
                                
                                UserDefaults.standard.set(roleDataID, forKey: "RoleDataID")
                                
                                DataHandler.shared.roleDataID = roleDataID
                                // Proceed to wizard screen
                                APIManager.shareInstance.getUserWizardStep(withUserName: trimmedUserName) { [self] wizardStep in
                                    print("Retrieved wizard step from server: \(String(describing: wizardStep))")
                                    // Update the user defaults with the new wizard step value
                                    UserDefaults.standard.set(wizardStep, forKey: "wizardStep")
                                    if let wizardStep = UserDefaults.standard.object(forKey: "wizardStep") as? Int {
                                        //self.showAlert(title: "Alerte", message: "Succès")
                                        print("Retrieved wizard step from user defaults: \(wizardStep)")
                                        switch wizardStep {
                                        case 1:
                                            if LanguageManager.shared.currentLanguage == "fr"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey ", message: "Succès ", image: alertImage!, name: "childInfos")
                                            }
                                            if LanguageManager.shared.currentLanguage == "en"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey", message: "Success", image: alertImage!, name: "childInfos")
                                            }
                                     
                                            //self.goToScreen(withId: "childInfos")
                                        case 2:
                                            if LanguageManager.shared.currentLanguage == "fr"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey ", message: "Succès ", image: alertImage!, name: "ChildSocialMedia")
                                            }
                                            if LanguageManager.shared.currentLanguage == "en"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey", message: "Success", image: alertImage!, name: "ChildSocialMedia")
                                            }
                                           // self.goToScreen(withId: "ChildSocialMedia")
                                        case 3:
                                            if LanguageManager.shared.currentLanguage == "fr"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey ", message: "Succès ", image: alertImage!, name: "ChildProfileAdded")
                                            }
                                            if LanguageManager.shared.currentLanguage == "en"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey", message: "Success", image: alertImage!, name: "ChildProfileAdded")
                                            }
                                           // self.goToScreen(withId: "ChildProfileAdded")
                                        case 4:
                                            if LanguageManager.shared.currentLanguage == "fr"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey ", message: "Succès ", image: alertImage!, name: "ChildDevice")
                                            }
                                            if LanguageManager.shared.currentLanguage == "en"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey", message: "Success", image: alertImage!, name: "ChildDevice")
                                            }
                                           // self.goToScreen(withId: "ChildDevice")
                                        case 5:
                                            if LanguageManager.shared.currentLanguage == "fr"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey ", message: "Succès ", image: alertImage!, name: "Congrats")
                                            }
                                            if LanguageManager.shared.currentLanguage == "en"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction1(title: "yeeey", message: "Success", image: alertImage!, name: "Congrats")
                                            }
                                            //self.goToScreen(withId: "Congrats")
                                        case 6:
                                            if LanguageManager.shared.currentLanguage == "fr"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction(title: "yeeey ", message: "Succès ", image: alertImage!)
                                            }
                                            if LanguageManager.shared.currentLanguage == "en"{
                                                let alertImage = UIImage(named: "yey")
                                                self.showAlertWithImageAndAction(title: "yeeey ", message: "Success ", image: alertImage!)
                                            }
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
                    // Affichez une alerte pour les différentes erreurs gérées
                    switch error {
                    case .custom(let message):
                        if LanguageManager.shared.currentLanguage == "fr"{
                            self.showAlert(title:"Alerte" ,message: "Informations d'identification non valides ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Alert", message: "Invalid credentials ")
                        }
                    case .networkError:
                        
                        if LanguageManager.shared.currentLanguage == "fr"{
                            self.showAlert(title:"Connexion Internet" ,message: "Votre connexion Internet n'est pas vérifié ! Veuillez vérifier votre Internet.  ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Network Error", message: "Your Network is not verified! Please verify your Network.")
                        }
                                            case .statusCodeError(let message, let statusCode):
                        self.showAlert(title: "Status Code Error", message: "Error with status code: \(statusCode ?? -1), Message: \(message)")
                    case .parsingError:
                        self.showAlert(title: "Parsing Error", message: "There was an error parsing the response.")
                        
                    case .decodingError:
                        print("response decoding change")
                    case .serverError:
                        if LanguageManager.shared.currentLanguage == "fr"{
                            self.showAlert(title:"Alerte" ,message: "Le serveur est temporairement indisponible, , veuillez réessayer plus tard. ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Alert", message: "The server is temporarily unavailable, Please try again later. ")
                        }
                    }
                }
            }
        }
        self.resetFields()
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Assuming your view controller is named "self"
        self.present(alertController, animated: true, completion: nil)
    }

    func visualiserPassword(){
        imageicon.image = UIImage(named: "closeeye")?.withRenderingMode(.alwaysTemplate)
        imageicon.tintColor = .black
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 40))
        imageViewContainerView.addSubview(imageicon)
        passwordTF.rightView = imageViewContainerView
        passwordTF.rightViewMode = .always
        
         
        let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(imageTaped(tapGestureRecongnizer: )))
        imageicon.isUserInteractionEnabled = true
        imageicon.addGestureRecognizer(tapGestureRecongnizer)
    }
    
    @objc func imageTaped(tapGestureRecongnizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecongnizer.view as!UIImageView
        if iconClick{
            iconClick = false
            tappedImage.image = UIImage(named: "openeye")
            passwordTF.isSecureTextEntry = false
        }
        else{
            iconClick = true
            tappedImage.image = UIImage(named: "closeeye")
            passwordTF.isSecureTextEntry = true
        }
    }
    func showAlertWithImageAndAction1(title: String, message: String, image: UIImage, name: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Créez un bouton personnalisé avec l'image
        let imageButton = UIButton(type: .system)
        imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        imageButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100) // Ajustez la taille de l'image ici
        imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        
        // Ajoutez le bouton personnalisé à l'alerte
        alertController.view.addSubview(imageButton)
        
        // Ajoutez un bouton OK pour fermer l'alerte et naviguer vers la prochaine interface
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            self.goToScreen(withId: name)
        }
        alertController.addAction(okAction)
        
        // Présentez l'alerte
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithImageAndAction(title: String, message: String, image: UIImage) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Créez un bouton personnalisé avec l'image
        let imageButton = UIButton(type: .system)
        imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        imageButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100) // Ajustez la taille de l'image ici
        imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        
        // Ajoutez le bouton personnalisé à l'alerte
        alertController.view.addSubview(imageButton)
        
        // Ajoutez un bouton OK pour fermer l'alerte et naviguer vers la prochaine interface
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            let storyboard = UIStoryboard(name: "Children", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChildrenListSB")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        
        // Présentez l'alerte
        present(alertController, animated: true, completion: nil)
    }
    @objc func imageButtonTapped() {
        // Gérez l'action lorsque l'image est cliquée ici
        let storyboard = UIStoryboard(name: "Children", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildrenListSB")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 20, height: 20))
        imageView.image = UIImage(named: ImageViewNamed)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "AccentColor")
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        imageViewContainerView.addSubview(imageView)
        leftView = imageViewContainerView
        leftViewMode = .always
    }
    
    func setupBorderTF() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "gris")?.cgColor
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
        layer.cornerRadius = 20
        layer.borderWidth = 1
        //layer.borderColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00).cgColor
    }
}


