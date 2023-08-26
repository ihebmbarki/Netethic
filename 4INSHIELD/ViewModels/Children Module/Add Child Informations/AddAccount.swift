//
//  AddAccount.swift
//  4INSHIELD
//
//  Created by kaisensData on 25/8/2023.
//

import Foundation
import UIKit

class AddAccount: KeyboardHandlingBaseVC {
    
    
    //IBOutlets
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var confirmPasswordTf: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var changeLanguageBtn: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var retypepassLbl: UILabel!

    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var confirmPasswordError: UILabel!
    
    var iconClick = false
    let imageicon1 = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
    let imageicon2 = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
    
    var childInfo: ChildRegisterModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SetUpDesign()
        resetForm()
        
        // Call loadChildInfo with the completion handler to populate the text fields
        loadChildInfo { [weak self] childInfo in
            self?.childInfo = childInfo
            DispatchQueue.main.async {
                self?.usernameTf.text = childInfo.username
                self?.emailTf.text = childInfo.email
            }
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.getCurrentChildSocialMedia()
        updateLocalizedStrings()
        updateLanguageButtonImage()
    }
    
    @IBAction func changeLanguageBtnTapped(_ sender: Any) {
        let languages = ["English", "Français"]
        let languageAlert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)

        if LanguageManager.shared.currentLanguage == "en" {
            languageAlert.title = "Choose Language"
        } else if LanguageManager.shared.currentLanguage == "fr" {
            languageAlert.title = "Choisir la langue"
        }
        
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
        
        titleLbl.text = NSLocalizedString("add_another_profile", tableName: nil, bundle: bundle, value: "", comment: "")
        usernameLbl.text = NSLocalizedString("your_username", tableName: nil, bundle: bundle, value: "", comment: "")
        emailLbl.text = NSLocalizedString("e_mail", tableName: nil, bundle: bundle, value: "", comment: "")
        passwordLbl.text = NSLocalizedString("Password", tableName: nil, bundle: bundle, value: "", comment: "")
        retypepassLbl.text = NSLocalizedString("re_type_password", tableName: nil, bundle: bundle, value: "", comment: "")
        cancelBtn.setTitle(NSLocalizedString("cancel", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
        createBtn.setTitle(NSLocalizedString("create", tableName: nil, bundle: bundle, value: "", comment: ""), for: .normal)
        usernameError.text = NSLocalizedString("username_error", tableName: nil, bundle: bundle, value: "", comment: "text login")
        emailError.text = NSLocalizedString("email_error", tableName: nil, bundle: bundle, value: "", comment: "text login")
        passwordError.text = NSLocalizedString("password_error", tableName: nil, bundle: bundle, value: "", comment: "text login")
        confirmPasswordError.text = NSLocalizedString("Confirm_password_error", tableName: nil, bundle: bundle, value: "", comment: "text login")
        if LanguageManager.shared.currentLanguage == "fr" {
            titleLbl.text = "Ajouter un nouveau profil"
            cancelBtn.setTitle("Annuler", for: .normal)
            createBtn.setTitle("Créer", for: .normal)
        }
        if LanguageManager.shared.currentLanguage == "en" {
            titleLbl.text = "Add a new profile"
            cancelBtn.setTitle("Cancel", for: .normal)
            createBtn.setTitle("Create", for: .normal)
        }
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
        passwordTf.rightView = imageViewContainerView1
        passwordTf.rightViewMode = .always
        
        let tapGestureRecongnizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTaped(tapGestureRecongnizer1: )))
        imageicon1.isUserInteractionEnabled = true
        imageicon1.addGestureRecognizer(tapGestureRecongnizer1)
    }
    
    @objc func imageTaped(tapGestureRecongnizer1: UITapGestureRecognizer){
        let tappedImage1 = tapGestureRecongnizer1.view as!UIImageView
        if iconClick{
            iconClick = false
            tappedImage1.image = UIImage(named: "openeye")
            passwordTf.isSecureTextEntry = false
        }
        else{
            iconClick = true
            tappedImage1.image = UIImage(named: "closeeye")
            passwordTf.isSecureTextEntry = true
        }
    }
    
    func visualiserPassword2(){
        imageicon2.image = UIImage(named: "closeeye")?.withRenderingMode(.alwaysTemplate)
        imageicon2.tintColor = .black
        let imageViewContainerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 40))
        imageViewContainerView2.addSubview(imageicon2)
        confirmPasswordTf.rightView = imageViewContainerView2
        confirmPasswordTf.rightViewMode = .always
        
        let tapGestureRecongnizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTaped(tapGestureRecongnizer2: )))
        imageicon2.isUserInteractionEnabled = true
        imageicon2.addGestureRecognizer(tapGestureRecongnizer2)
    }
    
    @objc func imageTaped(tapGestureRecongnizer2: UITapGestureRecognizer){
        let tappedImage2 = tapGestureRecongnizer2.view as!UIImageView
        if iconClick{
            iconClick = false
            tappedImage2.image = UIImage(named: "openeye")
            confirmPasswordTf.isSecureTextEntry = false
        }
        else{
            iconClick = true
            tappedImage2.image = UIImage(named: "closeeye")
            confirmPasswordTf.isSecureTextEntry = true
        }
    }
    
    @IBAction func usernameChanged(_ sender: Any) {
        if let username = usernameTf.text {
            if let errorMessage = invalidUserName(username) {
                usernameError.text = errorMessage
                usernameError.isHidden = false
                usernameTf.layer.borderColor = UIColor(named: "redControl")?.cgColor
                usernameTf.setupRightSideImage(image: "error", colorName: "redControl")
            } else {
                usernameError.isHidden = true
                usernameTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                usernameTf.setupRightSideImage(image: "done", colorName: "vertDone")
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
            return nil
        }

    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTf.text {
            if let errorMessage = invalidEmail(email) {
                emailError.text = errorMessage
                emailError.isHidden = false
                emailTf.layer.borderColor = UIColor(named: "redControl")?.cgColor
                emailTf.setupRightSideImage(image: "error", colorName: "redControl")
            } else {
                emailError.isHidden = true
                emailTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                emailTf.setupRightSideImage(image: "done", colorName: "vertDone")
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
        if let password = passwordTf.text {
            if let errorMessage = invalidPassword(password) {
                passwordError.text = errorMessage
                passwordError.isHidden = false
                passwordTf.layer.borderColor = UIColor(named: "redControl")?.cgColor
                passwordTf.setupRightSideImage(image: "error", colorName: "redControl")
            } else {
                passwordError.isHidden = true
                passwordTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                passwordTf.setupRightSideImage(image: "done", colorName: "vertDone")
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
    
    @IBAction func confirmPasswordChanged(_ sender: Any) {
        if let password = passwordTf.text,
           let confirmPassword = confirmPasswordTf.text {

            if password == confirmPassword {
                confirmPasswordError.isHidden = true
                confirmPasswordTf.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                confirmPasswordTf.setupRightSideImage(image: "done", colorName: "vertDone")
            } else {
                if LanguageManager.shared.currentLanguage == "fr" {
                    confirmPasswordError.text = "Les 2 mots de passe ne correspondent pas."
                    confirmPasswordTf.layer.borderColor = UIColor(named: "redControl")?.cgColor
                    confirmPasswordTf.setupRightSideImage(image: "error", colorName: "redControl")
                } else {
                    confirmPasswordError.text = "Passwords do not match."
                    confirmPasswordTf.layer.borderColor = UIColor(named: "redControl")?.cgColor
                    confirmPasswordTf.setupRightSideImage(image: "error", colorName: "redControl")
                }
                confirmPasswordError.isHidden = false
            }
        }

        checkForValidForm()
    }

    func checkForValidForm()
    {
        if emailError.isHidden && passwordError.isHidden && usernameError.isHidden && confirmPasswordError.isHidden
        {
            createBtn.isEnabled = true
        }
        else
        {
            createBtn.isEnabled = false
        }
    }

    func resetForm() {
        createBtn.isEnabled = false

        usernameError.isHidden = true
        emailError.isHidden = true
        passwordError.isHidden = true
        confirmPasswordError.isHidden = true
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
    
    @IBAction func registerChildBtnTapped(_ sender: Any) {
        guard let childUsername = usernameTf.text, !childUsername.isEmpty,
              let childEmail = emailTf.text, !childEmail.isEmpty,
              let childPassword = passwordTf.text, !childPassword.isEmpty else {
                  return
              }

        // Fetch additional child information
        loadChildInfo { childInfo in
            let parameters: [String: Any] = [
                "username": childUsername,
                "email": childEmail,
                "password": childPassword,
                "user_agent": "mobile",
                "user_type": "child",
                "gender": childInfo.gender,
                "birthday": childInfo.birthday,
                "email_verification_url": childEmail
            ]
//        let parameters: [String: Any] = [
//            "username": "childUsername",
//            "email": "childEmail@emaill.com",
//            "password": "childPassword",
//            "user_agent": "mobile",
//            "user_type": "child",
//            "gender": "M",
//            "birthday": "1998-12-18",
//            "email_verification_url": "childEmail@emaill.com"
//        ]

            APIManager.shareInstance.registerChildAPI(parameters: parameters) { isSuccess, messageKey in
                if isSuccess {
                    self.showAlert(message: messageKey)
                    self.goToConfirmation(withId: "ChildConfirmationID")
                    UserDefaults.standard.set(childEmail, forKey: "childEmail")
                    UserDefaults.standard.synchronize()
                    self.resetFields()
                } else {
                    self.showAlert(message: messageKey)
                }
            }
        }
    }

//    @IBAction func createBtnTapped(_ sender: Any) {
//        guard let username = self.usernameTf.text, !username.isEmpty else {
//            showAlert(message: "Please enter a username")
//            return
//        }
//        guard let email = self.emailTf.text, !email.isEmpty else {
//            showAlert(message: "Please enter an email")
//            return
//        }
//        guard let password = self.passwordTf.text, !password.isEmpty else {
//            showAlert(message: "Please enter a password")
//            return
//        }
//        guard let confirmPassword = self.confirmPasswordTf.text, !confirmPassword.isEmpty else {
//            showAlert(message: "Please confirm the password")
//            return
//        }
//
//        // Check if passwords match
//        if password != confirmPassword {
//            showAlert(message: "Passwords do not match")
//            return
//        }
//
//
//
//        loadChildInfo { childInfo in
//            // Update the childInfo with user-provided values
//            childInfo.email = email
//            childInfo.username = username
//            childInfo.password = password
//            childInfo.email_verification_url = email
//
//            // Register the child
//            APIManager.shareInstance.registerChildAPI(register: childInfo) { (isSuccess, str) in
//                if isSuccess {
//                    // Child user registered successfully
//                    self.goToConfirmation(withId: "ConfirmationID")
//                } else {
//                    self.showAlert(message: str)
//                }
//            }
//            self.resetFields()
//        }
//    }

    func loadChildInfo(completion: @escaping (ChildRegisterModel) -> Void) {
        guard let savedChildID = UserDefaults.standard.value(forKey: "childID") as? Int else { return }

        APIManager.shareInstance.fetchChild(withID: savedChildID) { child in
            let childInfo = ChildRegisterModel(
                username: child.user?.username ?? "",
                email: child.user?.email ?? "",
                password: "",
                email_verification_url: "",
                gender: child.user?.gender ?? "",
                birthday: child.user?.birthday ?? ""
            )

            completion(childInfo)
        }
    }


}
