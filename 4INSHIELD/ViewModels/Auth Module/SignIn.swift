//
//  SignIn.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/2/2023.
//

import UIKit
import Alamofire

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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    @IBOutlet weak var mainView: FooterView!{
        didSet{
            mainView.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
        }
    }
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var userErrorLabel: UILabel!
    
    var iconClick = false
    let imageicon = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
    let alertImage = UIImage(named: "yey")

    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetForm()
        signInBtn.isEnabled = false
        loadingIndicator.hidesWhenStopped = true
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
    
    func resetForm()
        {
            signInBtn.isEnabled = true
            
            userErrorLabel.isHidden = true
            passwordErrorLabel.isHidden = true
            
            userErrorLabel.text = "Required"
            passwordErrorLabel.text = "Required"
            
//            emailTF.text = ""
//            passwordTF.text = ""
        }
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func verifyFields() -> Bool {
        
        guard let username =  emailTF.text else { return false }
        guard let password =  passwordTF.text else { return false }
               
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
                    self.changeLanguageBtn.setImage(UIImage(named: "fr_white1"), for: .normal)
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
        userErrorLabel.text = NSLocalizedString("userName1", tableName: nil, bundle: bundle, value: "", comment: "erreur1 label")
        userErrorLabel.text = NSLocalizedString("userName2", tableName: nil, bundle: bundle, value: "", comment: "erreur2 label")
        passwordErrorLabel.text = NSLocalizedString("password1", tableName: nil, bundle: bundle, value: "", comment: "password erreur1 label")
        passwordErrorLabel.text = NSLocalizedString("password2", tableName: nil, bundle: bundle, value: "", comment: "password erreur2 label")
        signInLabel.text = NSLocalizedString("Welcome2", tableName: nil, bundle: bundle, value: "", comment: "sign in label")
        emailTF.placeholder = NSLocalizedString("Connexion", tableName: nil, bundle: bundle, value: "", comment: "sign in label")
        passwordTF.placeholder = NSLocalizedString("Password", tableName: nil, bundle: bundle, value: "", comment: "sign in label")
        dontHaveAccLabel.text = NSLocalizedString("text_register", tableName: nil, bundle: bundle, value: "", comment: "no account ?")
        forgotPwdBtn.setTitle(NSLocalizedString("forget", tableName: nil, bundle: bundle, value: "", comment: "forgot password"), for: .normal)
        signInBtn.setTitle(NSLocalizedString("Login", tableName: nil, bundle: bundle, value: "", comment: "Login"), for: .normal)
        registerBtn.setTitle(NSLocalizedString("register", tableName: nil, bundle: bundle, value: "", comment: "register"), for: .normal)
        signIn_google.setTitle(NSLocalizedString("google_connect", tableName: nil, bundle: bundle, value: "", comment: "google"), for: .normal)
        signIn_facebook.setTitle(NSLocalizedString("fb", tableName: nil, bundle: bundle, value: "", comment: "facebook"), for: .normal)
        if LanguageManager.shared.currentLanguage == "fr"{
            mainView.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
        }
        if LanguageManager.shared.currentLanguage == "en"{
            mainView.configure(titleText: "© 2023 All Rights Reserved Made by Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
        }

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
//        Activiat Loading Button and Animating
        loadingIndicator.startAnimating()
        // loadingIndicator.startAnimating()
        resetForm()
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
                          UserDefaults.standard.set(id, forKey: "userID")
                        UserDefaults.standard.set(username, forKey: "username")
                        self.signInBtn.isEnabled = true

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
//                                APIManager.shareInstance.getUserWizardStep(withUserName: trimmedUserName) { [self] wizardStep in
                                self.getUserWizardStep(withUserName: trimmedUserName) { wizardStep in
                                    print(wizardStep)
                        
                                    print("Retrieved wizard step from server: \(String(describing: wizardStep))")
                                    // Update the user defaults with the new wizard step value
                                    UserDefaults.standard.set(wizardStep, forKey: "wizardStep")
                                    if let wizardStep = UserDefaults.standard.object(forKey: "wizardStep") as? Int {
                                        //self.showAlert(title: "Alerte", message: "Succès")
                                        print("Retrieved wizard step from user defaults: \(wizardStep)")
                                        switch wizardStep {
                                        case 1:
                                            self.loadingIndicator.stopAnimating()
                                            self.goToScreen(withId: "childInfos")
                                        case 2:
                                            self.loadingIndicator.stopAnimating()
                                            self.goToScreen(withId: "ChildSocialMedia")
                                        case 3:
//                                            if LanguageManager.shared.currentLanguage == "fr"{
//                                                let alertImage = UIImage(named: "yey")
//                                                self.showAlertWithImageAndAction1(title: "yeeey ", message: "Succès ", image: alertImage!, name: "ChildProfileAdded")
//                                            }
//                                            if LanguageManager.shared.currentLanguage == "en"{
//                                                let alertImage = UIImage(named: "yey")
//                                                self.showAlertWithImageAndAction1(title: "yeeey", message: "Success", image: alertImage!, name: "ChildProfileAdded")
//                                            }
                                            self.loadingIndicator.stopAnimating()
                                            self.goToScreen(withId: "ChildProfileAdded")
                                        case 4:
//                                            if LanguageManager.shared.currentLanguage == "fr"{
//                                                let alertImage = UIImage(named: "yey")
//                                                self.showAlertWithImageAndAction1(title: "yeeey ", message: "Succès ", image: alertImage!, name: "ChildDevice")
//                                            }
//                                            if LanguageManager.shared.currentLanguage == "en"{
//                                                let alertImage = UIImage(named: "yey")
//                                                self.showAlertWithImageAndAction1(title: "yeeey", message: "Success", image: alertImage!, name: "ChildDevice")
//                                            }
                                            self.loadingIndicator.stopAnimating()
                                            self.goToScreen(withId: "ChildDevice")
                                        case 5:
//                                            if LanguageManager.shared.currentLanguage == "fr"{
//                                                let alertImage = UIImage(named: "yey")
//                                                self.showAlertWithImageAndAction1(title: "yeeey ", message: "Succès ", image: alertImage!, name: "Congrats")
//                                            }
//                                            if LanguageManager.shared.currentLanguage == "en"{
//                                                let alertImage = UIImage(named: "yey")
//                                                self.showAlertWithImageAndAction1(title: "yeeey", message: "Success", image: alertImage!, name: "Congrats")
//                                            }
                                            self.loadingIndicator.stopAnimating()
                                            self.goToScreen(withId: "Congrats")
                                        case 6:
                                            self.loadingIndicator.stopAnimating()
                                                let storyboard = UIStoryboard(name: "Children", bundle: nil)
                                                let vc = storyboard.instantiateViewController(withIdentifier: "ChildrenListSB")
                                                vc.modalPresentationStyle = .fullScreen
                                                self.present(vc, animated: true, completion: nil)
    
                                        default:
                                            self.loadingIndicator.stopAnimating()
                                            self.goToScreen(withId: "OnboardingSB")
                                        }
                                    } else {
                                        // The wizard step value is not set in the user defaults
                                        // Redirect to the onboarding screen
                                        self.loadingIndicator.stopAnimating()
                                        self.goToScreen(withId: "OnboardingSB")
                                    }
                                }
                            }
                            
                        }
                    }
                case .failure(let error):
            
                switch error {
                    case .custom(let message):
                        if LanguageManager.shared.currentLanguage == "fr"{
                            self.showAlert(title:"Alerte" ,message: "Informations d'identification non valides ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Alert", message: "Invalid credentials ")
                        }
                    self.loadingIndicator.stopAnimating()
                    case .networkError:
                        
                        if LanguageManager.shared.currentLanguage == "fr"{
                            self.showAlert(title:"Alerte" ,message: "Désolé, qulque chose s'est mal passé.   ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                        }
                    self.loadingIndicator.stopAnimating()
                    case .statusCodeError(let message, let statusCode):
                        self.showAlert(title: "Status Code Error", message: "Error with status code: \(statusCode ?? -1), Message: \(message)")
                    case .parsingError:
                        if LanguageManager.shared.currentLanguage == "fr"{
                            self.showAlert(title:"Alerte" ,message: "Désolé, qulque chose s'est mal passé.   ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Alert", message: "Sorry, something went wrong.")
                        }
                    self.loadingIndicator.stopAnimating()
                    case .decodingError:
                        print("response decoding change")
                    case .serverError:
                        if LanguageManager.shared.currentLanguage == "fr"{
                            self.showAlert(title:"Alerte" ,message: "Le serveur est temporairement indisponible, , veuillez réessayer plus tard. ")
                        }
                        if LanguageManager.shared.currentLanguage == "en"{
                            self.showAlert(title: "Alert", message: "The server is temporarily unavailable, Please try again later. ")
                        }
                    self.loadingIndicator.stopAnimating()
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
    func invalidUserName(_ value: String) -> String?
        {
            if value.isEmpty {
                if LanguageManager.shared.currentLanguage == "fr"{
                return "Ce champ ne peut pas être vide. "
                }
                if LanguageManager.shared.currentLanguage == "en"{
                return "This field cannot be blank."
                }
            }

            let reqularExpression = "^[a-zA-Z0-9]{3,20}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            if !predicate.evaluate(with: value)
            {
                if LanguageManager.shared.currentLanguage == "fr"{
                return "Nom d'utilisateur non valide"

            }
                if LanguageManager.shared.currentLanguage == "en"{
                    return "Invalid username"
                }
                
            }
            
            return nil
        }

    @IBAction func userChanged(_ sender: Any) {
        if let user = emailTF.text
                {
                    if let errorMessage = invalidUserName(user)
                    {
                        userErrorLabel.text = errorMessage
                        userErrorLabel.isHidden = false
                        emailTF.layer.borderColor = UIColor(named: "redControl")?.cgColor
                        emailTF.setupRightSideImage(image: "error", colorName: "redControl")
                    }
                    else
                    {
                        userErrorLabel.isHidden = true
                        emailTF.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                        emailTF.setupRightSideImage(image: "done", colorName: "vertDone")

                    }
                }
                
                checkForValidForm()
    }
    func checkForValidForm()
    {
        if userErrorLabel.isHidden && passwordErrorLabel.isHidden
        {
            signInBtn.isEnabled = true
        }
        else
        {
            signInBtn.isEnabled = false
        }
    }
    @IBAction func passwordChanged(_ sender: Any) {
        if let password = passwordTF.text {
            if let errorMessage = invalidPassword(password)
            {
                passwordErrorLabel.text = errorMessage
                passwordErrorLabel.isHidden = false
                passwordTF.layer.borderColor = UIColor(named: "redControl")?.cgColor
//                passwordTF.setupRightSideImage(image: "error", colorName: "redControl")
            }
            else
            {
                passwordErrorLabel.isHidden = true
                passwordTF.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                passwordTF.setupRightSideImage(image: "done", colorName: "vertDone")

            }
            checkForValidForm()

        }
    }
        func containsDigit(_ value: String) -> Bool {
                let reqularExpression = ".*[0-9]+.*"
                let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
                return !predicate.evaluate(with: value)
            }
        func invalidPassword(_ value: String) -> String? {
                if value.isEmpty {
                    if LanguageManager.shared.currentLanguage == "fr"{
                    return "Ce champ ne peut pas être vide. "
                    }
                    if LanguageManager.shared.currentLanguage == "en"{
                    return "This field cannot be blank."
                    }
                }
            
            
            
            if LanguageManager.shared.currentLanguage == "fr"{
                if value.count < 8
                {
                    return "Mot de passe non valide"
                }
                if containsDigit(value)
                {
                    return "Mot de passe non valide"
                }
                if containsLowerCase(value)
                {
                    return "Mot de passe non valide"
                }
                //                if containsUpperCase(value)
                //                {
                //                    return "Password must contain at least 1 uppercase character"
                //                }
            }
            if LanguageManager.shared.currentLanguage == "en"{
                if value.count < 8
                {
                    return "Invalid password"
                }
                if containsDigit(value)
                {
                    return "Invalid password"
                }
                if containsLowerCase(value)
                {
                    return "Invalid password"
                }
                //                if containsUpperCase(value)
                //                {
                //                    return "Password must contain at least 1 uppercase character"
                //                }
            }
                return nil
            }
        func containsLowerCase(_ value: String) -> Bool
            {
                let reqularExpression = ".*[a-z]+.*"
                let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
                return !predicate.evaluate(with: value)
            }
            
//            func containsUpperCase(_ value: String) -> Bool
//            {
//                let reqularExpression = ".*[A-Z]+.*"
//                let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
//                return !predicate.evaluate(with: value)
//            }
    
    @IBAction func signInGoogleTapped(_ sender: Any) {
    }
    
    @IBAction func signInFacebookTapped(_ sender: Any) {
    }

    func getUserWizardStep(withUserName: String, completion: @escaping (Int) -> Void) {
        let user_step_url = "\(BuildConfiguration.shared.WEBERVSER_BASE_URL)/api/users/\(withUserName)/journey/"
        
        AF.request(user_step_url, method: .get).responseDecodable(of: [UserJourney].self) { response in
            switch response.result {
            case .success(let userJourneys):
                if userJourneys.isEmpty {
                    completion(0)
                } else {
                    if let lastJourney = userJourneys.last {
                        print (lastJourney.wizard_step)
                        completion(lastJourney.wizard_step)
                    } else {
                        completion(0)
                    }
                }
            case .failure(let error):
                print("API Error getting journey data: \(error)")
                completion(0)
            }
        }
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
    func setupRightSideImage(image: String, colorName: String) {
        let imageView = UIImageView(frame: CGRect(x: 12, y: 9, width: 20, height: 20))
        imageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: colorName)
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        imageViewContainerView.addSubview(imageView)
        rightView = imageViewContainerView
        rightViewMode = .always
    }
    
    func setupBorderTF() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "grisBorder")?.cgColor
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
        layer.cornerRadius = 15
//        layer.borderWidth = 1
//        layer.borderColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1.00).cgColor
    }
}


