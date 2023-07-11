//
//  Register.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 27/2/2023.
//

import UIKit

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
    @IBOutlet weak var genderPickerView: UIPickerView!
        
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentInsetAdjustmentBehavior = .never

        }
    }
    
    let Api: UsersAPIProrotocol = UsersAPI()
    let gender = ["Homme", "Femme"]
    var selected = ""
    var sexe = "M"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        // Set the initial language based on the saved language
            if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
                LanguageManager.shared.currentLanguage = selectedLanguage
            }

            // Update localized strings
            updateLocalizedStrings()
        
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
        //register_google.setupBorderBtns()
    //    register_facebook.setupBorderBtns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLocalizedStrings()
        updateLanguageButtonImage()
    }
    
    func updateLanguageButtonImage() {
        if let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            if selectedLanguage == "fr" {
                changeLanguageBtn.setImage(UIImage(named: "fr_white"), for: .normal)
            } else if selectedLanguage == "en" {
                changeLanguageBtn.setImage(UIImage(named: "eng_white"), for: .normal)
            }
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
            
        welcomeLbl.text = NSLocalizedString("Welcome", tableName: nil, bundle: bundle, value: "", comment: "welcome label")
        createAccLbl.text = NSLocalizedString("create_account", tableName: nil, bundle: bundle, value: "", comment: "sign up label")
        usernameTF.placeholder = NSLocalizedString("your_username", tableName: nil, bundle: bundle, value: "", comment: "username")
        emailTF.placeholder = NSLocalizedString("e_mail", tableName: nil, bundle: bundle, value: "", comment: "email")
        passwordTF.placeholder = NSLocalizedString("Password", tableName: nil, bundle: bundle, value: "", comment: "Password")
        confirmPasswordTF.placeholder = NSLocalizedString("re_type_password", tableName: nil, bundle: bundle, value: "", comment: "Confirm Password")
        registerBtn.setTitle(NSLocalizedString("sign_up", tableName: nil, bundle: bundle, value: "", comment: "sign up"), for: .normal)
        signInBtn.setTitle(NSLocalizedString("Login", tableName: nil, bundle: bundle, value: "", comment: "Login"), for: .normal)
        haveAccLbl.text = NSLocalizedString("text_login", tableName: nil, bundle: bundle, value: "", comment: "text login")
    /*    register_google.setTitle(NSLocalizedString("signup_google", tableName: nil, bundle: bundle, value: "", comment: "sign up google"), for: .normal)
        register_facebook.setTitle(NSLocalizedString("signup_facebook", tableName: nil, bundle: bundle, value: "", comment: "sign up facebook"), for: .normal) */
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
        if selected == "Homme"{
             sexe = "M"
        }else{
            sexe = "F"
        }
        
        
        let register = RegisterModel(username: username, email: email, password: password, gender: sexe)
        APIManager.shareInstance.registerAPI(register: register) { (isSuccess, str) in
            if isSuccess {
                //self.showAlert(message: str)
                self.goToConfirmation(withId: "ConfirmationID")
                UserDefaults.standard.set(email, forKey: "userEmail")
                UserDefaults.standard.synchronize()
            }else {
                self.showAlert(message: str)
            }
        }
        self.resetFields()
    }
    
    
    @IBAction func signInButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "signIn")
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func signUpGoogleTapped(_ sender: Any) {
    }
    
    
    @IBAction func signUpFacebookTapped(_ sender: Any) {
    }
    
    
}

extension UITextField {
    
    func setupLeftSideImages(ImageViewNamed: String) {
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 16, height: 16))
        imageView.image = UIImage(named: ImageViewNamed)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(named: "AccentColor")
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
   //     gradientLayer.colors = [UIColor(red: 0.25, green: 0.56, blue: 0.80, alpha: 1.00).cgColor,UIColor(red: 0.24, green: 0.76, blue: 0.95, alpha: 1.00).cgColor]
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
extension Register: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = gender[row] as! String
    }
    
    
}
