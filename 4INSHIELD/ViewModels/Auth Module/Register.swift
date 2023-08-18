//
//  Register.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/2/2023.
//

import UIKit
import FSCalendar
import DropDown

class Register: KeyboardHandlingBaseVC {
    
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
    
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var confirmpwdError: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentInsetAdjustmentBehavior = .never
            
        }
    }
    
        
    @IBOutlet weak var Main: FooterView!{
            didSet{
                Main.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
        }
    }
    var iconClick = false
    let imageicon1 = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
    let imageicon2 = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "    Homme",
            "    Femme"
        ]
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetForm()
           
        // Update localized strings
        updateLocalizedStrings()
        
        //Text fields lefrt side images
        usernameTF.setupLeftSideImages(ImageViewNamed: "user")
        emailTF.setupLeftSideImages(ImageViewNamed: "mail1")
        passwordTF.setupLeftSideImages(ImageViewNamed: "password")
        confirmPasswordTF.setupLeftSideImages(ImageViewNamed: "password")
        
        //text fields style
        usernameTF.setupBorderTFs()
        emailTF.setupBorderTFs()
        passwordTF.setupBorderTFs()
        confirmPasswordTF.setupBorderTFs()
        
        //Buttons style
        registerBtn.applyGradients()
        registerBtn.setupBorderBtn()
        //register_google.setupBorderBtns()
        //register_facebook.setupBorderBtns()
        
        visualiserPassword1()
        visualiserPassword2()
        
    }

    func resetForm() {
        registerBtn.isEnabled = false

        usernameError.isHidden = true
        emailError.isHidden = true
        passwordError.isHidden = true
        confirmpwdError.isHidden = true

//        usernameError.text = "Required"
//        emailError.text = "Required"
//        passwordError.text = "Required"
//        confirmpwdError.text = "Required"

        usernameTF.text = ""
        emailTF.text = ""
        passwordTF.text = ""
        confirmPasswordTF .text = ""
    }
    
    @IBAction func usernameChanged(_ sender: Any) {
        if let username = usernameTF.text {
             if let errorMessage = invalidUserName(username) {
                 usernameError.text = errorMessage
                 usernameError.isHidden = false
                 usernameTF.layer.borderColor = UIColor(named: "redControl")?.cgColor
                 usernameTF.setupRightSideImage(image: "error", colorName: "redControl")
             } else {
                 usernameError.isHidden = true
                 usernameTF.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                 usernameTF.setupRightSideImage(image: "done", colorName: "vertDone")
             }
         }
         
         checkForValidForm()
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
    
    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTF.text {
            if let errorMessage = invalidEmail(email) {
                emailError.text = errorMessage
                emailError.isHidden = false
                emailTF.layer.borderColor = UIColor(named: "redControl")?.cgColor
                emailTF.setupRightSideImage(image: "error", colorName: "redControl")
            } else {
                emailError.isHidden = true
                emailTF.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                emailTF.setupRightSideImage(image: "done", colorName: "vertDone")
            }
        }
        
        checkForValidForm()
    }
    
    func invalidEmail(_ value: String) -> String?
    {
        if value.isEmpty {
            if LanguageManager.shared.currentLanguage == "fr"{
            return "Ce champ ne peut pas être vide. "
            }
            if LanguageManager.shared.currentLanguage == "en"{
            return "This field cannot be blank."
            }
        }
        
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        
        if !predicate.evaluate(with: value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Votre email n'est pas valide !"
            } else {
                return "Your email is not valid!"
            }
        }
        
        return nil
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let password = passwordTF.text {
             if let errorMessage = invalidPassword(password) {
                 passwordError.text = errorMessage
                 passwordError.isHidden = false
                 passwordTF.layer.borderColor = UIColor(named: "redControl")?.cgColor
                 passwordTF.setupRightSideImage(image: "error", colorName: "redControl")
             } else {
                 passwordError.isHidden = true
                 passwordTF.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                 passwordTF.setupRightSideImage(image: "done", colorName: "vertDone")
             }
         }
         
         checkForValidForm()
    }
    
    func invalidPassword(_ value: String) -> String?
    {
        if value.count < 8 {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Le mot de passe doit comporter au moins 8 caractères."
            } else {
                return "Password must be at least 8 characters."
            }
        }
        
        if containsDigit(value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Le mot de passe doit contenir au moins 1 chiffre."
            } else {
                return "Password must contain at least 1 digit."
            }
        }
        
        if containsLowerCase(value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Le mot de passe doit contenir au moins 1 caractère minuscule."
            } else {
                return "Password must contain at least 1 lowercase character."
            }
        }
        
        if containsUpperCase(value) {
            if LanguageManager.shared.currentLanguage == "fr" {
                return "Le mot de passe doit contenir au moins un caractère majuscule."
            } else {
                return "Password must contain at least 1 uppercase character."
            }
        }
        
        return nil
    }
    
    func containsDigit(_ value: String) -> Bool
    {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsLowerCase(_ value: String) -> Bool
    {
        let reqularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsUpperCase(_ value: String) -> Bool
    {
        let reqularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    @IBAction func confirmpwdChanged(_ sender: Any) {
        if let password = passwordTF.text,
           let confirmPassword = confirmPasswordTF.text {
            
            if password == confirmPassword {
                confirmpwdError.isHidden = true
                confirmPasswordTF.layer.borderColor = UIColor(named: "grisBorder")?.cgColor
                confirmPasswordTF.setupRightSideImage(image: "done", colorName: "vertDone")
            } else {
                if LanguageManager.shared.currentLanguage == "fr" {
                    confirmpwdError.text = "Les 2 mots de passe ne correspondent pas."
                    confirmPasswordTF.layer.borderColor = UIColor(named: "redControl")?.cgColor
                    confirmPasswordTF.setupRightSideImage(image: "error", colorName: "redControl")
                } else {
                    confirmpwdError.text = "Passwords do not match."
                    confirmPasswordTF.layer.borderColor = UIColor(named: "redControl")?.cgColor
                    confirmPasswordTF.setupRightSideImage(image: "error", colorName: "redControl")
                }
                confirmpwdError.isHidden = false
            }
        }
        
        checkForValidForm()
    }
    
    func checkForValidForm()
    {
        if emailError.isHidden && passwordError.isHidden && usernameError.isHidden && confirmpwdError.isHidden
        {
            registerBtn.isEnabled = true
        }
        else
        {
            registerBtn.isEnabled = false
        }
    }
    
    
    @objc func didTapTopItem(){
        menu.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocalizedStrings()
        updateLanguageButtonImage()
    }
    
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                changeLanguageBtn.setImage(UIImage(named: "fr_white1"), for: .normal)
            } else if selectedLanguage == "en" {
                changeLanguageBtn.setImage(UIImage(named: "eng_white1"), for: .normal)
            }
        }
    }
    
    func visualiserPassword1(){
        imageicon1.image = UIImage(named: "closeeye")?.withRenderingMode(.alwaysTemplate)
        imageicon1.tintColor = .black
        let imageViewContainerView1 = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 40))
        imageViewContainerView1.addSubview(imageicon1)
        passwordTF.rightView = imageViewContainerView1
        passwordTF.rightViewMode = .always
        
        let tapGestureRecongnizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTaped(tapGestureRecongnizer1: )))
        imageicon1.isUserInteractionEnabled = true
        imageicon1.addGestureRecognizer(tapGestureRecongnizer1)
    }
    
    @objc func imageTaped(tapGestureRecongnizer1: UITapGestureRecognizer){
        let tappedImage1 = tapGestureRecongnizer1.view as!UIImageView
        if iconClick{
            iconClick = false
            tappedImage1.image = UIImage(named: "openeye")
            passwordTF.isSecureTextEntry = false
        }
        else{
            iconClick = true
            tappedImage1.image = UIImage(named: "closeeye")
            passwordTF.isSecureTextEntry = true
        }
    }
    
    func visualiserPassword2(){
        imageicon2.image = UIImage(named: "closeeye")?.withRenderingMode(.alwaysTemplate)
        imageicon2.tintColor = .black
        let imageViewContainerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 40))
        imageViewContainerView2.addSubview(imageicon2)
        confirmPasswordTF.rightView = imageViewContainerView2
        confirmPasswordTF.rightViewMode = .always
        
        let tapGestureRecongnizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTaped(tapGestureRecongnizer2: )))
        imageicon2.isUserInteractionEnabled = true
        imageicon2.addGestureRecognizer(tapGestureRecongnizer2)
    }
    
    @objc func imageTaped(tapGestureRecongnizer2: UITapGestureRecognizer){
        let tappedImage2 = tapGestureRecongnizer2.view as!UIImageView
        if iconClick{
            iconClick = false
            tappedImage2.image = UIImage(named: "openeye")
            confirmPasswordTF.isSecureTextEntry = false
        }
        else{
            iconClick = true
            tappedImage2.image = UIImage(named: "closeeye")
            confirmPasswordTF.isSecureTextEntry = true
        }
    }
    
    
    @IBAction func changeLanguageBtnTapped(_ sender: Any) {
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
    
    func updateLocalizedStrings() {
        let bundle = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj").flatMap(Bundle.init) ?? Bundle.main
        
        welcomeLbl.text = NSLocalizedString("Welcome", tableName: nil, bundle: bundle, value: "", comment: "welcome label")
        createAccLbl.text = NSLocalizedString("create_account", tableName: nil, bundle: bundle, value: "", comment: "sign up label")
        usernameTF.placeholder = NSLocalizedString("your_username", tableName: nil, bundle: bundle, value: "", comment: "username")
        emailTF.placeholder = NSLocalizedString("e_mail", tableName: nil, bundle: bundle, value: "", comment: "email")
        passwordTF.placeholder = NSLocalizedString("Password", tableName: nil, bundle: bundle, value: "", comment: "Password")
        confirmPasswordTF.placeholder = NSLocalizedString("re_type_password", tableName: nil, bundle: bundle, value: "", comment: "Confirm Password")
        registerBtn.setTitle(NSLocalizedString("sign_up", tableName: nil, bundle: bundle, value: "", comment: "sign up"), for: .normal)
        
        let underlinedAttribute: [NSAttributedString.Key: Any] = [ .underlineStyle: NSUnderlineStyle.single.rawValue ]
        let attributedTitle = NSAttributedString(
            string: NSLocalizedString("Login1", tableName: nil, bundle: bundle, value: "", comment: "Login"), attributes: underlinedAttribute)

        signInBtn.setAttributedTitle(attributedTitle, for: .normal)
        haveAccLbl.text = NSLocalizedString("text_login", tableName: nil, bundle: bundle, value: "", comment: "text login")
        usernameError.text = NSLocalizedString("username_error", tableName: nil, bundle: bundle, value: "", comment: "text login")
        emailError.text = NSLocalizedString("email_error", tableName: nil, bundle: bundle, value: "", comment: "text login")
        passwordError.text = NSLocalizedString("password_error", tableName: nil, bundle: bundle, value: "", comment: "text login")
        confirmpwdError.text = NSLocalizedString("Confirm_password_error", tableName: nil, bundle: bundle, value: "", comment: "text login")
        /*    register_google.setTitle(NSLocalizedString("signup_google", tableName: nil, bundle: bundle, value: "", comment: "sign up google"), for: .normal)
         register_facebook.setTitle(NSLocalizedString("signup_facebook", tableName: nil, bundle: bundle, value: "", comment: "sign up facebook"), for: .normal) */
        if LanguageManager.shared.currentLanguage == "fr"{
            Main.configure(titleText: "© 2023 Tous Droits Réservés Réalisé par Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
        }
        if LanguageManager.shared.currentLanguage == "en"{
            Main.configure(titleText: "© 2023 All Rights Reserved Made by Data4Ethic", color: UIColor(named: "AccentColor") ?? .white)
        }
    }
    
    func showAlert(messageKey: String, completion: (() -> Void)? = nil) {
        let localizedMessage = NSLocalizedString(messageKey, comment: "")
        let alert = UIAlertController(title: "Alert", message: localizedMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?() // Call the completion handler when "OK" is tapped
        })
        self.present(alert, animated: true, completion: nil)
    }

    
    func goToConfirmation(withId identifier: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ConfirmationVC = storyboard.instantiateViewController(withIdentifier: identifier)
            self.navigationController?.pushViewController(ConfirmationVC, animated: true)
        }
    }
    
    func gotoScreen(storyBoardName: String, stbIdentifier: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: stbIdentifier)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func registerBtnTapped(_ sender: Any) {
        guard let username = usernameTF.text, !username.isEmpty,
              let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty else {
                  return
              }

        let register = RegisterModel(username: username, email: email, password: password)

        APIManager.shareInstance.registerAPI(register: register) { isSuccess, messageKey in
            if isSuccess {
                    self.goToConfirmation(withId: "ConfirmationID")
                    self.gotoScreen(storyBoardName: "Main", stbIdentifier: "ConfirmationID")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                    UserDefaults.standard.synchronize()
                    self.resetForm()
                
            } else {
                self.showAlert(messageKey: messageKey)
            }
        }
    }

    
    @IBAction func signInButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "signIn")
//        navigationController?.pushViewController(VC, animated: true)
        self.dismiss(animated: true)
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func signUpGoogleTapped(_ sender: Any) {
    }
    
    
    @IBAction func signUpFacebookTapped(_ sender: Any) {
    }
    
    
}

extension UITextField {
    
    func setupLeftSideImages(ImageViewNamed: String) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: ImageViewNamed)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "AccentColor")
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageViewContainerView.addSubview(imageView)
        leftView = imageViewContainerView
        leftViewMode = .always
        
        
    }
    
    func setupBorderTFs() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "grisBorder")?.cgColor
        
    }
}

extension UIButton{
    
    func applyGradients () {
        let gradientLayer = CAGradientLayer()
        //     gradientLayer.colors = [UIColor(red: 0.25, green: 0.56, blue: 0.80, alpha: 1.00).cgColor,UIColor(red: 0.24, green: 0.76, blue: 0.95, alpha: 1.00).cgColor]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupBorderBtns() {
        layer.cornerRadius = 5
//        layer.borderWidth = 1
//        layer.borderColor = UIColor(named: "grisBorder")?.cgColor
    }
}

